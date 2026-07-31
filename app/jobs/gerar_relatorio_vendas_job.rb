class GerarRelatorioVendasJob < ApplicationJob
  queue_as :default

  def perform(geracao_id)
    geracao = GeracaoRelatorio.find(geracao_id)
    geracao.processando!
    filtros = Filtros::Vendas.new(geracao.filtros)
    apresentador = Relatorios::Vendas::Apresentador.new(filtros)
    conteudo = geracao.csv? ? Relatorios::Vendas::Csv.call(apresentador) : Relatorios::Vendas::Pdf.call(apresentador)
    geracao.arquivo.attach(
      io: StringIO.new(conteudo),
      filename: "relatorio-vendas-#{geracao.id}.#{geracao.formato}",
      content_type: geracao.csv? ? "text/csv; charset=utf-8" : "application/pdf"
    )
    geracao.update!(situacao: "concluida", gerado_em: Time.current, erro: nil)
  rescue StandardError => erro
    geracao&.update!(situacao: "falhou", erro: erro.message)
    raise
  end
end
