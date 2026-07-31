module Publico
  class CarrinhosController < ApplicationController
    include CarrinhoAtual

    def show
      @carrinho = carrinho_atual
    end
  end
end
