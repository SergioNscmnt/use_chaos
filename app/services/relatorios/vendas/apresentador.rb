module Relatorios
  module Vendas
    class Apresentador
      attr_reader :filtros, :gerado_em, :metricas

      def initialize(filtros)
        @filtros = filtros
        @gerado_em = Time.current
        @metricas = Metricas::Vendas.new(filtros)
      end

      def resumo
        metricas.resumo
      end

      def linhas
        @linhas ||= filtros.itens_venda
          .includes(:pedido)
          .order("pedidos.confirmado_em DESC", :id)
      end

      def quantidade_linhas
        filtros.itens_venda.count
      end

      def titulo
        "Relatório gerencial de vendas"
      end
    end
  end
end
