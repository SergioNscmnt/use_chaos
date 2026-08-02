require "test_helper"

class CatalogoPublicoTest < ActionDispatch::IntegrationTest
  setup do
    @categoria = criar_categoria
    @produto = criar_produto(categoria: @categoria, destaque: true)
  end

  test "página inicial e produto são públicos e indexáveis" do
    get root_path
    assert_response :success
    assert_select "html[lang='pt-BR']"
    assert_select "meta[name='viewport']"
    assert_select "a.skip-link[href='#conteudo-principal']"
    assert_select "main#conteudo-principal[tabindex='-1']"
    assert_select "a[href='#{produto_path(@produto.slug)}']"
    assert_select "nav#menu-publico a[href='#{new_usuario_administrativo_session_path}']", "Administração"
    assert_select "nav#menu-publico a#atalho-carrinho[href='#{carrinho_path}'][data-bs-toggle='offcanvas']" do
      assert_select "svg.icone-carrinho"
      assert_select "span#contador-carrinho", "0"
    end
    assert_select "nav#menu-publico a.btn[href='#{carrinho_path}']", count: 0
    assert_select "aside#carrinho-offcanvas[aria-labelledby='carrinho-offcanvas-titulo']"
    assert_select "#carrinho-offcanvas-conteudo", text: /Seu carrinho está vazio/

    get produto_path(@produto.slug)
    assert_response :success
    assert_select "link[rel='canonical']"
    assert_select "h1", @produto.nome
  end

  test "menu leva usuário administrativo autenticado diretamente ao painel" do
    usuario = criar_usuario(permissoes: %w[visualizar_metricas])
    sign_in usuario

    get root_path

    assert_response :success
    assert_select "nav#menu-publico a[href='#{administracao_root_path}']", "Administração"
    assert_select "nav#menu-publico a[href='#{new_usuario_administrativo_session_path}']", count: 0
  end

  test "busca e categoria preservam apenas resultados compatíveis" do
    outro = criar_produto(categoria: criar_categoria)
    get produtos_path, params: { busca: @produto.nome, categoria_id: @categoria.id, ordenacao: "menor_preco" }
    assert_response :success
    assert_select "h3", text: @produto.nome
    assert_select "h3", text: outro.nome, count: 0
  end

  test "card permite comprar produto disponível e desabilita ação indisponível" do
    indisponivel = criar_produto(categoria: @categoria, estoque: 0)

    get produtos_path

    assert_response :success
    assert_select "article#produto-card-#{@produto.id}" do
      assert_select "a[href='#{produto_path(@produto.slug)}']", text: @produto.nome
      assert_select "form[action='#{itens_carrinho_path}']" do
        assert_select "input[name='produto_id'][value='#{@produto.id}']"
        assert_select "input[name='quantidade'][value='1']"
        assert_select "button[type='submit']", text: "Comprar" do
          assert_select "svg.icone-botao[aria-hidden='true']", count: 1
        end
      end
    end
    assert_select "article#produto-card-#{indisponivel.id}" do
      assert_select "form[action='#{itens_carrinho_path}']", count: 0
      assert_select "button[disabled]", text: "Comprar" do
        assert_select "svg.icone-botao[aria-hidden='true']", count: 1
      end
    end
  end

  test "filtros monetários aceitam moeda brasileira e preservam o valor localizado" do
    produto_caro = criar_produto(categoria: @categoria, preco: 25_000)

    get produtos_path, params: { preco_min: "R$ 200,00", preco_max: "R$ 300,00" }

    assert_response :success
    assert_select "h3", text: produto_caro.nome
    assert_select "h3", text: @produto.nome, count: 0
    assert_select "input[name='preco_min'][value='200,00']"
    assert_select "input[name='preco_max'][value='300,00']"
  end

  test "produto inativo não é exposto" do
    @produto.update!(ativo: false)
    get produto_path(@produto.slug)
    assert_response :not_found
  end

  test "estado vazio oferece limpeza de filtros" do
    get produtos_path, params: { busca: "não-encontrável" }
    assert_response :success
    assert_select "h2", "Nenhum produto encontrado"
  end

  test "catálogo pagina volume representativo sem multiplicar consultas" do
    agora = Time.current
    Produto.insert_all!(
      250.times.map do |indice|
        {
          categoria_id: @categoria.id,
          nome: "Modelo Volume #{indice}",
          slug: "modelo-volume-#{SecureRandom.hex(4)}-#{indice}",
          sku: "VOL-#{SecureRandom.hex(4)}-#{indice}",
          descricao: "Produto criado para validar a paginação do catálogo.",
          caracteristicas: [],
          preco_centavos: 10_000 + indice,
          custo_centavos: 4_000,
          estoque: 10,
          ativo: true,
          publicado: true,
          disponivel: true,
          destaque: false,
          created_at: agora,
          updated_at: agora
        }
      end
    )

    consultas = 0
    contador = lambda do |_nome, _inicio, _fim, _id, dados|
      consultas += 1 unless dados[:cached] || dados[:name].match?(/SCHEMA|TRANSACTION/)
    end
    inicio = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    ActiveSupport::Notifications.subscribed(contador, "sql.active_record") do
      get produtos_path, params: { categoria_id: @categoria.id, ordenacao: "menor_preco" }
    end
    duracao = Process.clock_gettime(Process::CLOCK_MONOTONIC) - inicio

    assert_response :success
    assert_select ".card-neon", minimum: 12
    assert_operator consultas, :<=, 12
    assert_operator duracao, :<, 5
  end
end
