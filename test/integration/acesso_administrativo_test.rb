require "test_helper"

class AcessoAdministrativoTest < ActionDispatch::IntegrationTest
  test "visitante é enviado para autenticação" do
    get administracao_root_path
    assert_redirected_to new_usuario_administrativo_session_path
  end

  test "usuário autorizado acessa administração" do
    usuario = criar_usuario(permissoes: %w[visualizar_metricas])
    sign_in usuario
    get administracao_root_path
    assert_response :success
    assert_select "h1", "Painel gerencial"
  end

  test "usuário ativo sem permissão não acessa painel" do
    usuario = criar_usuario(permissoes: %w[moderar_conteudo])
    sign_in usuario
    get administracao_root_path
    assert_redirected_to root_path
  end

  test "usuário inativo não é autenticável" do
    usuario = criar_usuario(ativo: false)
    assert_not usuario.active_for_authentication?
  end
end
