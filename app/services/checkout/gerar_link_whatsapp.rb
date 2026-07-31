require "uri"

module Checkout
  class GerarLinkWhatsapp
    def self.call(pedido)
      numero = Rails.configuration.x.loja.whatsapp_numero.to_s.gsub(/\D/, "")
      linhas = [
        "Olá! Quero continuar o pedido #{pedido.numero}.",
        "",
        "Cliente: #{pedido.nome_cliente}",
        "Contato: #{pedido.contato_cliente}",
        "",
        "Itens:"
      ]
      pedido.itens_pedido.each do |item|
        linhas << "- #{item.produto_nome} (#{item.produto_sku}) — #{item.quantidade} x #{moeda(item.preco_unitario_centavos)}"
      end
      linhas << ""
      linhas << "Total: #{moeda(pedido.total_centavos)}"
      "https://wa.me/#{numero}?text=#{URI.encode_www_form_component(linhas.join("\n"))}"
    end

    def self.moeda(centavos)
      ActionController::Base.helpers.number_to_currency(centavos / 100.0, locale: :"pt-BR")
    end
    private_class_method :moeda
  end
end
