class Produto < ApplicationRecord
  serialize :caracteristicas, coder: JSON, type: Array

  belongs_to :categoria
  has_many :imagens_produto, -> { order(:posicao, :id) }, dependent: :destroy, inverse_of: :produto
  has_many :avaliacoes, dependent: :restrict_with_error
  has_many :movimentacoes_estoque, dependent: :restrict_with_error
  has_many :itens_carrinho, dependent: :restrict_with_error
  has_many :itens_pedido, dependent: :restrict_with_error

  accepts_nested_attributes_for :imagens_produto, allow_destroy: true, reject_if: :all_blank

  validates :nome, :slug, :sku, :descricao, presence: true
  validates :slug, :sku, uniqueness: { case_sensitive: false }
  validates :preco_centavos, :custo_centavos,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :estoque, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :limiar_estoque_baixo,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 },
    allow_nil: true

  before_validation :normalizar_identificadores

  scope :publicados, -> { joins(:categoria).where(ativo: true, publicado: true, categorias: { ativa: true }) }
  scope :compraveis, -> { publicados.where(disponivel: true).where("produtos.estoque > 0") }
  scope :destaques, -> { publicados.where(destaque: true) }
  scope :lancamentos, -> {
    publicados.order(Arel.sql("COALESCE(produtos.lancamento_em, produtos.created_at) DESC"))
  }

  def compravel?
    ativo? && publicado? && disponivel? && estoque.positive? && categoria.ativa?
  end

  def sem_estoque?
    estoque.zero?
  end

  def estoque_baixo?
    estoque <= (limiar_estoque_baixo || Rails.configuration.x.loja.estoque_baixo)
  end

  def avaliacao_media
    avaliacoes.aprovadas.average(:nota)&.to_f
  end

  def quantidade_avaliacoes
    avaliacoes.aprovadas.count
  end

  private

  def normalizar_identificadores
    self.slug = nome.to_s.parameterize if slug.blank? && nome.present?
    self.sku = sku.to_s.strip.upcase
  end
end
