module Metricas
  class Vendas
    EXPRESSOES_SOMA = {
      "preco_unitario_centavos" => Arel.sql(
        "itens_pedido.preco_unitario_centavos * itens_pedido.quantidade"
      ),
      "custo_unitario_centavos" => Arel.sql(
        "itens_pedido.custo_unitario_centavos * itens_pedido.quantidade"
      )
    }.freeze

    attr_reader :filtros

    def initialize(filtros)
      @filtros = filtros
    end

    def resumo
      @resumo ||= begin
        receita = soma_itens("preco_unitario_centavos")
        custo = soma_itens("custo_unitario_centavos")
        lucro = receita - custo
        vendas = filtros.pedidos_venda.distinct.count
        iniciados = filtros.pedidos_funil.count
        convertidos = filtros.pedidos_funil.where.not(confirmado_em: nil).count
        {
          quantidade_vendas: vendas,
          receita_bruta_centavos: receita,
          custo_centavos: custo,
          lucro_bruto_centavos: lucro,
          prejuizo_centavos: lucro.negative? ? lucro.abs : 0,
          margem_percentual: receita.zero? ? 0.0 : (lucro.to_f / receita * 100).round(2),
          ticket_medio_centavos: vendas.zero? ? 0 : (receita.to_f / vendas).round,
          pedidos_iniciados: iniciados,
          pedidos_confirmados: filtros.pedidos_funil.where(situacao: "confirmado").count,
          pedidos_concluidos: filtros.pedidos_funil.where(situacao: "concluido").count,
          pedidos_cancelados: filtros.pedidos_funil.where(situacao: "cancelado").count,
          conversao_percentual: iniciados.zero? ? 0.0 : (convertidos.to_f / iniciados * 100).round(2)
        }
      end
    end

    def produtos_mais_vendidos(limite: 10)
      filtros.itens_venda
        .group(:produto_id, :produto_nome)
        .order(Arel.sql("SUM(quantidade) DESC"))
        .limit(limite)
        .sum(:quantidade)
    end

    def categorias_mais_vendidas(limite: 10)
      filtros.itens_venda
        .group(:categoria_id, :categoria_nome)
        .order(Arel.sql("SUM(quantidade) DESC"))
        .limit(limite)
        .sum(:quantidade)
    end

    def produtos_mais_avaliados(limite: 10)
      Avaliacao.aprovadas
        .joins(:produto)
        .group("produtos.id", "produtos.nome")
        .having("COUNT(avaliacoes.id) > 0")
        .order(Arel.sql("AVG(avaliacoes.nota) DESC, COUNT(avaliacoes.id) DESC"))
        .limit(limite)
        .pluck("produtos.nome", Arel.sql("AVG(avaliacoes.nota)"), Arel.sql("COUNT(avaliacoes.id)"))
    end

    def estoque_baixo(limite: 20)
      Produto.where(ativo: true)
        .where("estoque <= COALESCE(limiar_estoque_baixo, ?)", Rails.configuration.x.loja.estoque_baixo)
        .order(:estoque, :nome)
        .limit(limite)
    end

    private

    def soma_itens(campo)
      filtros.itens_venda.sum(EXPRESSOES_SOMA.fetch(campo)).to_i
    end
  end
end
