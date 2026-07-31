class AvaliacaoPolicy < ApplicationPolicy
  def index? = modera?
  def update? = modera?

  private

  def modera?
    usuario&.pode?("moderar_conteudo")
  end
end
