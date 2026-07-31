require "test_helper"
require "cgi"

class CarrinhoCheckoutTest < ActiveSupport::TestCase
  setup do
    @produto = criar_produto(estoque: 5, preco: 12_990, custo: 5_000)
    @carrinho = Carrinho.create!
  end

  test "adiciona, soma e altera itens respeitando o estoque" do
    item = Carrinhos::AdicionarItem.call(carrinho: @carrinho, produto: @produto, quantidade: 2)
    Carrinhos::AdicionarItem.call(carrinho: @carrinho, produto: @produto, quantidade: 1)

    assert_equal 3, item.reload.quantidade
    assert_equal 38_970, @carrinho.reload.total_centavos
    assert @carrinho.elegivel_para_checkout?

    erro = assert_raises(ActiveRecord::RecordInvalid) do
      Carrinhos::AlterarItem.call(item:, quantidade: 6)
    end
    assert_match "estoque disponível", erro.message
  end

  test "checkout cria snapshots, histórico, limpa o carrinho e é idempotente" do
    Carrinhos::AdicionarItem.call(carrinho: @carrinho, produto: @produto, quantidade: 2)
    chave = SecureRandom.uuid
    atributos = {
      nome_cliente: "Ana Ótica",
      contato_cliente: "+55 69 99999-0000",
      aceite_privacidade: "1",
      chave_idempotencia: chave
    }

    assert_difference [ "Pedido.count", "ItemPedido.count", "HistoricoPedido.count" ], 1 do
      @resultado = Checkout::CriarPedido.call(carrinho: @carrinho, atributos:)
    end

    pedido = @resultado.pedido
    item = pedido.itens_pedido.first
    assert_equal @produto.nome, item.produto_nome
    assert_equal @produto.preco_centavos, item.preco_unitario_centavos
    assert_equal @produto.custo_centavos, item.custo_unitario_centavos
    assert_equal 25_980, pedido.total_centavos
    assert_empty @carrinho.reload.itens_carrinho

    repetido = Checkout::CriarPedido.call(carrinho: @carrinho, atributos:)
    assert_equal pedido.id, repetido.pedido.id
    assert_equal 1, Pedido.where(chave_idempotencia: chave).count

    uri = URI.parse(@resultado.url_whatsapp)
    mensagem = URI.decode_www_form(uri.query).to_h.fetch("text")
    assert_match "Ana Ótica", mensagem
    assert_match pedido.numero, mensagem
    assert_match @produto.nome, mensagem
  end

  test "mudança de preço bloqueia checkout, atualiza referência e preserva carrinho" do
    item = Carrinhos::AdicionarItem.call(carrinho: @carrinho, produto: @produto, quantidade: 1)
    @produto.update!(preco_centavos: 14_500)

    erro = assert_raises(Checkout::Erro) do
      Checkout::CriarPedido.call(
        carrinho: @carrinho,
        atributos: {
          nome_cliente: "Cliente",
          contato_cliente: "cliente@example.test",
          aceite_privacidade: "1",
          chave_idempotencia: SecureRandom.uuid
        }
      )
    end

    assert_match "preço atualizado", erro.detalhes.to_sentence
    assert_equal 14_500, item.reload.preco_unitario_centavos_observado
    assert_equal 1, @carrinho.reload.itens_carrinho.count
    assert_equal 0, Pedido.count
  end

  test "produto inelegível ou sem estoque não gera pedido" do
    Carrinhos::AdicionarItem.call(carrinho: @carrinho, produto: @produto, quantidade: 2)
    @produto.update!(disponivel: false)

    assert_no_difference "Pedido.count" do
      assert_raises(Checkout::Erro) do
        Checkout::CriarPedido.call(
          carrinho: @carrinho,
          atributos: {
            nome_cliente: "Cliente",
            contato_cliente: "cliente@example.test",
            aceite_privacidade: "1",
            chave_idempotencia: SecureRandom.uuid
          }
        )
      end
    end
    assert_equal 1, @carrinho.reload.itens_carrinho.count
  end
end
