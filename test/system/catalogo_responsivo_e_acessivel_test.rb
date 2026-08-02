require "application_system_test_case"

class CatalogoResponsivoEAcessivelTest < ApplicationSystemTestCase
  setup do
    @categoria = criar_categoria
    @produto = criar_produto(categoria: @categoria, destaque: true)
  end

  test "componentes públicos funcionam em desktop e celular sem overflow" do
    page.current_window.resize_to(1_440, 900)
    visit root_path
    assert_text "Enxergue o futuro"
    assert_sem_rolagem_horizontal

    visit produtos_path
    assert_text @produto.nome
    assert_sem_rolagem_horizontal
    assert_midias_contidas_nos_cards
    assert_paginacao_separada_do_rodape
    assert_rodape_sem_sobreposicao

    within "#produto-card-#{@produto.id}" do
      click_button "Comprar"
    end
    assert_text "Produto adicionado ao carrinho."
    assert_selector "#mensagens .toast.show[role='status'][aria-live='polite']", text: "Produto adicionado ao carrinho."
    violacoes = violacoes_axe
    assert_empty violacoes, "Toast com violações axe: #{violacoes.inspect}"
    within "#mensagens" do
      find("button[aria-label='Fechar mensagem']").click
    end
    assert_no_selector "#mensagens .toast.show"
    assert_current_path produtos_path
    assert_selector "#contador-carrinho", text: "1"
    find("#atalho-carrinho").click
    assert_selector "#carrinho-offcanvas.show"
    within "#carrinho-offcanvas" do
      assert_text @produto.nome
      assert_text "R$ 100,00"
      assert_link "Ver carrinho completo", href: carrinho_path
    end
    find("#carrinho-offcanvas button[aria-label='Fechar carrinho']").click
    assert_no_selector "#carrinho-offcanvas.show"
    visit carrinho_path
    assert_text @produto.nome

    page.current_window.resize_to(390, 844)
    visit produto_path(@produto.slug)
    assert_text @produto.nome
    assert_sem_rolagem_horizontal
    assert_midias_contidas_nos_cards

    find("button[aria-label='Abrir menu']").click
    assert_selector "#menu-publico.show"
    assert_link "Administração", href: new_usuario_administrativo_session_path
    assert_selector "a#atalho-carrinho[href='#{carrinho_path}']"
    assert_no_link "Carrinho"
  end

  test "formulários com limites de caracteres permanecem contidos no celular e no desktop" do
    page.current_window.resize_to(390, 844)

    visit new_manifestacao_path
    assert_controles_contidos
    assert_sem_rolagem_horizontal

    visit produto_path(@produto.slug)
    find("details summary").click
    assert_controles_contidos
    assert_sem_rolagem_horizontal

    fill_in "Quantidade", with: 1
    click_button "Adicionar ao carrinho"
    assert_text "Produto adicionado ao carrinho."
    visit carrinho_path
    click_link "Finalizar Pedido"
    assert_current_path new_checkout_path
    fill_in "Telefone ou e-mail", with: "69999990101"
    assert_field "Telefone ou e-mail", with: "(69) 99999-0101"
    assert_controles_contidos
    assert_sem_rolagem_horizontal

    page.current_window.resize_to(900, 1_000)
    assert_controles_contidos
    assert_sem_rolagem_horizontal
  end

  test "rodapé permanece após o conteúdo em páginas curtas e longas" do
    page.current_window.resize_to(1_440, 900)
    visit new_usuario_administrativo_session_path
    assert_text "Área administrativa"
    assert_rodape_sem_sobreposicao

    page.current_window.resize_to(390, 844)
    visit produto_path(@produto.slug)
    fill_in "Quantidade", with: 1
    click_button "Adicionar ao carrinho"
    assert_text "Produto adicionado ao carrinho."
    visit carrinho_path
    click_link "Finalizar Pedido"
    assert_current_path new_checkout_path
    assert_rodape_sem_sobreposicao
  end

  test "senha do login administrativo pode ser exibida e ocultada" do
    visit new_usuario_administrativo_session_path
    fill_in "Senha", with: "SenhaSegura123!"

    assert_equal "password", find_field("Senha")[:type]
    find("button[aria-label='Exibir senha']").click
    assert_equal "text", find_field("Senha")[:type]
    assert_field "Senha", with: "SenhaSegura123!"
    assert_selector "button[aria-label='Ocultar senha'][aria-pressed='true']", text: "Ocultar"

    find("button[aria-label='Ocultar senha']").click
    assert_equal "password", find_field("Senha")[:type]
    assert_selector "button[aria-label='Exibir senha'][aria-pressed='false']", text: "Exibir"
  end

  test "máscaras localizam moeda e telefone sem alterar e-mail" do
    visit produtos_path
    fill_in "Preço mín.", with: "12345"
    assert_equal "123,45", find_field("Preço mín.").value.gsub(/[^\d,]/, "")

    visit new_manifestacao_path
    fill_in "Telefone ou e-mail (opcional)", with: "5569999990101"
    assert_field "Telefone ou e-mail (opcional)", with: "+55 (69) 99999-0101"

    fill_in "Telefone ou e-mail (opcional)", with: "cliente@example.test"
    assert_field "Telefone ou e-mail (opcional)", with: "cliente@example.test"
  end

  test "teclado, redução de movimento e semântica atendem a auditoria" do
    visit produto_path(@produto.slug)

    find("body").send_keys(:tab)
    assert page.evaluate_script("document.activeElement.classList.contains('skip-link')")
    page.driver.browser.switch_to.active_element.send_keys(:enter)
    assert_selector "main#conteudo-principal:focus"

    page.driver.browser.execute_cdp(
      "Emulation.setEmulatedMedia",
      features: [ { name: "prefers-reduced-motion", value: "reduce" } ]
    )
    duracao = page.evaluate_script("getComputedStyle(document.body).animationDuration")
    assert_includes [ "0s", "1e-05s", "0.00001s" ], duracao

    assert_selector "main#conteudo-principal"
    find("details summary").click
    assert_selector "form label[for]", minimum: 3
    violacoes = violacoes_axe
    assert_empty violacoes, "Violações axe encontradas: #{violacoes.inspect}"
  end

  test "páginas essenciais não apresentam violações WCAG automatizadas" do
    paginas = [
      root_path,
      produtos_path,
      produto_path(@produto.slug),
      carrinho_path,
      new_manifestacao_path,
      new_usuario_administrativo_session_path
    ]

    paginas.each do |caminho|
      visit caminho
      violacoes = violacoes_axe
      assert_empty violacoes, "#{caminho}: #{violacoes.inspect}"
    end
  end
end
