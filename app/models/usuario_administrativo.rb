class UsuarioAdministrativo < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  belongs_to :perfil
  has_many :registros_auditoria, dependent: :nullify
  has_many :geracoes_relatorio, dependent: :restrict_with_error

  validates :nome, presence: true, length: { maximum: 120 }
  validates :ativo, inclusion: { in: [ true, false ] }
  validates :whatsapp,
    format: { with: /\A\d{10,15}\z/, message: "deve conter entre 10 e 15 dígitos" },
    allow_blank: true

  scope :ativos, -> { where(ativo: true) }

  def pode?(permissao)
    ativo? && perfil.possui?(permissao)
  end

  def active_for_authentication?
    super && ativo?
  end

  def inactive_message
    ativo? ? super : :inactive
  end

  def whatsapp=(valor)
    super(valor.to_s.gsub(/\D/, "").presence)
  end
end
