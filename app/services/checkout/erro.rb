module Checkout
  class Erro < StandardError
    attr_reader :detalhes

    def initialize(mensagem, detalhes: [])
      @detalhes = detalhes
      super(mensagem)
    end
  end
end
