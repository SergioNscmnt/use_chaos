module Publico
  class AvaliacoesController < ApplicationController
    def create
      produto = Produto.publicados.find_by!(slug: params[:produto_slug])
      avaliacao = produto.avaliacoes.new(avaliacao_params)
      avaliacao.comentario = helpers.sanitize(avaliacao.comentario, tags: [])
      avaliacao.nome_autor = helpers.sanitize(avaliacao.nome_autor, tags: [])
      avaliacao.origem_hash = origem_hash

      if avaliacao.save
        redirect_to produto_path(produto.slug, anchor: "titulo-avaliacoes"), notice: "Avaliação recebida e enviada para moderação."
      else
        redirect_to produto_path(produto.slug, anchor: "titulo-avaliacoes"), alert: avaliacao.errors.full_messages.to_sentence
      end
    end

    private

    def avaliacao_params
      params.expect(avaliacao: %i[nome_autor nota comentario])
    end

    def origem_hash
      Digest::SHA256.hexdigest([ request.remote_ip, request.user_agent, Rails.application.secret_key_base ].join(":"))
    end
  end
end
