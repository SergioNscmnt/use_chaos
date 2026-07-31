module Administracao
  class CategoriasController < BaseController
    before_action :buscar_categoria, only: %i[edit update destroy]

    def index
      authorize Categoria
      @categorias = Categoria.ordenadas
    end

    def new
      @categoria = Categoria.new
      authorize @categoria
    end

    def edit
      authorize @categoria
    end

    def create
      @categoria = Categoria.new(categoria_params)
      authorize @categoria

      if @categoria.save
        Auditoria::Registrar.call(acao: "categoria.criada", alvo: @categoria, usuario: current_usuario_administrativo, novo: @categoria.attributes)
        redirect_to administracao_categorias_path, notice: "Categoria criada com sucesso."
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      authorize @categoria
      anterior = @categoria.attributes.slice(*categoria_params.keys)

      if @categoria.update(categoria_params)
        Auditoria::Registrar.call(acao: "categoria.atualizada", alvo: @categoria, usuario: current_usuario_administrativo, anterior:, novo: @categoria.attributes.slice(*categoria_params.keys))
        redirect_to administracao_categorias_path, notice: "Categoria atualizada com sucesso."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      authorize @categoria
      @categoria.update!(ativa: false)
      Auditoria::Registrar.call(acao: "categoria.inativada", alvo: @categoria, usuario: current_usuario_administrativo, anterior: { ativa: true }, novo: { ativa: false })
      redirect_to administracao_categorias_path, notice: "Categoria inativada."
    end

    private

    def buscar_categoria
      @categoria = Categoria.find(params[:id])
    end

    def categoria_params
      params.expect(categoria: %i[nome slug descricao ativa posicao])
    end
  end
end
