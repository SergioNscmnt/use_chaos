require "test_helper"

class ModeracaoEPrivacidadeTest < ActionDispatch::IntegrationTest
  setup do
    @produto = criar_produto
    @avaliacao = @produto.avaliacoes.create!(
      nota: 4,
      comentario: "Produto muito confortável",
      situacao: "pendente"
    )
    @manifestacao = Manifestacao.create!(
      tipo: "feedback",
      categoria: "Atendimento",
      mensagem: "Mensagem válida para tratamento.",
      contato: "contato@example.test"
    )
  end

  test "moderador aprova avaliação e registra auditoria" do
    usuario = criar_usuario(permissoes: %w[moderar_conteudo])
    sign_in usuario

    assert_difference "RegistroAuditoria.where(acao: 'avaliacao.aprovada').count", 1 do
      patch administracao_avaliacao_path(@avaliacao), params: {
        avaliacao: { situacao: "aprovada" }
      }
    end

    assert_redirected_to administracao_avaliacoes_path
    assert @avaliacao.reload.aprovada?
    assert_equal usuario, @avaliacao.moderada_por
  end

  test "contato da manifestação só aparece para perfil autorizado" do
    moderador = criar_usuario(permissoes: %w[moderar_conteudo])
    sign_in moderador
    get administracao_manifestacao_path(@manifestacao)
    assert_response :success
    assert_not_includes response.body, @manifestacao.contato

    sign_out moderador
    autorizado = criar_usuario(permissoes: %w[moderar_conteudo visualizar_dados_pessoais])
    sign_in autorizado
    get administracao_manifestacao_path(@manifestacao)
    assert_response :success
    assert_includes response.body, @manifestacao.contato
  end

  test "tratamento registra responsável, histórico e auditoria" do
    usuario = criar_usuario(permissoes: %w[moderar_conteudo])
    sign_in usuario

    assert_difference [ "HistoricoManifestacao.count", "RegistroAuditoria.count" ], 1 do
      patch administracao_manifestacao_path(@manifestacao), params: {
        manifestacao: {
          situacao: "tratada",
          observacao_interna: "Resposta encaminhada."
        }
      }
    end

    assert_redirected_to administracao_manifestacao_path(@manifestacao)
    assert @manifestacao.reload.tratada?
    assert_equal usuario, @manifestacao.responsavel
    assert @manifestacao.tratada_em
  end
end
