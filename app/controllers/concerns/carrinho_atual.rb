module CarrinhoAtual
  extend ActiveSupport::Concern

  included do
    helper_method :carrinho_atual, :carrinho_atual_existente
  end

  private

  def carrinho_atual
    return @carrinho_atual if @carrinho_atual

    @carrinho_atual = carrinho_atual_existente || Carrinho.create!
    @carrinho_atual.renovar!
    cookies.encrypted[:carrinho_token] = {
      value: @carrinho_atual.token,
      expires: @carrinho_atual.expira_em,
      httponly: true,
      same_site: :lax,
      secure: Rails.env.production?
    }
    @carrinho_atual
  end

  def carrinho_atual_existente
    return @carrinho_atual if @carrinho_atual
    return @carrinho_atual_existente if defined?(@carrinho_atual_existente)

    token = cookies.encrypted[:carrinho_token]
    return @carrinho_atual_existente = nil if token.blank?

    @carrinho_atual_existente = Carrinho
      .includes(itens_carrinho: { produto: :categoria })
      .find_by(token:)
    if @carrinho_atual_existente&.expirado?
      cookies.delete(:carrinho_token)
      @carrinho_atual_existente = nil
    end
    @carrinho_atual_existente
  rescue ActiveSupport::MessageEncryptor::InvalidMessage
    cookies.delete(:carrinho_token)
    @carrinho_atual_existente = nil
  end
end
