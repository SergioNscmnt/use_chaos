class UsuarioAdministrativoPolicy < ApplicationPolicy
  def index? = administra?
  def show? = administra?
  def create? = administra?
  def update? = administra?

  private

  def administra?
    usuario&.pode?("administrar_usuarios")
  end
end
