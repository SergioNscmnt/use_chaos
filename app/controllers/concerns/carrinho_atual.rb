module CarrinhoAtual
  extend ActiveSupport::Concern

  included do
    helper_method :carrinho_atual
  end

  private

  def carrinho_atual
    return @carrinho_atual if defined?(@carrinho_atual)

    token = cookies.encrypted[:carrinho_token]
    @carrinho_atual = Carrinho.find_by(token:)
    @carrinho_atual = nil if @carrinho_atual&.expirado?
    @carrinho_atual ||= Carrinho.create!
    @carrinho_atual.renovar!
    cookies.encrypted[:carrinho_token] = {
      value: @carrinho_atual.token,
      expires: @carrinho_atual.expira_em,
      httponly: true,
      same_site: :lax,
      secure: Rails.env.production?
    }
    @carrinho_atual
  rescue ActiveSupport::MessageEncryptor::InvalidMessage
    cookies.delete(:carrinho_token)
    retry
  end
end
