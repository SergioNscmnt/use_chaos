require "test_helper"

class TransicaoPedidoTest < ActiveSupport::TestCase
  setup do
    @usuario = criar_usuario
    @produto = criar_produto(estoque: 5)
    @pedido = criar_pedido(produto: @produto, quantidade: 2)
  end

  test "confirmação baixa estoque uma vez e registra histórico e auditoria" do
    assert_difference [ "MovimentacaoEstoque.count", "HistoricoPedido.count", "RegistroAuditoria.count" ], 1 do
      Pedidos::Transicionar.call(
        pedido: @pedido,
        nova_situacao: "confirmado",
        usuario: @usuario,
        observacao: "Confirmado no atendimento"
      )
    end

    assert_equal 3, @produto.reload.estoque
    assert @pedido.reload.estoque_movimentado?
    assert @pedido.confirmado_em
    assert_equal "confirmado", @pedido.historicos_pedido.last.situacao_nova

    assert_raises(ActiveRecord::RecordInvalid) do
      Pedidos::Transicionar.call(pedido: @pedido, nova_situacao: "confirmado", usuario: @usuario)
    end
    assert_equal 3, @produto.reload.estoque
    assert_equal 1, @produto.movimentacoes_estoque.where(tipo: "baixa_pedido").count
  end

  test "conclusão mantém baixa e cancelamento repõe estoque uma vez" do
    Pedidos::Transicionar.call(pedido: @pedido, nova_situacao: "confirmado", usuario: @usuario)
    Pedidos::Transicionar.call(pedido: @pedido, nova_situacao: "concluido", usuario: @usuario)
    assert_equal 3, @produto.reload.estoque

    Pedidos::Transicionar.call(pedido: @pedido, nova_situacao: "cancelado", usuario: @usuario)
    assert_equal 5, @produto.reload.estoque
    assert @pedido.reload.estoque_reposto?
    assert_equal 1, @produto.movimentacoes_estoque.where(tipo: "reposicao_cancelamento").count
  end

  test "insuficiência reverte toda a confirmação" do
    outro = criar_produto(estoque: 1)
    @pedido.itens_pedido.create!(
      produto: outro,
      categoria: outro.categoria,
      produto_nome: outro.nome,
      produto_sku: outro.sku,
      categoria_nome: outro.categoria.nome,
      quantidade: 2,
      preco_unitario_centavos: outro.preco_centavos,
      custo_unitario_centavos: outro.custo_centavos
    )

    assert_raises(ActiveRecord::RecordInvalid) do
      Pedidos::Transicionar.call(pedido: @pedido, nova_situacao: "confirmado", usuario: @usuario)
    end

    assert_equal 5, @produto.reload.estoque
    assert_equal 1, outro.reload.estoque
    assert @pedido.reload.iniciado?
    assert_not @pedido.estoque_movimentado?
    assert_equal 0, MovimentacaoEstoque.count
  end
end
