require "application_system_test_case"

class MinhaContaTest < ApplicationSystemTestCase
  include Warden::Test::Helpers

  setup do
    @usuario = criar_usuario(permissoes: %w[visualizar_metricas])
    login_as @usuario, scope: :usuario_administrativo
  end

  teardown do
    logout :usuario_administrativo
  end

  test "administrador atualiza nome e WhatsApp da própria conta" do
    visit administracao_minha_conta_path

    assert_selector "h1", text: "Minha conta"
    fill_in "Nome", with: "Sérgio Administrador"
    fill_in "WhatsApp", with: "5569999990101"
    assert_field "WhatsApp", with: "+55 (69) 99999-0101"

    click_button "Salvar alterações"

    assert_current_path administracao_minha_conta_path
    assert_text "Conta atualizada com sucesso."
    assert_field "Nome", with: "Sérgio Administrador"
    assert_field "WhatsApp", with: "+55 (69) 99999-0101"
    assert_equal "5569999990101", @usuario.reload.whatsapp
  end
end
