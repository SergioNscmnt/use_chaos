require "test_helper"

class FluxoEcommerceTest < ActionDispatch::IntegrationTest
  test "fluxo HTML completo do catálogo à confirmação administrativa" do
    produto = criar_produto(estoque: 3, preco: 19_990)

    get produto_path(produto.slug)
    assert_response :success
    assert_select "form[action='#{itens_carrinho_path}']"

    post itens_carrinho_path, params: { produto_id: produto.id, quantidade: 2 }
    assert_redirected_to carrinho_path
    follow_redirect!
    assert_response :success
    assert_includes response.body, produto.nome
    assert_includes response.body, "R$ 399,80"

    get new_checkout_path
    assert_response :success
    chave = css_select("input[name='checkout[chave_idempotencia]']").first["value"]

    post checkout_path, params: {
      checkout: {
        chave_idempotencia: chave,
        nome_cliente: "João da Silva",
        contato_cliente: "+55 69 99999-0101",
        aceite_privacidade: "1"
      }
    }
    assert_response :created
    pedido = Pedido.find_by!(chave_idempotencia: chave)
    assert_includes response.body, pedido.numero
    assert_select "a[href^='https://wa.me/']"
    assert_equal 3, produto.reload.estoque

    usuario = criar_usuario(permissoes: %w[gerenciar_pedidos visualizar_metricas])
    sign_in usuario
    patch alterar_situacao_administracao_pedido_path(pedido), params: {
      nova_situacao: "confirmado",
      observacao: "Cliente confirmou pelo WhatsApp"
    }
    assert_redirected_to administracao_pedido_path(pedido)
    assert_equal 1, produto.reload.estoque
    assert pedido.reload.confirmado?
  end

  test "atualização Turbo do carrinho mantém alternativa HTML" do
    produto = criar_produto

    post itens_carrinho_path,
      params: { produto_id: produto.id, quantidade: 1 },
      headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_select "turbo-stream[action='replace'][target='carrinho']"

    get carrinho_path
    assert_response :success
    assert_select "main"
    assert_select "form"
  end

  test "cookie adulterado é descartado sem expor erro" do
    cookies[:carrinho_token] = "conteudo-adulterado"

    assert_difference "Carrinho.count", 1 do
      get carrinho_path
    end

    assert_response :success
    assert_select "h1", "Seu carrinho"
  end
end
