module Administracao
  class AvaliacoesController < BaseController
    before_action :buscar_avaliacao, only: :update

    def index
      authorize Avaliacao
      @avaliacoes = Avaliacao.includes(:produto, :moderada_por).recentes
      @avaliacoes = @avaliacoes.where(situacao: params[:situacao]) if params[:situacao].present?
    end

    def update
      authorize @avaliacao
      situacao = params.expect(avaliacao: :situacao)[:situacao]
      @avaliacao.update!(situacao:, moderada_por: current_usuario_administrativo, moderada_em: Time.current)
      Auditoria::Registrar.call(acao: "avaliacao.#{situacao}", alvo: @avaliacao, usuario: current_usuario_administrativo, novo: { situacao: })
      redirect_to administracao_avaliacoes_path, notice: "Avaliação moderada com sucesso."
    end

    private

    def buscar_avaliacao
      @avaliacao = Avaliacao.find(params[:id])
    end
  end
end
