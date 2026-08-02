class ApplicationController < ActionController::Base
  include CarrinhoAtual
  include Pundit::Authorization
  include Pagy::Method

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from Pundit::NotAuthorizedError do
    redirect_back fallback_location: root_path, alert: "Você não tem permissão para realizar esta ação."
  end

  protected

  def after_sign_in_path_for(resource)
    return administracao_root_path if resource.is_a?(UsuarioAdministrativo)

    super
  end
end
