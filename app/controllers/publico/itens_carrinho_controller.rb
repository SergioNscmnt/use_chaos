module Publico
  class ItensCarrinhoController < ApplicationController
    include CarrinhoAtual

    before_action :buscar_item, only: %i[update destroy]

    def create
      produto = Produto.find(params[:produto_id])
      Carrinhos::AdicionarItem.call(carrinho: carrinho_atual, produto:, quantidade: params[:quantidade])
      responder_sucesso("Produto adicionado ao carrinho.")
    rescue ActiveRecord::RecordInvalid => erro
      redirect_back fallback_location: produtos_path, alert: erro.record.errors.full_messages.to_sentence
    end

    def update
      Carrinhos::AlterarItem.call(item: @item, quantidade: params[:quantidade])
      responder_sucesso("Quantidade atualizada.")
    rescue ActiveRecord::RecordInvalid => erro
      redirect_to carrinho_path, alert: erro.record.errors.full_messages.to_sentence
    end

    def destroy
      @item.destroy!
      responder_sucesso("Item removido.")
    end

    private

    def buscar_item
      @item = carrinho_atual.itens_carrinho.find(params[:id])
    end

    def responder_sucesso(mensagem)
      carrinho = carrinho_atual.reload
      respond_to do |format|
        format.html { redirect_to carrinho_path, notice: mensagem }
        format.turbo_stream do
          flash.now[:notice] = mensagem
          render turbo_stream: [
            turbo_stream.replace("atalho-carrinho", partial: "publico/carrinhos/atalho_offcanvas", locals: { carrinho: }),
            turbo_stream.replace("carrinho-offcanvas-conteudo", partial: "publico/carrinhos/conteudo_offcanvas", locals: { carrinho: }),
            turbo_stream.replace("carrinho", partial: "publico/carrinhos/carrinho", locals: { carrinho: }),
            turbo_stream.replace("mensagens", partial: "shared/flash")
          ]
        end
      end
    end
  end
end
