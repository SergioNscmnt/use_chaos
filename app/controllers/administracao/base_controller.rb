module Administracao
  class BaseController < ApplicationController
    layout "administracao"
    before_action :authenticate_usuario_administrativo!

    private

    def pundit_user
      current_usuario_administrativo
    end
  end
end
