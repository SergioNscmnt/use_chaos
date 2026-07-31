class ItemPedido < ApplicationRecord
  belongs_to :pedido, inverse_of: :itens_pedido
  belongs_to :produto
  belongs_to :categoria

  validates :produto_nome, :produto_sku, :categoria_nome, presence: true
  validates :quantidade, numericality: { only_integer: true, greater_than: 0 }
  validates :preco_unitario_centavos, :custo_unitario_centavos,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def subtotal_centavos
    preco_unitario_centavos * quantidade
  end

  def custo_total_centavos
    custo_unitario_centavos * quantidade
  end
end
