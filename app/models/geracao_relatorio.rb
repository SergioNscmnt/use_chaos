class GeracaoRelatorio < ApplicationRecord
  serialize :filtros, coder: JSON, type: Hash

  belongs_to :usuario_administrativo
  has_one_attached :arquivo

  enum :formato, { csv: "csv", pdf: "pdf" }, validate: true
  enum :situacao, {
    pendente: "pendente",
    processando: "processando",
    concluida: "concluida",
    falhou: "falhou"
  }, validate: true

  validates :filtros, presence: true
end
