class Pedido < ApplicationRecord
  SITUACOES_VENDA = %w[confirmado concluido].freeze

  belongs_to :responsavel, class_name: "UsuarioAdministrativo", optional: true
  has_many :itens_pedido, dependent: :restrict_with_error, inverse_of: :pedido
  has_many :historicos_pedido, -> { order(:created_at, :id) }, dependent: :restrict_with_error

  enum :situacao, {
    iniciado: "iniciado",
    em_atendimento: "em_atendimento",
    confirmado: "confirmado",
    concluido: "concluido",
    cancelado: "cancelado"
  }, validate: true

  validates :numero, :chave_idempotencia, :nome_cliente, :contato_cliente, presence: true
  validates :numero, :chave_idempotencia, uniqueness: true
  validates :aceite_privacidade, acceptance: true
  validates :total_centavos, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_validation :definir_numero, on: :create

  scope :vendas, -> { where(situacao: SITUACOES_VENDA) }
  scope :iniciados_no_periodo, ->(inicio, fim) { where(created_at: inicio..fim) }

  def venda?
    SITUACOES_VENDA.include?(situacao)
  end

  def custo_total_centavos
    itens_pedido.sum(&:custo_total_centavos)
  end

  def lucro_centavos
    total_centavos - custo_total_centavos
  end

  def atrasado?
    (iniciado? || em_atendimento?) &&
      created_at <= Rails.configuration.x.loja.pedido_atrasado_horas.hours.ago
  end

  private

  def definir_numero
    self.numero ||= "ON-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
  end
end
