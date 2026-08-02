module Administracao
  class MinhaContaController < BaseController
    before_action :buscar_usuario

    def show
      authorize @usuario, :atualizar_propria_conta?
    end

    def update
      authorize @usuario, :atualizar_propria_conta?
      anterior = dados_auditaveis(@usuario)
      atributos = conta_params

      atualizado = if alteracao_sensivel?(atributos)
        @usuario.update_with_password(atributos)
      else
        @usuario.update(atributos.except(:current_password, :password, :password_confirmation))
      end

      if atualizado
        Auditoria::Registrar.call(
          acao: "usuario.conta_atualizada",
          alvo: @usuario,
          usuario: @usuario,
          anterior:,
          novo: dados_auditaveis(@usuario)
        )
        bypass_sign_in(@usuario) if atributos[:password].present?
        redirect_to administracao_minha_conta_path, notice: "Conta atualizada com sucesso."
      else
        render :show, status: :unprocessable_content
      end
    end

    private

    def buscar_usuario
      @usuario = current_usuario_administrativo
    end

    def conta_params
      params.expect(usuario_administrativo: %i[
        nome email whatsapp current_password password password_confirmation
      ])
    end

    def alteracao_sensivel?(atributos)
      atributos[:password].present? || !atributos[:email].to_s.casecmp?(@usuario.email)
    end

    def dados_auditaveis(usuario)
      usuario.attributes.slice("nome", "email", "whatsapp")
    end
  end
end
