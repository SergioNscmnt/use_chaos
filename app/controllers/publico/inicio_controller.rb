module Publico
  class InicioController < ApplicationController
    def index
      @categorias = Categoria.ativas.ordenadas
      @destaques = Produto.destaques.includes(:categoria, imagens_produto: { arquivo_attachment: :blob }).limit(6)
      @lancamentos = Produto.lancamentos.includes(:categoria, imagens_produto: { arquivo_attachment: :blob }).limit(6)
    end
  end
end
