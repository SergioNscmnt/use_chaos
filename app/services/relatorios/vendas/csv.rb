require "csv"

module Relatorios
  module Vendas
    class Csv
      def self.call(apresentador)
        CSV.generate(String.new("\uFEFF"), col_sep: ";", force_quotes: true) do |csv|
          csv << [ apresentador.titulo ]
          csv << [ apresentador.filtros.descricao ]
          csv << [ "Gerado em", I18n.l(apresentador.gerado_em, format: :long) ]
          csv << []
          csv << [ "Pedido", "Confirmação", "Categoria", "Produto", "SKU", "Quantidade", "Preço unitário", "Custo unitário", "Receita", "Custo" ]
          apresentador.linhas.each do |item|
            csv << [
              item.pedido.numero,
              I18n.l(item.pedido.confirmado_em, format: :long),
              item.categoria_nome,
              item.produto_nome,
              item.produto_sku,
              item.quantidade,
              moeda(item.preco_unitario_centavos),
              moeda(item.custo_unitario_centavos),
              moeda(item.subtotal_centavos),
              moeda(item.custo_total_centavos)
            ]
          end
          csv << []
          resumo = apresentador.resumo
          csv << [ "Vendas", resumo[:quantidade_vendas] ]
          csv << [ "Receita bruta", moeda(resumo[:receita_bruta_centavos]) ]
          csv << [ "Custo dos produtos vendidos", moeda(resumo[:custo_centavos]) ]
          csv << [ "Lucro bruto", moeda(resumo[:lucro_bruto_centavos]) ]
          csv << [ "Prejuízo", moeda(resumo[:prejuizo_centavos]) ]
          csv << [ "Margem", "#{resumo[:margem_percentual]}%" ]
          csv << [ "Ticket médio", moeda(resumo[:ticket_medio_centavos]) ]
          csv << [ "Conversão", "#{resumo[:conversao_percentual]}%" ]
        end
      end

      def self.moeda(centavos)
        ActionController::Base.helpers.number_to_currency(centavos.to_i / 100.0, locale: :"pt-BR")
      end
      private_class_method :moeda
    end
  end
end
