require "prawn"
require "prawn/table"

Prawn::Fonts::AFM.hide_m17n_warning = true

module Relatorios
  module Vendas
    class Pdf
      def self.call(apresentador)
        Prawn::Document.new(page_size: "A4", page_layout: :landscape, margin: 32) do |pdf|
          pdf.text apresentador.titulo, size: 20, style: :bold
          pdf.move_down 6
          pdf.text apresentador.filtros.descricao, size: 9
          pdf.text "Gerado em #{I18n.l(apresentador.gerado_em, format: :long)}", size: 9
          pdf.move_down 16
          dados = [ [ "Pedido", "Produto", "Qtd.", "Receita", "Custo" ] ]
          apresentador.linhas.each do |item|
            dados << [ item.pedido.numero, item.produto_nome, item.quantidade, moeda(item.subtotal_centavos), moeda(item.custo_total_centavos) ]
          end
          dados << [ "Nenhum registro", "", "", "", "" ] if apresentador.linhas.empty?
          pdf.table(dados, header: true, width: pdf.bounds.width, row_colors: %w[F7F3FA FFFFFF]) do |table|
            table.row(0).font_style = :bold
            table.cells.padding = 5
            table.columns(2).align = :right
            table.columns(3..4).align = :right
          end
          pdf.move_down 16
          resumo = apresentador.resumo
          pdf.text "Vendas: #{resumo[:quantidade_vendas]} · Receita: #{moeda(resumo[:receita_bruta_centavos])} · Custo: #{moeda(resumo[:custo_centavos])}"
          pdf.text "Lucro bruto: #{moeda(resumo[:lucro_bruto_centavos])} · Margem: #{resumo[:margem_percentual]}% · Conversão: #{resumo[:conversao_percentual]}%"
          pdf.number_pages "Página <page> de <total>", at: [ pdf.bounds.right - 100, 0 ], width: 100, align: :right, size: 8
        end.render
      end

      def self.moeda(centavos)
        ActionController::Base.helpers.number_to_currency(centavos.to_i / 100.0, locale: :"pt-BR")
      end
      private_class_method :moeda
    end
  end
end
