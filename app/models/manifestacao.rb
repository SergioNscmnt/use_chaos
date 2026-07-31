class Manifestacao < ApplicationRecord
  belongs_to :responsavel, class_name: "UsuarioAdministrativo", optional: true
  has_many :historicos_manifestacao, -> { order(:created_at, :id) }, dependent: :destroy

  enum :tipo, { sugestao: "sugestao", feedback: "feedback" }, validate: true
  enum :situacao, {
    nova: "nova",
    em_analise: "em_analise",
    tratada: "tratada",
    arquivada: "arquivada"
  }, validate: true

  validates :categoria, presence: true, length: { maximum: 80 }
  validates :mensagem, presence: true, length: { in: 10..3_000 }
  validates :contato, length: { maximum: 180 }, allow_blank: true
end
