module Filtros
  class Vendas
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :inicio, :date
    attribute :fim, :date
    attribute :categoria_id, :integer
    attribute :produto_id, :integer
    attribute :situacao, :string

    def initialize(attributes = {})
      super
      self.inicio ||= 30.days.ago.to_date
      self.fim ||= Time.zone.today
    end

    def periodo
      inicio.beginning_of_day..fim.end_of_day
    end

    def pedidos_funil
      scope = Pedido.where(created_at: periodo)
      scope = scope.where(situacao:) if situacao.present?
      filtrar_pedidos_por_item(scope)
    end

    def pedidos_venda
      scope = Pedido.vendas.where(confirmado_em: periodo)
      scope = scope.where(situacao:) if situacao.present?
      filtrar_pedidos_por_item(scope)
    end

    def itens_venda
      scope = ItemPedido.joins(:pedido)
        .merge(Pedido.vendas.where(confirmado_em: periodo))
      scope = scope.where(pedidos: { situacao: }) if situacao.present?
      scope = scope.where(categoria_id:) if categoria_id.present?
      scope = scope.where(produto_id:) if produto_id.present?
      scope
    end

    def to_h
      {
        inicio: inicio.iso8601,
        fim: fim.iso8601,
        categoria_id: categoria_id,
        produto_id: produto_id,
        situacao: situacao
      }.compact_blank
    end

    def descricao
      partes = [ "Período: #{I18n.l(inicio)} a #{I18n.l(fim)}" ]
      partes << "Categoria: #{Categoria.find_by(id: categoria_id)&.nome}" if categoria_id.present?
      partes << "Produto: #{Produto.find_by(id: produto_id)&.nome}" if produto_id.present?
      partes << "Situação: #{situacao.humanize}" if situacao.present?
      partes.compact.join(" · ")
    end

    private

    def filtrar_pedidos_por_item(scope)
      return scope unless categoria_id.present? || produto_id.present?

      scope = scope.joins(:itens_pedido).where(itens_pedido: { categoria_id: }) if categoria_id.present?
      scope = scope.joins(:itens_pedido).where(itens_pedido: { produto_id: }) if produto_id.present?
      scope.distinct
    end
  end
end
