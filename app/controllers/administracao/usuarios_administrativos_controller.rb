module Administracao
  class UsuariosAdministrativosController < BaseController
    before_action :buscar_usuario, only: %i[show edit update]

    def index
      authorize UsuarioAdministrativo
      @usuarios = UsuarioAdministrativo.includes(:perfil).order(:nome)
    end

    def show
      authorize @usuario
    end

    def new
      @usuario = UsuarioAdministrativo.new
      authorize @usuario
    end

    def edit
      authorize @usuario
    end

    def create
      @usuario = UsuarioAdministrativo.new(usuario_params)
      authorize @usuario
      if @usuario.save
        Auditoria::Registrar.call(acao: "usuario.criado", alvo: @usuario, usuario: current_usuario_administrativo, novo: dados_auditaveis(@usuario))
        redirect_to administracao_usuarios_administrativos_path, notice: "Usuário criado com sucesso."
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      authorize @usuario
      anterior = dados_auditaveis(@usuario)
      atributos = usuario_params
      atributos = atributos.except(:password, :password_confirmation) if atributos[:password].blank?

      if @usuario.update(atributos)
        Auditoria::Registrar.call(acao: "usuario.atualizado", alvo: @usuario, usuario: current_usuario_administrativo, anterior:, novo: dados_auditaveis(@usuario))
        redirect_to administracao_usuarios_administrativos_path, notice: "Usuário atualizado com sucesso."
      else
        render :edit, status: :unprocessable_content
      end
    end

    private

    def buscar_usuario
      @usuario = UsuarioAdministrativo.find(params[:id])
    end

    def usuario_params
      params.expect(usuario_administrativo: %i[nome email whatsapp perfil_id ativo password password_confirmation])
    end

    def dados_auditaveis(usuario)
      usuario.attributes.slice("nome", "email", "whatsapp", "perfil_id", "ativo")
    end
  end
end
