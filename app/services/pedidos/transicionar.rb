module Pedidos
  class Transicionar
    TRANSICOES = {
      "iniciado" => %w[em_atendimento confirmado cancelado],
      "em_atendimento" => %w[confirmado cancelado],
      "confirmado" => %w[concluido cancelado],
      "concluido" => %w[cancelado],
      "cancelado" => []
    }.freeze

    def self.call(pedido:, nova_situacao:, usuario:, observacao: nil)
      nova_situacao = nova_situacao.to_s
      Pedido.transaction do
        pedido.lock!
        anterior = pedido.situacao
        unless TRANSICOES.fetch(anterior).include?(nova_situacao)
          pedido.errors.add(:situacao, "não pode mudar de #{anterior.humanize} para #{nova_situacao.humanize}")
          raise ActiveRecord::RecordInvalid, pedido
        end

        movimentar_estoque!(pedido, nova_situacao, usuario)
        atributos = { situacao: nova_situacao, responsavel: usuario }
        atributos[:confirmado_em] = Time.current if nova_situacao == "confirmado" && pedido.confirmado_em.nil?
        atributos[:concluido_em] = Time.current if nova_situacao == "concluido"
        atributos[:cancelado_em] = Time.current if nova_situacao == "cancelado"
        pedido.update!(atributos)
        pedido.historicos_pedido.create!(
          situacao_anterior: anterior,
          situacao_nova: nova_situacao,
          observacao:,
          usuario_administrativo: usuario
        )
        Auditoria::Registrar.call(
          acao: "pedido.situacao_alterada",
          alvo: pedido,
          usuario:,
          anterior: { situacao: anterior },
          novo: { situacao: nova_situacao },
          detalhes: { observacao: }
        )
      end
      pedido
    end

    def self.movimentar_estoque!(pedido, nova_situacao, usuario)
      if nova_situacao == "confirmado" && !pedido.estoque_movimentado?
        baixar_estoque!(pedido, usuario)
      elsif nova_situacao == "cancelado" && pedido.estoque_movimentado? && !pedido.estoque_reposto?
        repor_estoque!(pedido, usuario)
      end
    end
    private_class_method :movimentar_estoque!

    def self.baixar_estoque!(pedido, usuario)
      pedido.itens_pedido.order(:produto_id).each do |item|
        produto = Produto.lock.find(item.produto_id)
        if produto.estoque < item.quantidade
          pedido.errors.add(:base, "#{produto.nome} possui somente #{produto.estoque} unidade(s)")
          raise ActiveRecord::RecordInvalid, pedido
        end
        anterior = produto.estoque
        produto.update!(estoque: anterior - item.quantidade)
        produto.movimentacoes_estoque.create!(
          tipo: "baixa_pedido",
          quantidade_anterior: anterior,
          quantidade_nova: produto.estoque,
          motivo: "Confirmação do pedido #{pedido.numero}",
          usuario_administrativo: usuario,
          origem: pedido
        )
      end
      pedido.update!(estoque_movimentado: true)
    end
    private_class_method :baixar_estoque!

    def self.repor_estoque!(pedido, usuario)
      pedido.itens_pedido.order(:produto_id).each do |item|
        produto = Produto.lock.find(item.produto_id)
        anterior = produto.estoque
        produto.update!(estoque: anterior + item.quantidade)
        produto.movimentacoes_estoque.create!(
          tipo: "reposicao_cancelamento",
          quantidade_anterior: anterior,
          quantidade_nova: produto.estoque,
          motivo: "Cancelamento do pedido #{pedido.numero}",
          usuario_administrativo: usuario,
          origem: pedido
        )
      end
      pedido.update!(estoque_reposto: true)
    end
    private_class_method :repor_estoque!
  end
end
