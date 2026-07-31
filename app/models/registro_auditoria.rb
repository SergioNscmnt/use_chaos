class RegistroAuditoria < ApplicationRecord
  serialize :dados_anteriores, coder: JSON, type: Hash
  serialize :dados_novos, coder: JSON, type: Hash
  serialize :detalhes, coder: JSON, type: Hash

  belongs_to :usuario_administrativo, optional: true
  belongs_to :alvo, polymorphic: true, optional: true

  validates :acao, presence: true
end
