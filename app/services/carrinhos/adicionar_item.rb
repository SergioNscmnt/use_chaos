module Carrinhos
  class AdicionarItem
    def self.call(carrinho:, produto:, quantidade:)
      produto.with_lock do
        quantidade = Integer(quantidade)
        raise ActiveRecord::RecordInvalid, produto unless produto.compravel?

        item = carrinho.itens_carrinho.find_or_initialize_by(produto:)
        item.quantidade = item.quantidade.to_i + quantidade
        item.preco_unitario_centavos_observado = produto.preco_centavos
        item.save!
        item
      end
    rescue ArgumentError, TypeError
      produto.errors.add(:base, "Quantidade inválida.")
      raise ActiveRecord::RecordInvalid, produto
    end
  end
end
