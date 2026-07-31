class Avaliacao < ApplicationRecord
  belongs_to :produto
  belongs_to :moderada_por, class_name: "UsuarioAdministrativo", optional: true

  enum :situacao, {
    pendente: "pendente",
    aprovada: "aprovada",
    rejeitada: "rejeitada",
    oculta: "oculta"
  }, validate: true

  validates :nota, numericality: { only_integer: true, in: 1..5 }
  validates :comentario, presence: true, length: { in: 10..1_500 }
  validates :nome_autor, length: { maximum: 120 }, allow_blank: true

  scope :aprovadas, -> { where(situacao: "aprovada") }
  scope :recentes, -> { order(created_at: :desc) }
end
