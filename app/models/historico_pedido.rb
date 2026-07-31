class HistoricoPedido < ApplicationRecord
  belongs_to :pedido
  belongs_to :usuario_administrativo, optional: true

  validates :situacao_nova, presence: true
end
