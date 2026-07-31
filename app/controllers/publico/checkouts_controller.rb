module Publico
  class CheckoutsController < ApplicationController
    include CarrinhoAtual

    def new
      redirect_to carrinho_path, alert: "Revise o carrinho antes de continuar." and return unless carrinho_atual.elegivel_para_checkout?

      @pedido = Pedido.new
      @chave_idempotencia = SecureRandom.uuid
    end

    def create
      resultado = Checkout::CriarPedido.call(carrinho: carrinho_atual, atributos: checkout_params.to_h.symbolize_keys)
      @pedido = resultado.pedido
      @url_whatsapp = resultado.url_whatsapp
      render :sucesso, status: :created
    rescue Checkout::Erro => erro
      redirect_to carrinho_path, alert: ([ erro.message ] + erro.detalhes).join(" ")
    rescue ActiveRecord::RecordInvalid => erro
      @pedido = erro.record
      @chave_idempotencia = checkout_params[:chave_idempotencia]
      render :new, status: :unprocessable_content
    end

    private

    def checkout_params
      params.expect(checkout: %i[nome_cliente contato_cliente aceite_privacidade chave_idempotencia])
    end
  end
end
