module Auditoria
  class Registrar
    def self.call(acao:, alvo: nil, usuario: nil, anterior: nil, novo: nil, detalhes: nil, endereco_ip: nil)
      RegistroAuditoria.create!(
        acao:,
        alvo:,
        usuario_administrativo: usuario,
        dados_anteriores: anterior,
        dados_novos: novo,
        detalhes:,
        endereco_ip:
      )
    end
  end
end
