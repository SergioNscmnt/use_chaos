require "test_helper"
require "base64"
require "tempfile"

class ImagensProdutoTest < ActionDispatch::IntegrationTest
  setup do
    @usuario = criar_usuario(permissoes: %w[gerenciar_catalogo])
    @categoria = criar_categoria
    @temporarios = []
    sign_in @usuario
  end

  teardown do
    @temporarios.each(&:close!)
  end

  test "create persiste imagens e exibe a principal no catálogo e no carrossel" do
    assert_difference "Produto.count", 1 do
      assert_difference "ImagemProduto.count", 2 do
        post administracao_produtos_path, params: {
          produto: atributos_produto.merge(
            imagens_produto_attributes: {
              "0" => {
                arquivo: upload_png("lateral.png"),
                texto_alternativo: "Vista lateral do Elevate",
                posicao: 1,
                principal: "0"
              },
              "1" => {
                arquivo: upload_png("frontal.png"),
                texto_alternativo: "Vista frontal do Elevate",
                posicao: 0,
                principal: "1"
              }
            }
          )
        }
      end
    end

    produto = Produto.find_by!(slug: "elevate-teste")
    assert_redirected_to administracao_produto_path(produto)
    assert_equal 2, produto.imagens_produto.count
    assert produto.imagens_produto.all? { |imagem| imagem.arquivo.attached? }

    get produtos_path
    assert_response :success
    assert_select "#produto-card-#{produto.id} img.card-produto__imagem[alt='Vista frontal do Elevate']"

    get produto_path(produto.slug)
    assert_response :success
    assert_select "#carrossel-produto-#{produto.id}" do
      assert_select ".carousel-item", count: 2
      assert_select ".carousel-item.active img[alt='Vista frontal do Elevate']"
      assert_select "button.carousel-control-prev"
      assert_select "button.carousel-control-next"
    end

    get administracao_produto_path(produto)
    assert_response :success
    assert_select "#titulo-galeria-produto", "Pré-visualização da galeria"
    assert_select "#carrossel-produto-#{produto.id} img", count: 2
  end

  test "update anexa uma nova imagem ao produto existente" do
    produto = criar_produto(categoria: @categoria)

    assert_difference "ImagemProduto.count", 1 do
      patch administracao_produto_path(produto), params: {
        produto: {
          imagens_produto_attributes: {
            "0" => {
              arquivo: upload_png("atualizada.png"),
              texto_alternativo: "Elevate atualizado",
              posicao: 0,
              principal: "1"
            }
          }
        }
      }
    end

    assert_redirected_to administracao_produto_path(produto)
    imagem = produto.reload.imagens_produto.first
    assert imagem.arquivo.attached?
    assert_equal "Elevate atualizado", imagem.texto_alternativo
  end

  test "update inválido não tenta gerar URL para blob ainda não persistido" do
    produto = criar_produto(categoria: @categoria)

    assert_no_difference [ "ImagemProduto.count", "ActiveStorage::Blob.count" ] do
      patch administracao_produto_path(produto), params: {
        produto: {
          imagens_produto_attributes: {
            "0" => {
              arquivo: upload_png("sem-texto-alternativo.png"),
              texto_alternativo: "",
              posicao: 0,
              principal: "1"
            }
          }
        }
      }
    end

    assert_response :unprocessable_content
    assert_select ".alert", text: /texto alternativo não pode ficar em branco/i
    assert_select "[data-preview-placeholder]", text: /Selecione novamente a imagem/
    assert_select "input[type='file'][required]"
  end

  private

  def atributos_produto
    {
      categoria_id: @categoria.id,
      nome: "Elevate Teste",
      slug: "elevate-teste",
      sku: "ELEV-TESTE",
      descricao: "Óculos Elevate criado para validar a galeria.",
      preco: "R$ 299,90",
      custo: "R$ 120,00",
      ativo: "1",
      publicado: "1",
      disponivel: "1"
    }
  end

  def upload_png(nome)
    conteudo = Base64.strict_decode64(
      "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAusB9Y9ZfSAAAAAASUVORK5CYII="
    )
    temporario = Tempfile.new([ "produto", ".png" ])
    temporario.binmode
    temporario.write(conteudo)
    temporario.rewind
    @temporarios << temporario

    Rack::Test::UploadedFile.new(
      temporario.path,
      "image/png",
      true,
      original_filename: nome
    )
  end
end
