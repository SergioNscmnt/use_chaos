class PedidoPolicy < ApplicationPolicy
  def index? = gerencia?
  def show? = gerencia?
  def update? = gerencia?
  def alterar_situacao? = gerencia?

  private

  def gerencia?
    usuario&.pode?("gerenciar_pedidos")
  end
end
