class GeracaoRelatorioPolicy < ApplicationPolicy
  def index? = gera?
  def show?
    gera? && (registro.usuario_administrativo_id == usuario.id || usuario.pode?("*"))
  end
  def create? = gera?

  private

  def gera?
    usuario&.pode?("gerar_relatorios")
  end
end
