class PainelPolicy < ApplicationPolicy
  def show?
    usuario&.pode?("visualizar_metricas")
  end
end
