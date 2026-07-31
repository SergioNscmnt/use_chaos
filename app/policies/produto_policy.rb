class ProdutoPolicy < ApplicationPolicy
  def index? = gerencia?
  def show? = gerencia?
  def create? = gerencia?
  def update? = gerencia?
  def destroy? = gerencia?
  def ajustar_estoque? = gerencia?

  private

  def gerencia?
    usuario&.pode?("gerenciar_catalogo")
  end
end
