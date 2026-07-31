require "test_helper"

class LocalizacaoTest < ActiveSupport::TestCase
  include ActionView::Helpers::NumberHelper

  test "usa locale, moeda e fuso brasileiros" do
    assert_equal :"pt-BR", I18n.default_locale
    assert_equal "America/Porto_Velho", Time.zone.name
    assert_equal "R$ 1.234,56", number_to_currency(1234.56)
  end

  test "apresenta mensagens de validação em português" do
    I18n.with_locale(:"pt-BR") do
      assert_equal "não pode ficar em branco", I18n.t("errors.messages.blank")
    end
  end

  test "filtra dados pessoais e credenciais dos logs" do
    filtro = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)
    resultado = filtro.filter(
      "password" => "segredo",
      "contato_cliente" => "cliente@example.test",
      "nome_cliente" => "Cliente",
      "produto_id" => "42"
    )

    assert_equal "[FILTERED]", resultado["password"]
    assert_equal "[FILTERED]", resultado["contato_cliente"]
    assert_equal "[FILTERED]", resultado["nome_cliente"]
    assert_equal "42", resultado["produto_id"]
  end
end
