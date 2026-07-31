require "test_helper"

class InteracoesPublicasTest < ActionDispatch::IntegrationTest
  setup do
    @produto = criar_produto
  end

  test "avaliação pública é sanitizada e fica pendente" do
    assert_difference "Avaliacao.count", 1 do
      post produto_avaliacoes_path(@produto.slug), params: {
        avaliacao: {
          nome_autor: "<b>Ana</b>",
          nota: 5,
          comentario: "<script>alert(1)</script>Produto excelente!"
        }
      }
    end

    avaliacao = Avaliacao.last
    assert_redirected_to produto_path(@produto.slug, anchor: "titulo-avaliacoes")
    assert avaliacao.pendente?
    assert_equal "Ana", avaliacao.nome_autor
    assert_no_match(/<script>|<b>/, avaliacao.comentario)
    assert_predicate avaliacao.origem_hash, :present?
  end

  test "somente avaliações aprovadas entram na média pública" do
    @produto.avaliacoes.create!(nota: 5, comentario: "Avaliação aprovada", situacao: "aprovada")
    @produto.avaliacoes.create!(nota: 1, comentario: "Avaliação pendente", situacao: "pendente")

    assert_equal 5.0, @produto.avaliacao_media
    assert_equal 1, @produto.quantidade_avaliacoes
    get produto_path(@produto.slug)
    assert_response :success
    assert_includes response.body, "Avaliação aprovada"
    assert_not_includes response.body, "Avaliação pendente"
  end

  test "manifestação anônima é sanitizada e confirmada" do
    assert_difference "Manifestacao.count", 1 do
      post manifestacoes_path, params: {
        manifestacao: {
          tipo: "sugestao",
          categoria: "Atendimento",
          mensagem: "<img src=x onerror=alert(1)>Gostaria de mais opções.",
          contato: ""
        }
      }
    end

    manifestacao = Manifestacao.last
    assert_redirected_to new_manifestacao_path
    assert manifestacao.nova?
    assert_no_match(/<img|onerror/, manifestacao.mensagem)
    assert_predicate manifestacao.contato, :blank?
    assert_predicate manifestacao.origem_hash, :present?
  end

  test "limite de requisições responde sem revelar o mecanismo" do
    armazenamento_anterior = Rack::Attack.cache.store
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

    20.times do
      post manifestacoes_path, params: {
        manifestacao: {
          tipo: "feedback",
          categoria: "Site",
          mensagem: "Mensagem pública válida para o teste."
        }
      }
      assert_response :redirect
    end

    post manifestacoes_path, params: {
      manifestacao: {
        tipo: "feedback",
        categoria: "Site",
        mensagem: "Mensagem pública excedente."
      }
    }
    assert_response :too_many_requests
    assert_equal "600", response.headers["Retry-After"]
    assert_not_includes response.body, "IP"
  ensure
    Rack::Attack.cache.store = armazenamento_anterior
  end
end
