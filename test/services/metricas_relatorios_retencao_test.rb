require "test_helper"

class MetricasRelatoriosRetencaoTest < ActiveSupport::TestCase
  setup do
    @produto = criar_produto(preco: 10_000, custo: 4_000)
    @pedido = criar_pedido(
      produto: @produto,
      situacao: "confirmado",
      quantidade: 2,
      confirmado_em: Time.current
    )
    @filtros = Filtros::Vendas.new(inicio: Time.zone.today - 1.day, fim: Time.zone.today)
  end

  test "calcula indicadores financeiros e funil com snapshots" do
    cancelado = criar_pedido(
      produto: @produto,
      situacao: "cancelado",
      quantidade: 1,
      confirmado_em: Time.current
    )
    cancelado.update_column(:created_at, Time.current)

    resumo = Metricas::Vendas.new(@filtros).resumo
    assert_equal 1, resumo[:quantidade_vendas]
    assert_equal 20_000, resumo[:receita_bruta_centavos]
    assert_equal 8_000, resumo[:custo_centavos]
    assert_equal 12_000, resumo[:lucro_bruto_centavos]
    assert_equal 60.0, resumo[:margem_percentual]
    assert_equal 20_000, resumo[:ticket_medio_centavos]
    assert_equal 2, resumo[:pedidos_iniciados]
    assert_equal 100.0, resumo[:conversao_percentual]
  end

  test "retorna zeros em conjunto vazio" do
    filtros = Filtros::Vendas.new(inicio: 10.years.ago.to_date, fim: 9.years.ago.to_date)
    resumo = Metricas::Vendas.new(filtros).resumo

    assert_equal 0, resumo[:receita_bruta_centavos]
    assert_equal 0, resumo[:ticket_medio_centavos]
    assert_equal 0.0, resumo[:margem_percentual]
    assert_equal 0.0, resumo[:conversao_percentual]
  end

  test "pedido concluído deficitário explicita prejuízo sem perder o funil" do
    produto = criar_produto(preco: 4_000, custo: 6_000)
    criar_pedido(
      produto:,
      situacao: "concluido",
      quantidade: 2,
      confirmado_em: Time.current
    )
    filtros = Filtros::Vendas.new(
      inicio: Time.zone.yesterday.to_date,
      fim: Time.zone.today,
      produto_id: produto.id
    )

    resumo = Metricas::Vendas.new(filtros).resumo
    assert_equal 1, resumo[:quantidade_vendas]
    assert_equal 8_000, resumo[:receita_bruta_centavos]
    assert_equal 12_000, resumo[:custo_centavos]
    assert_equal(-4_000, resumo[:lucro_bruto_centavos])
    assert_equal 4_000, resumo[:prejuizo_centavos]
    assert_equal 1, resumo[:pedidos_concluidos]
    assert_equal 100.0, resumo[:conversao_percentual]
  end

  test "CSV e PDF compartilham dados e preservam caracteres portugueses" do
    apresentador = Relatorios::Vendas::Apresentador.new(@filtros)
    csv = Relatorios::Vendas::Csv.call(apresentador)
    pdf = Relatorios::Vendas::Pdf.call(apresentador)

    assert csv.start_with?("\uFEFF")
    assert_includes csv, "Relatório gerencial de vendas"
    assert_includes csv, @produto.nome
    assert_includes csv, "R$ 200,00"
    assert pdf.start_with?("%PDF")
    assert_operator pdf.bytesize, :>, 1_000
  end

  test "retenção anonimiza dados vencidos, preserva recentes e registra execução" do
    antiga = Rails.configuration.x.retencao.pedidos_meses.months.ago - 1.day
    @pedido.update_columns(
      nome_cliente: "Pessoa Antiga",
      contato_cliente: "antigo@example.test",
      created_at: antiga
    )
    recente = criar_pedido(produto: @produto)

    assert_difference "RegistroAuditoria.where(acao: 'retencao.executada').count", 1 do
      AplicarRetencaoDadosJob.perform_now
    end

    assert_equal "Cliente anonimizado", @pedido.reload.nome_cliente
    assert_equal "anonimizado", @pedido.contato_cliente
    assert_equal "Cliente Teste", recente.reload.nome_cliente
  end

  test "consulta gerencial mantém quantidade constante de queries com mil vendas" do
    produto = criar_produto(preco: 15_000, custo: 6_000)
    prefixo = "volume-#{SecureRandom.hex(4)}"
    agora = Time.current
    Pedido.insert_all!(
      1_000.times.map do |indice|
        {
          numero: "VOL-#{prefixo}-#{indice}",
          chave_idempotencia: "#{prefixo}-#{indice}",
          nome_cliente: "Cliente de volume",
          contato_cliente: "volume@example.test",
          aceite_privacidade: true,
          situacao: "confirmado",
          confirmado_em: agora,
          total_centavos: 15_000,
          created_at: agora,
          updated_at: agora
        }
      end
    )
    pedidos_ids = Pedido.where("chave_idempotencia LIKE ?", "#{prefixo}-%").pluck(:id)
    ItemPedido.insert_all!(
      pedidos_ids.map do |pedido_id|
        {
          pedido_id:,
          produto_id: produto.id,
          categoria_id: produto.categoria_id,
          produto_nome: produto.nome,
          produto_sku: produto.sku,
          categoria_nome: produto.categoria.nome,
          quantidade: 1,
          preco_unitario_centavos: 15_000,
          custo_unitario_centavos: 6_000,
          created_at: agora,
          updated_at: agora
        }
      end
    )

    filtros = Filtros::Vendas.new(
      inicio: Time.zone.today,
      fim: Time.zone.today,
      produto_id: produto.id
    )
    consultas = 0
    contador = lambda do |_nome, _inicio, _fim, _id, dados|
      consultas += 1 unless dados[:cached] || dados[:name].match?(/SCHEMA|TRANSACTION/)
    end
    inicio = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    resumo = ActiveSupport::Notifications.subscribed(contador, "sql.active_record") do
      Metricas::Vendas.new(filtros).resumo
    end
    duracao = Process.clock_gettime(Process::CLOCK_MONOTONIC) - inicio

    assert_equal 1_000, resumo[:quantidade_vendas]
    assert_equal 15_000_000, resumo[:receita_bruta_centavos]
    assert_operator consultas, :<=, 8
    assert_operator duracao, :<, 5
  end
end
