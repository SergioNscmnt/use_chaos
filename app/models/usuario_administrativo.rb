class UsuarioAdministrativo < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  belongs_to :perfil
  has_many :registros_auditoria, dependent: :nullify
  has_many :geracoes_relatorio, dependent: :restrict_with_error

  validates :nome, presence: true, length: { maximum: 120 }
  validates :ativo, inclusion: { in: [ true, false ] }

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
end
