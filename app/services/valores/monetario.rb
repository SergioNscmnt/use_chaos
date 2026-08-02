module Valores
  class Monetario
    class << self
      def para_centavos(valor)
        texto = valor.to_s.strip
        return if texto.blank?

        numero = normalizar_numero(texto)
        return if numero.blank?

        (BigDecimal(numero) * 100).round
      rescue ArgumentError
        nil
      end

      def formatar(centavos)
        return "" if centavos.nil?

        valor = Integer(centavos)
        sinal = valor.negative? ? "-" : ""
        reais, fracao = valor.abs.divmod(100)
        reais_formatados = reais.to_s.reverse.scan(/.{1,3}/).join(".").reverse
        "#{sinal}#{reais_formatados},#{fracao.to_s.rjust(2, '0')}"
      rescue ArgumentError, TypeError
        ""
      end

      private

      def normalizar_numero(texto)
        sinal = texto.include?("-") ? "-" : ""
        numero = texto.gsub(/[^\d,.]/, "")
        return if numero.blank?

        if numero.include?(",")
          inteiro, decimal = numero.rpartition(",").values_at(0, 2)
          "#{sinal}#{inteiro.delete('.,')}.#{decimal.delete('.,')}"
        elsif numero.count(".") == 1 && numero.split(".").last.length != 3
          "#{sinal}#{numero}"
        else
          "#{sinal}#{numero.delete('.')}"
        end
      end
    end
  end
end
