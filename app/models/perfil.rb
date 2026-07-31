class Perfil < ApplicationRecord
  PERMISSOES_VALIDAS = %w[
    administrar_usuarios gerenciar_catalogo gerenciar_pedidos
    moderar_conteudo visualizar_metricas gerar_relatorios
    visualizar_dados_pessoais
  ].freeze

  has_many :usuarios_administrativos, dependent: :restrict_with_error
  serialize :permissoes, coder: JSON, type: Array

  validates :nome, presence: true, uniqueness: { case_sensitive: false }
  validate :permissoes_conhecidas

  def possui?(permissao)
    permissoes.include?("*") || permissoes.include?(permissao.to_s)
  end

  private

  def permissoes_conhecidas
    invalidas = Array(permissoes) - PERMISSOES_VALIDAS - [ "*" ]
    errors.add(:permissoes, "contêm valores desconhecidos: #{invalidas.join(', ')}") if invalidas.any?
  end
end
