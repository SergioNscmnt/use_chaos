module Administracao
  class RelatoriosController < BaseController
    def index
      authorize GeracaoRelatorio
      @filtros = Filtros::Vendas.new
      @categorias = Categoria.ordenadas
      @produtos = Produto.order(:nome)
      @geracoes = current_usuario_administrativo.geracoes_relatorio.order(created_at: :desc).limit(20)
    end

    def create
      geracao = current_usuario_administrativo.geracoes_relatorio.new(formato: params[:formato], filtros: filtros.to_h)
      authorize geracao
      apresentador = Relatorios::Vendas::Apresentador.new(filtros)

      if apresentador.quantidade_linhas > Rails.configuration.x.loja.relatorio_assincrono_linhas
        geracao.save!
        GerarRelatorioVendasJob.perform_later(geracao.id)
        Auditoria::Registrar.call(acao: "relatorio.agendado", alvo: geracao, usuario: current_usuario_administrativo, detalhes: { formato: geracao.formato, filtros: filtros.to_h })
        redirect_to administracao_relatorio_path(geracao), notice: "Relatório agendado para processamento."
      else
        enviar_relatorio(apresentador, params[:formato])
      end
    end

    def show
      @geracao = GeracaoRelatorio.find(params[:id])
      authorize @geracao
      if @geracao.concluida? && @geracao.arquivo.attached?
        send_data @geracao.arquivo.download,
          filename: @geracao.arquivo.filename.to_s,
          type: @geracao.arquivo.content_type,
          disposition: "attachment"
      end
    end

    private

    def filtros
      @filtros ||= Filtros::Vendas.new(params.fetch(:filtros, {}).permit(:inicio, :fim, :categoria_id, :produto_id, :situacao))
    end

    def enviar_relatorio(apresentador, formato)
      formato = formato == "pdf" ? "pdf" : "csv"
      conteudo = formato == "pdf" ? Relatorios::Vendas::Pdf.call(apresentador) : Relatorios::Vendas::Csv.call(apresentador)
      Auditoria::Registrar.call(acao: "relatorio.gerado", usuario: current_usuario_administrativo, detalhes: { formato:, filtros: filtros.to_h })
      send_data conteudo,
        filename: "relatorio-vendas-#{Time.zone.today.iso8601}.#{formato}",
        type: formato == "pdf" ? "application/pdf" : "text/csv; charset=utf-8",
        disposition: "attachment"
    end
  end
end
