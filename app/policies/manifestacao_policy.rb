class ManifestacaoPolicy < ApplicationPolicy
  def index? = modera?
  def show? = modera?
  def update? = modera?
  def visualizar_contato? = usuario&.pode?("visualizar_dados_pessoais")

  private

  def modera?
    usuario&.pode?("moderar_conteudo")
  end
end
