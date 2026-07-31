module Checkout
  class CriarPedido
    Resultado = Data.define(:pedido, :url_whatsapp)

    def self.call(carrinho:, atributos:)
      chave = atributos.fetch(:chave_idempotencia)
      existente = Pedido.includes(:itens_pedido).find_by(chave_idempotencia: chave)
      return Resultado.new(existente, GerarLinkWhatsapp.call(existente)) if existente

      pedido = nil
      divergencias = []
      Pedido.transaction do
        itens = carrinho.itens_carrinho.includes(produto: :categoria).to_a
        raise Erro, "O carrinho está vazio." if itens.empty?

        produtos = Produto.where(id: itens.map(&:produto_id)).lock.index_by(&:id)
        divergencias = validar_itens(itens, produtos)
        next if divergencias.any?

        pedido = Pedido.new(
          chave_idempotencia: chave,
          nome_cliente: atributos[:nome_cliente],
          contato_cliente: atributos[:contato_cliente],
          aceite_privacidade: atributos[:aceite_privacidade],
          situacao: "iniciado"
        )
        itens.each do |item_carrinho|
          produto = produtos.fetch(item_carrinho.produto_id)
          pedido.itens_pedido.build(
            produto:,
            categoria: produto.categoria,
            produto_nome: produto.nome,
            produto_sku: produto.sku,
            categoria_nome: produto.categoria.nome,
            quantidade: item_carrinho.quantidade,
            preco_unitario_centavos: produto.preco_centavos,
            custo_unitario_centavos: produto.custo_centavos
          )
        end
        pedido.total_centavos = pedido.itens_pedido.sum(&:subtotal_centavos)
        pedido.save!
        pedido.historicos_pedido.create!(situacao_nova: "iniciado")
        carrinho.itens_carrinho.destroy_all
      end

      raise Erro.new("O carrinho mudou. Revise os itens antes de continuar.", detalhes: divergencias) if divergencias.any?

      Resultado.new(pedido, GerarLinkWhatsapp.call(pedido))
    rescue ActiveRecord::RecordNotUnique
      pedido = Pedido.includes(:itens_pedido).find_by!(chave_idempotencia: chave)
      Resultado.new(pedido, GerarLinkWhatsapp.call(pedido))
    end

    def self.validar_itens(itens, produtos)
      itens.filter_map do |item|
        produto = produtos[item.produto_id]
        if produto.nil? || !produto.compravel?
          "#{item.produto.nome}: indisponível"
        elsif item.quantidade > produto.estoque
          "#{produto.nome}: somente #{produto.estoque} unidade(s) disponível(is)"
        elsif item.preco_unitario_centavos_observado != produto.preco_centavos
          item.update_columns(preco_unitario_centavos_observado: produto.preco_centavos, updated_at: Time.current)
          "#{produto.nome}: preço atualizado"
        end
      end
    end
    private_class_method :validar_itens
  end
end
