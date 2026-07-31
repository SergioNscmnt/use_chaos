class ImagemProduto < ApplicationRecord
  TIPOS_PERMITIDOS = %w[image/jpeg image/png image/webp].freeze
  TAMANHO_MAXIMO = 8.megabytes

  belongs_to :produto, inverse_of: :imagens_produto
  has_one_attached :arquivo

  validates :texto_alternativo, presence: true, length: { maximum: 180 }
  validates :posicao, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :arquivo_valido
  validate :somente_uma_principal

  private

  def arquivo_valido
    unless arquivo.attached?
      errors.add(:arquivo, "é obrigatório")
      return
    end

    errors.add(:arquivo, "deve ser JPEG, PNG ou WebP") unless TIPOS_PERMITIDOS.include?(arquivo.blob.content_type)
    errors.add(:arquivo, "deve ter no máximo 8 MB") if arquivo.blob.byte_size > TAMANHO_MAXIMO
  end

  def somente_uma_principal
    return unless principal? && produto
    return unless produto.imagens_produto.where(principal: true).where.not(id:).exists?

    errors.add(:principal, "já foi definida para outra imagem")
  end
end
