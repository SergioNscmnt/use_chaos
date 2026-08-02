require "application_system_test_case"

class FluxoSemJavascriptTest < SemJavaScriptSystemTestCase
  test "ícone do carrinho mantém acesso à página completa sem JavaScript" do
    visit produtos_path

    find("#atalho-carrinho").click

    assert_current_path carrinho_path
    assert_text "Seu carrinho está vazio"
  end

  test "compra pelo card do catálogo funciona somente com HTML" do
    produto = criar_produto

    visit produtos_path
    within "#produto-card-#{produto.id}" do
      click_button "Comprar"
    end

    assert_current_path carrinho_path
    assert_text produto.nome
    assert_text "Produto adicionado ao carrinho."
  end

  test "busca, produto, carrinho e checkout funcionam somente com HTML" do
    produto = criar_produto(estoque: 4, preco: 13_990)

    visit produtos_path
    fill_in "Buscar", with: produto.nome
    click_button "Aplicar filtros"
    assert_text produto.nome

    click_link produto.nome
    assert_current_path produto_path(produto.slug)
    fill_in "Quantidade", with: 2
    click_button "Adicionar ao carrinho"
    assert_current_path carrinho_path
    assert_text produto.nome
    assert_text "R$ 279,80"

    within "main" do
      click_link "Finalizar Pedido"
    end
    fill_in "Nome", with: "Cliente sem JavaScript"
    fill_in "Telefone ou e-mail", with: "cliente@example.test"
    check "Concordo com o uso destes dados"
    click_button "Criar pedido e abrir WhatsApp"

    assert_text "Pedido criado"
    assert_link "Abrir WhatsApp", href: %r{\Ahttps://wa\.me/}
    assert_equal 1, Pedido.where(nome_cliente: "Cliente sem JavaScript").count
  end

  test "manifestação e avaliação podem ser enviadas sem JavaScript" do
    produto = criar_produto
    visibilidade_anterior = Capybara.ignore_hidden_elements
    Capybara.ignore_hidden_elements = false

    visit produto_path(produto.slug)
    fill_in "Seu nome (opcional)", with: "Visitante"
    select "5 de 5", from: "Nota"
    fill_in "Comentário", with: "Produto excelente e confortável."
    click_button "Enviar avaliação"
    assert_text "Avaliação recebida"

    visit new_manifestacao_path
    select "Sugestão", from: "Tipo"
    select "Site", from: "Categoria"
    fill_in "Mensagem", with: "Gostaria de receber mais modelos esportivos."
    click_button "Enviar manifestação"
    assert_text "Manifestação recebida"
  ensure
    Capybara.ignore_hidden_elements = visibilidade_anterior
  end

  test "filtro monetário localizado funciona sem JavaScript" do
    produto = criar_produto(preco: 13_990)

    visit produtos_path
    fill_in "Preço mín.", with: "R$ 100,00"
    fill_in "Preço máx.", with: "R$ 150,00"
    click_button "Aplicar filtros"

    assert_text produto.nome
    assert_field "Preço mín.", with: "100,00"
    assert_field "Preço máx.", with: "150,00"
  end
end
