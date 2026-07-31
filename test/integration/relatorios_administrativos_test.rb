require "test_helper"

class RelatoriosAdministrativosTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @produto = criar_produto
    criar_pedido(
      produto: @produto,
      situacao: "confirmado",
      confirmado_em: Time.current
    )
    @usuario = criar_usuario(permissoes: %w[ gerar_relatorios ])
    sign_in @usuario
  end

  test "gera CSV síncrono autorizado e auditado" do
    assert_difference "RegistroAuditoria.where(acao: 'relatorio.gerado').count", 1 do
      post administracao_relatorios_path, params: {
        formato: "csv",
        filtros: {
          inicio: Time.zone.yesterday.to_date.iso8601,
          fim: Time.zone.today.iso8601
        }
      }
    end

    assert_response :success
    assert_equal "text/csv", response.media_type
    assert_match(/attachment/, response.headers["Content-Disposition"])
    assert_includes response.body, "Relatório gerencial de vendas"
  end

  test "arquivo assíncrono fica disponível somente para o solicitante" do
    geracao = @usuario.geracoes_relatorio.create!(
      formato: "pdf",
      filtros: {
        inicio: Time.zone.yesterday.to_date.iso8601,
        fim: Time.zone.today.iso8601
      }
    )
    GerarRelatorioVendasJob.perform_now(geracao.id)

    assert geracao.reload.concluida?
    assert geracao.arquivo.attached?
    get administracao_relatorio_path(geracao)
    assert_response :success
    assert_equal "application/pdf", response.media_type

    sign_out @usuario
    outro = criar_usuario(permissoes: %w[ gerar_relatorios ])
    sign_in outro
    get administracao_relatorio_path(geracao)
    assert_redirected_to root_path
  end

  test "volume acima do limite agenda geração protegida" do
    limite_anterior = Rails.configuration.x.loja.relatorio_assincrono_linhas
    Rails.configuration.x.loja.relatorio_assincrono_linhas = 0

    assert_enqueued_with(job: GerarRelatorioVendasJob) do
      post administracao_relatorios_path, params: {
        formato: "pdf",
        filtros: {
          inicio: Time.zone.yesterday.to_date.iso8601,
          fim: Time.zone.today.iso8601
        }
      }
    end

    geracao = @usuario.geracoes_relatorio.last
    assert_redirected_to administracao_relatorio_path(geracao)
    assert geracao.pendente?
    assert_equal "pdf", geracao.formato
    assert RegistroAuditoria.exists?(acao: "relatorio.agendado", alvo: geracao)
  ensure
    Rails.configuration.x.loja.relatorio_assincrono_linhas = limite_anterior
  end
end
