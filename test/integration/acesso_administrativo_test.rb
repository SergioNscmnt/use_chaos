require "test_helper"

class AcessoAdministrativoTest < ActionDispatch::IntegrationTest
  test "visitante é enviado para autenticação" do
    get administracao_root_path
    assert_redirected_to new_usuario_administrativo_session_path
  end

  test "login administrativo oferece controle para exibir a senha" do
    get new_usuario_administrativo_session_path

    assert_response :success
    assert_select "[data-controller='visibilidade-senha']" do
      assert_select "input#senha-administrativa[type='password'][data-visibilidade-senha-target='campo']"
      assert_select "button[type='button'][data-action='visibilidade-senha#alternar'][aria-label='Exibir senha']" do
        assert_select "svg.icone-botao", count: 2
      end
    end
    assert_select "button[type='submit']", text: "Entrar" do
      assert_select "svg.icone-botao[aria-hidden='true']", count: 1
    end
  end

  test "login administrativo redireciona diretamente para o painel" do
    usuario = criar_usuario

    post usuario_administrativo_session_path, params: {
      usuario_administrativo: {
        email: usuario.email,
        password: "SenhaSegura123!"
      }
    }

    assert_redirected_to administracao_root_path
    follow_redirect!
    assert_response :success
    assert_select "h1", "Painel gerencial"
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
    follow_redirect!
    assert_select "#mensagens .toast.toast-aplicacao--erro[role='alert'][data-toast-autohide-value='false']" do
      assert_select ".toast-body", "Você não tem permissão para realizar esta ação."
      assert_select "button[data-bs-dismiss='toast'][aria-label='Fechar mensagem']"
    end
  end

  test "usuário inativo não é autenticável" do
    usuario = criar_usuario(ativo: false)
    assert_not usuario.active_for_authentication?
  end

  test "cadastro administrativo recebe preço e custo em reais" do
    usuario = criar_usuario(permissoes: %w[gerenciar_catalogo])
    categoria = criar_categoria
    sign_in usuario

    get new_administracao_produto_path
    assert_response :success
    assert_select "input[name='produto[preco]'][data-controller='mascara-monetaria']"
    assert_select "input[name='produto[custo]'][data-controller='mascara-monetaria']"

    assert_difference "Produto.count", 1 do
      post administracao_produtos_path, params: {
        produto: {
          categoria_id: categoria.id,
          nome: "Óculos Monetário",
          sku: "MON-001",
          descricao: "Produto com valores monetários localizados.",
          preco: "R$ 1.299,90",
          custo: "R$ 540,25",
          limiar_estoque_baixo: 2,
          ativo: "1",
          publicado: "1",
          disponivel: "1"
        }
      }
    end

    produto = Produto.find_by!(sku: "MON-001")
    assert_equal 129_990, produto.preco_centavos
    assert_equal 54_025, produto.custo_centavos
    assert_redirected_to administracao_produto_path(produto)
  end
end
