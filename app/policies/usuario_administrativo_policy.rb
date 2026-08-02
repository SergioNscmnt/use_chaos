class UsuarioAdministrativoPolicy < ApplicationPolicy
  def index? = administra?
  def show? = administra?
  def create? = administra?
  def update? = administra?
  def atualizar_propria_conta? = usuario.present? && registro == usuario

  private

  def administra?
    usuario&.pode?("administrar_usuarios")
  end
end
