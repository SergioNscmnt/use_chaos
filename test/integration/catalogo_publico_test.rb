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

    get produto_path(@produto.slug)
    assert_response :success
    assert_select "link[rel='canonical']"
    assert_select "h1", @produto.nome
  end

  test "busca e categoria preservam apenas resultados compatíveis" do
    outro = criar_produto(categoria: criar_categoria)
    get produtos_path, params: { busca: @produto.nome, categoria_id: @categoria.id, ordenacao: "menor_preco" }
    assert_response :success
    assert_select "h3", text: @produto.nome
    assert_select "h3", text: outro.nome, count: 0
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
