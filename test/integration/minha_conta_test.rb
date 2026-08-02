require "test_helper"

class MinhaContaTest < ActionDispatch::IntegrationTest
  setup do
    @usuario = criar_usuario(permissoes: %w[visualizar_metricas])
  end

  test "exige autenticação" do
    get administracao_minha_conta_path

    assert_redirected_to new_usuario_administrativo_session_path
  end

  test "administrador sem permissão global pode acessar e atualizar seus dados" do
    sign_in @usuario

    get administracao_minha_conta_path
    assert_response :success
    assert_select "input[name='usuario_administrativo[nome]']"
    assert_select "input[name='usuario_administrativo[whatsapp]']"

    assert_difference "RegistroAuditoria.where(acao: 'usuario.conta_atualizada').count", 1 do
      patch administracao_minha_conta_path, params: {
        usuario_administrativo: {
          nome: "Novo Nome",
          email: @usuario.email,
          whatsapp: "+55 (69) 99999-0101",
          perfil_id: criar_perfil.id,
          ativo: "0",
          password: "",
          password_confirmation: "",
          current_password: ""
        }
      }
    end

    assert_redirected_to administracao_minha_conta_path
    @usuario.reload
    assert_equal "Novo Nome", @usuario.nome
    assert_equal "5569999990101", @usuario.whatsapp
    assert @usuario.ativo?
    assert @usuario.valid_password?("SenhaSegura123!")
  end

  test "recusa alteração de e-mail ou senha sem a senha atual correta" do
    sign_in @usuario

    patch administracao_minha_conta_path, params: {
      usuario_administrativo: {
        nome: @usuario.nome,
        email: "novo-email@example.test",
        whatsapp: "",
        current_password: "senha-incorreta",
        password: "NovaSenha123!",
        password_confirmation: "NovaSenha123!"
      }
    }

    assert_response :unprocessable_content
    @usuario.reload
    assert_not_equal "novo-email@example.test", @usuario.email
    assert @usuario.valid_password?("SenhaSegura123!")
  end

  test "altera e-mail e senha com confirmação da senha atual" do
    sign_in @usuario

    patch administracao_minha_conta_path, params: {
      usuario_administrativo: {
        nome: @usuario.nome,
        email: "novo-email@example.test",
        whatsapp: "5569999990101",
        current_password: "SenhaSegura123!",
        password: "NovaSenha123!",
        password_confirmation: "NovaSenha123!"
      }
    }

    assert_redirected_to administracao_minha_conta_path
    @usuario.reload
    assert_equal "novo-email@example.test", @usuario.email
    assert @usuario.valid_password?("NovaSenha123!")

    get administracao_minha_conta_path
    assert_response :success
  end

  test "valida o número de WhatsApp" do
    sign_in @usuario

    patch administracao_minha_conta_path, params: {
      usuario_administrativo: {
        nome: @usuario.nome,
        email: @usuario.email,
        whatsapp: "123",
        current_password: "",
        password: "",
        password_confirmation: ""
      }
    }

    assert_response :unprocessable_content
    assert_select ".alert", text: /WhatsApp deve conter entre 10 e 15 dígitos/
  end
end
