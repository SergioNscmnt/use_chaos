require "test_helper"

class ConfiguracoesNegocioTest < ActiveSupport::TestCase
  test "valores operacionais finais permanecem configurados" do
    loja = Rails.configuration.x.loja
    retencao = Rails.configuration.x.retencao

    assert_match(/\A\d{10,15}\z/, loja.whatsapp_numero)
    assert_equal 5, loja.estoque_baixo
    assert_equal 24, loja.pedido_atrasado_horas
    assert_equal 5_000, loja.relatorio_assincrono_linhas
    assert_equal 30, loja.carrinho_expira_dias
    assert_equal 60, retencao.pedidos_meses
    assert_equal 24, retencao.manifestacoes_meses
    assert_equal 36, retencao.avaliacoes_meses
    assert_equal 60, retencao.auditoria_meses
  end
end
