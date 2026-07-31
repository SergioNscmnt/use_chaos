class Categoria < ApplicationRecord
  has_many :produtos, dependent: :restrict_with_error

  validates :nome, :slug, presence: true
  validates :nome, :slug, uniqueness: { case_sensitive: false }
  validates :posicao, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_validation :definir_slug, if: -> { slug.blank? && nome.present? }

  scope :ativas, -> { where(ativa: true) }
  scope :ordenadas, -> { order(:posicao, :nome) }

  private

  def definir_slug
    self.slug = nome.parameterize
  end
end
