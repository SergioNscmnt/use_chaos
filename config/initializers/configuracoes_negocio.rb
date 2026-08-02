Rails.application.configure do
  config.x.loja.url_publica = ENV.fetch("URL_PUBLICA", "http://localhost:3000")
  numero_whatsapp_padrao = "5569999999999" unless Rails.env.production?
  numero_whatsapp = ENV.fetch("WHATSAPP_NUMERO", numero_whatsapp_padrao).to_s
  unless numero_whatsapp.match?(/\A\d{10,15}\z/)
    raise ArgumentError,
      "WHATSAPP_NUMERO deve conter somente código do país, DDD e número (10 a 15 dígitos)"
  end
  config.x.loja.whatsapp_numero = numero_whatsapp
  config.x.loja.estoque_baixo = ENV.fetch("ESTOQUE_BAIXO", 5).to_i
  config.x.loja.pedido_atrasado_horas = ENV.fetch("PEDIDO_ATRASADO_HORAS", 24).to_i
  config.x.loja.relatorio_assincrono_linhas = ENV.fetch("RELATORIO_ASSINCRONO_LINHAS", 5_000).to_i
  config.x.loja.carrinho_expira_dias = ENV.fetch("CARRINHO_EXPIRA_DIAS", 30).to_i

  config.x.retencao.pedidos_meses = ENV.fetch("RETENCAO_PEDIDOS_MESES", 60).to_i
  config.x.retencao.manifestacoes_meses = ENV.fetch("RETENCAO_MANIFESTACOES_MESES", 24).to_i
  config.x.retencao.avaliacoes_meses = ENV.fetch("RETENCAO_AVALIACOES_MESES", 36).to_i
  config.x.retencao.auditoria_meses = ENV.fetch("RETENCAO_AUDITORIA_MESES", 60).to_i
end
