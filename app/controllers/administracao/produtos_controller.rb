module Administracao
  class ProdutosController < BaseController
    before_action :buscar_produto, only: %i[show edit update destroy ajustar_estoque]

    def index
      authorize Produto
      @produtos = Produto.includes(:categoria).order(created_at: :desc)
      @produtos = @produtos.where(categoria_id: params[:categoria_id]) if params[:categoria_id].present?
      @produtos = @produtos.where(ativo: ActiveModel::Type::Boolean.new.cast(params[:ativo])) if params[:ativo].present?
      @categorias = Categoria.ordenadas
    end

    def show
      authorize @produto
    end

    def new
      @produto = Produto.new
      @produto.imagens_produto.build
      authorize @produto
    end

    def edit
      @produto.imagens_produto.build
      authorize @produto
    end

    def create
      @produto = Produto.new(produto_params)
      authorize @produto

      if @produto.save
        Auditoria::Registrar.call(acao: "produto.criado", alvo: @produto, usuario: current_usuario_administrativo, novo: atributos_auditaveis(@produto))
        redirect_to administracao_produto_path(@produto), notice: "Produto criado com sucesso."
      else
        @produto.imagens_produto.build if @produto.imagens_produto.empty?
        render :new, status: :unprocessable_content
      end
    end

    def update
      authorize @produto
      anterior = atributos_auditaveis(@produto)

      if @produto.update(produto_params)
        Auditoria::Registrar.call(acao: "produto.atualizado", alvo: @produto, usuario: current_usuario_administrativo, anterior:, novo: atributos_auditaveis(@produto))
        redirect_to administracao_produto_path(@produto), notice: "Produto atualizado com sucesso."
      else
        @produto.imagens_produto.build if @produto.imagens_produto.empty?
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      authorize @produto
      @produto.update!(ativo: false, publicado: false)
      Auditoria::Registrar.call(acao: "produto.inativado", alvo: @produto, usuario: current_usuario_administrativo, anterior: { ativo: true }, novo: { ativo: false, publicado: false })
      redirect_to administracao_produtos_path, notice: "Produto inativado sem alterar pedidos históricos."
    end

    def ajustar_estoque
      authorize @produto, :ajustar_estoque?
      Estoque::Ajustar.call(
        produto: @produto,
        quantidade: params[:quantidade],
        motivo: params[:motivo],
        usuario: current_usuario_administrativo
      )
      redirect_to administracao_produto_path(@produto), notice: "Estoque ajustado com sucesso."
    rescue ActiveRecord::RecordInvalid => erro
      redirect_to administracao_produto_path(@produto), alert: erro.record.errors.full_messages.to_sentence
    end

    private

    def buscar_produto
      @produto = Produto.includes(imagens_produto: { arquivo_attachment: :blob }).find(params[:id])
    end

    def produto_params
      params.expect(produto: [
        :categoria_id, :nome, :slug, :sku, :descricao, :preco_centavos, :custo_centavos,
        :limiar_estoque_baixo, :ativo, :publicado, :disponivel, :destaque, :lancamento_em,
        { caracteristicas: [], imagens_produto_attributes: %i[id arquivo texto_alternativo posicao principal _destroy] }
      ])
    end

    def atributos_auditaveis(produto)
      produto.attributes.slice(
        "categoria_id", "nome", "slug", "sku", "descricao", "preco_centavos",
        "custo_centavos", "estoque", "ativo", "publicado", "disponivel", "destaque"
      )
    end
  end
end
