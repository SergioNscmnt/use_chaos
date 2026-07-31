class Carrinho < ApplicationRecord
  has_many :itens_carrinho, dependent: :destroy, inverse_of: :carrinho
  has_many :produtos, through: :itens_carrinho

  validates :token, presence: true, uniqueness: true
  validates :expira_em, presence: true

  before_validation :definir_token, on: :create
  before_validation :definir_expiracao, on: :create

  scope :expirados, -> { where(expira_em: ..Time.current) }

  def expirado?
    expira_em <= Time.current
  end

  def renovar!
    update!(expira_em: Rails.configuration.x.loja.carrinho_expira_dias.days.from_now)
  end

  def total_centavos
    itens_carrinho.sum(&:subtotal_centavos)
  end

  def elegivel_para_checkout?
    itens_carrinho.any? && itens_carrinho.all?(&:elegivel?)
  end

  private

  def definir_token
    self.token ||= SecureRandom.urlsafe_base64(32)
  end

  def definir_expiracao
    self.expira_em ||= Rails.configuration.x.loja.carrinho_expira_dias.days.from_now
  end
end
