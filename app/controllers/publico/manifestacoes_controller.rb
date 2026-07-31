module Publico
  class ManifestacoesController < ApplicationController
    def new
      @manifestacao = Manifestacao.new(tipo: "sugestao")
    end

    def create
      @manifestacao = Manifestacao.new(manifestacao_params)
      @manifestacao.mensagem = helpers.sanitize(@manifestacao.mensagem, tags: [])
      @manifestacao.contato = helpers.sanitize(@manifestacao.contato, tags: [])
      @manifestacao.origem_hash = Digest::SHA256.hexdigest([ request.remote_ip, request.user_agent, Rails.application.secret_key_base ].join(":"))

      if @manifestacao.save
        redirect_to new_manifestacao_path, notice: "Manifestação recebida. Obrigado por contribuir."
      else
        render :new, status: :unprocessable_content
      end
    end

    private

    def manifestacao_params
      params.expect(manifestacao: %i[tipo categoria mensagem contato])
    end
  end
end
