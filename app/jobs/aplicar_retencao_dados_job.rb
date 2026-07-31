class AplicarRetencaoDadosJob < ApplicationJob
  queue_as :default

  def perform
    agora = Time.current
    pedidos = Pedido.where(created_at: ...Rails.configuration.x.retencao.pedidos_meses.months.ago)
    manifestacoes = Manifestacao.where(created_at: ...Rails.configuration.x.retencao.manifestacoes_meses.months.ago)
    avaliacoes = Avaliacao.where(created_at: ...Rails.configuration.x.retencao.avaliacoes_meses.months.ago)
    auditorias = RegistroAuditoria.where(created_at: ...Rails.configuration.x.retencao.auditoria_meses.months.ago)

    contagens = {
      pedidos_anonimizados: pedidos.update_all(nome_cliente: "Cliente anonimizado", contato_cliente: "anonimizado", updated_at: agora),
      manifestacoes_anonimizadas: manifestacoes.update_all(contato: nil, origem_hash: nil, updated_at: agora),
      avaliacoes_anonimizadas: avaliacoes.update_all(nome_autor: nil, origem_hash: nil, updated_at: agora),
      auditorias_eliminadas: auditorias.delete_all
    }
    Auditoria::Registrar.call(acao: "retencao.executada", detalhes: contagens)
    contagens
  end
end
