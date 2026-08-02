require "application_system_test_case"
require "base64"
require "tempfile"

class GaleriaProdutoTest < ApplicationSystemTestCase
  include Warden::Test::Helpers

  setup do
    @usuario = criar_usuario(permissoes: %w[gerenciar_catalogo])
    @produto = criar_produto
    login_as @usuario, scope: :usuario_administrativo
    @imagem = Tempfile.new([ "produto", ".png" ])
    @imagem.binmode
    @imagem.write(
      Base64.strict_decode64(
        "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAusB9Y9ZfSAAAAAASUVORK5CYII="
      )
    )
    @imagem.close
  end

  teardown do
    logout :usuario_administrativo
    @imagem.unlink
  end

  test "administrador pré-visualiza e salva imagem pelo formulário de edição" do
    visit edit_administracao_produto_path(@produto)
    assert_selector "[data-galeria-produto-pronta='true']"
    assert_selector "[data-galeria-produto-item]", count: 1

    within first("[data-galeria-produto-item]") do
      attach_file "Imagem", @imagem.path
      fill_in "Texto alternativo", with: "Óculos em vista frontal"
      check "Imagem principal do catálogo"

      assert_selector "[data-preview-imagem]:not(.d-none)"
      assert_match %r{\Ablob:}, find("[data-preview-imagem]")[:src]
    end

    click_button "Adicionar imagem"
    assert_selector "[data-galeria-produto-item]", count: 2
    within all("[data-galeria-produto-item]").last do
      attach_file "Imagem", @imagem.path
      fill_in "Texto alternativo", with: "Óculos em vista lateral"
      fill_in "Ordem", with: 1
    end

    click_button "Salvar"
    assert_current_path administracao_produto_path(@produto)
    assert_selector "#carrossel-produto-#{@produto.id} img[alt='Óculos em vista frontal']"
    assert_selector "#carrossel-produto-#{@produto.id} img[alt='Óculos em vista lateral']", visible: :all

    visit produtos_path
    assert_selector "#produto-card-#{@produto.id} img[alt='Óculos em vista frontal']"

    visit produto_path(@produto.slug)
    assert_selector "#carrossel-produto-#{@produto.id} .carousel-item.active img[alt='Óculos em vista frontal']"
    find("#carrossel-produto-#{@produto.id} .carousel-control-next").click
    assert_selector "#carrossel-produto-#{@produto.id} .carousel-item.active img[alt='Óculos em vista lateral']"
  end
end
