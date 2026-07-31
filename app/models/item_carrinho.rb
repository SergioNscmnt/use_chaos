class ItemCarrinho < ApplicationRecord
  belongs_to :carrinho, inverse_of: :itens_carrinho
  belongs_to :produto

  validates :produto_id, uniqueness: { scope: :carrinho_id }
  validates :quantidade, numericality: { only_integer: true, greater_than: 0 }
  validates :preco_unitario_centavos_observado,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :quantidade_disponivel

  def subtotal_centavos
    preco_unitario_centavos_observado * quantidade
  end

  def preco_alterado?
    preco_unitario_centavos_observado != produto.preco_centavos
  end

  def elegivel?
    produto.compravel? && quantidade <= produto.estoque && !preco_alterado?
  end

  private

  def quantidade_disponivel
    return unless produto && quantidade
    return if quantidade <= produto.estoque

    errors.add(:quantidade, "não pode superar o estoque disponível (#{produto.estoque})")
  end
end
