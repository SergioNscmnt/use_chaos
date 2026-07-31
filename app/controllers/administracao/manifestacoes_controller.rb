module Administracao
  class ManifestacoesController < BaseController
    before_action :buscar_manifestacao, only: %i[show update]

    def index
      authorize Manifestacao
      @manifestacoes = Manifestacao.includes(:responsavel).order(created_at: :desc)
      @manifestacoes = @manifestacoes.where(tipo: params[:tipo]) if params[:tipo].present?
      @manifestacoes = @manifestacoes.where(situacao: params[:situacao]) if params[:situacao].present?
    end

    def show
      authorize @manifestacao
      @pode_ver_contato = policy(@manifestacao).visualizar_contato?
    end

    def update
      authorize @manifestacao
      anterior = @manifestacao.situacao
      @manifestacao.assign_attributes(manifestacao_params)
      @manifestacao.responsavel ||= current_usuario_administrativo
      @manifestacao.tratada_em = Time.current if @manifestacao.tratada?

      Manifestacao.transaction do
        @manifestacao.save!
        @manifestacao.historicos_manifestacao.create!(
          situacao_anterior: anterior,
          situacao_nova: @manifestacao.situacao,
          observacao: @manifestacao.observacao_interna,
          usuario_administrativo: current_usuario_administrativo
        )
        Auditoria::Registrar.call(acao: "manifestacao.atualizada", alvo: @manifestacao, usuario: current_usuario_administrativo, anterior: { situacao: anterior }, novo: { situacao: @manifestacao.situacao })
      end
      redirect_to administracao_manifestacao_path(@manifestacao), notice: "Manifestação atualizada."
    end

    private

    def buscar_manifestacao
      @manifestacao = Manifestacao.find(params[:id])
    end

    def manifestacao_params
      params.expect(manifestacao: %i[situacao responsavel_id observacao_interna])
    end
  end
end
