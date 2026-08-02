require "test_helper"

class ValoresMonetarioTest < ActiveSupport::TestCase
  test "converte moeda brasileira, decimal simples e reais inteiros para centavos" do
    assert_equal 123_456, Valores::Monetario.para_centavos("R$ 1.234,56")
    assert_equal 12_345, Valores::Monetario.para_centavos("123.45")
    assert_equal 12_300, Valores::Monetario.para_centavos("123")
    assert_equal(-150, Valores::Monetario.para_centavos("-1,50"))
  end

  test "formata centavos sem usar ponto flutuante" do
    assert_equal "1.234,56", Valores::Monetario.formatar(123_456)
    assert_equal "-1,50", Valores::Monetario.formatar(-150)
    assert_equal "", Valores::Monetario.formatar(nil)
  end

  test "retorna nulo para entrada monetária vazia ou inválida" do
    assert_nil Valores::Monetario.para_centavos("")
    assert_nil Valores::Monetario.para_centavos("valor inválido")
  end

  test "atributos de produto aceitam reais e mantêm centavos no domínio" do
    produto = Produto.new(preco: "R$ 199,90", custo: "80,25")

    assert_equal 19_990, produto.preco_centavos
    assert_equal 8_025, produto.custo_centavos
    assert_equal "R$ 199,90", produto.preco
    assert_equal "80,25", produto.custo
  end
end
