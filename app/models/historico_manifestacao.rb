class HistoricoManifestacao < ApplicationRecord
  belongs_to :manifestacao
  belongs_to :usuario_administrativo, optional: true

  validates :situacao_nova, presence: true
end
