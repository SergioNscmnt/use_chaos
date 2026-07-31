require "test_helper"

class InflectionsTest < ActiveSupport::TestCase
  TERMOS = {
    "produto" => "produtos",
    "categoria" => "categorias",
    "avaliacao" => "avaliacoes",
    "sugestao" => "sugestoes",
    "manifestacao" => "manifestacoes",
    "situacao" => "situacoes",
    "usuario_administrativo" => "usuarios_administrativos",
    "item_carrinho" => "itens_carrinho",
    "item_pedido" => "itens_pedido"
  }.freeze

  test "pluraliza e singulariza termos do domínio" do
    TERMOS.each do |singular, plural|
      assert_equal plural, singular.pluralize
      assert_equal singular, plural.singularize
    end
  end

  test "mantém óculos incontável" do
    assert_equal "oculos", "oculos".pluralize
    assert_equal "oculos", "oculos".singularize
  end
end
