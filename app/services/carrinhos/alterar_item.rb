module Carrinhos
  class AlterarItem
    def self.call(item:, quantidade:)
      item.produto.with_lock do
        item.update!(quantidade: Integer(quantidade))
        item
      end
    rescue ArgumentError, TypeError
      item.errors.add(:quantidade, "deve ser um número inteiro positivo")
      raise ActiveRecord::RecordInvalid, item
    end
  end
end
