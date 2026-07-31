module Administracao
  class PainelController < BaseController
    def index
      authorize :painel, :show?
      @filtros = Filtros::Vendas.new(params.permit(:inicio, :fim, :categoria_id, :produto_id, :situacao))
      @metricas = Metricas::Vendas.new(@filtros)
      @resumo = @metricas.resumo
      @categorias = Categoria.ordenadas
      @produtos = Produto.order(:nome)
    end
  end
end
