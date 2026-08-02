module Publico
  class ProdutosController < ApplicationController
    ORDENACOES = {
      "recentes" => { created_at: :desc },
      "menor_preco" => { preco_centavos: :asc },
      "maior_preco" => { preco_centavos: :desc },
      "nome" => { nome: :asc }
    }.freeze

    def index
      @categorias = Categoria.ativas.ordenadas
      produtos = Produto.publicados.includes(:categoria, imagens_produto: { arquivo_attachment: :blob })
      produtos = filtrar(produtos)
      produtos = produtos.order(ORDENACOES.fetch(params[:ordenacao], ORDENACOES["recentes"]))
      @pagy, @produtos = pagy(:offset, produtos, limit: 12)
    end

    def show
      @produto = Produto.publicados
        .includes(:categoria, :avaliacoes, imagens_produto: { arquivo_attachment: :blob })
        .find_by!(slug: params[:slug])
      @avaliacoes = @produto.avaliacoes.aprovadas.recentes.limit(20)
      @relacionados = Produto.publicados
        .where(categoria_id: @produto.categoria_id)
        .where.not(id: @produto.id)
        .includes(:categoria, imagens_produto: { arquivo_attachment: :blob })
        .limit(4)
    end

    private

    def filtrar(produtos)
      if params[:busca].present?
        termo = "%#{ActiveRecord::Base.sanitize_sql_like(params[:busca].strip)}%"
        produtos = produtos.where("produtos.nome LIKE :termo OR produtos.descricao LIKE :termo OR produtos.sku LIKE :termo", termo:)
      end
      produtos = produtos.where(categoria_id: params[:categoria_id]) if params[:categoria_id].present?
      produtos = produtos.where("preco_centavos >= ?", reais_para_centavos(params[:preco_min])) if params[:preco_min].present?
      produtos = produtos.where("preco_centavos <= ?", reais_para_centavos(params[:preco_max])) if params[:preco_max].present?
      produtos = produtos.where(disponivel: true).where("estoque > 0") if params[:disponibilidade] == "disponivel"
      produtos = produtos.where("estoque = 0") if params[:disponibilidade] == "sem_estoque"
      produtos
    end

    def reais_para_centavos(valor)
      Valores::Monetario.para_centavos(valor) || 0
    end
  end
end
