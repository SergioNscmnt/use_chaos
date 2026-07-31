module Estoque
  class Ajustar
    def self.call(produto:, quantidade:, motivo:, usuario:, tipo: "ajuste_administrativo", origem: nil)
      produto.with_lock do
        nova_quantidade = Integer(quantidade)
        raise ActiveRecord::RecordInvalid, produto if nova_quantidade.negative?

        anterior = produto.estoque
        produto.update!(estoque: nova_quantidade)
        movimentacao = produto.movimentacoes_estoque.create!(
          tipo:,
          quantidade_anterior: anterior,
          quantidade_nova: nova_quantidade,
          motivo:,
          usuario_administrativo: usuario,
          origem:
        )
        Auditoria::Registrar.call(
          acao: "estoque.ajustado",
          alvo: produto,
          usuario:,
          anterior: { estoque: anterior },
          novo: { estoque: nova_quantidade },
          detalhes: { motivo:, movimentacao_id: movimentacao.id }
        )
        movimentacao
      end
    rescue ArgumentError, TypeError
      produto.errors.add(:estoque, "deve ser um número inteiro não negativo")
      raise ActiveRecord::RecordInvalid, produto
    end
  end
end
