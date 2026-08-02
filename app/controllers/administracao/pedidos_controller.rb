module Administracao
  class PedidosController < BaseController
    before_action :buscar_pedido, only: %i[show alterar_situacao]

    def index
      authorize Pedido
      @pedidos = Pedido.includes(:responsavel).order(created_at: :desc)
      @pedidos = @pedidos.where(situacao: params[:situacao]) if params[:situacao].present?
      @pedidos = @pedidos.where(responsavel_id: params[:responsavel_id]) if params[:responsavel_id].present?
      if params[:busca].present?
        busca = params[:busca].strip
        termo = "%#{ActiveRecord::Base.sanitize_sql_like(busca)}%"
        digitos = busca.gsub(/\D/, "")
        consulta = "numero LIKE :termo OR contato_cliente LIKE :termo"
        argumentos = { termo: }

        if digitos.length >= 8
          contato_normalizado = <<~SQL.squish
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(contato_cliente,
            '+', ''), ' ', ''), '(', ''), ')', ''), '-', ''), '.', '')
          SQL
          consulta += " OR #{contato_normalizado} LIKE :digitos"
          argumentos[:digitos] = "%#{ActiveRecord::Base.sanitize_sql_like(digitos)}%"
        end

        @pedidos = @pedidos.where(consulta, argumentos)
      end
      @pedidos = @pedidos.where(created_at: Time.zone.parse(params[:inicio]).beginning_of_day..) if params[:inicio].present?
      @pedidos = @pedidos.where(created_at: ..Time.zone.parse(params[:fim]).end_of_day) if params[:fim].present?
    end

    def show
      authorize @pedido
      @transicoes = Pedidos::Transicionar::TRANSICOES.fetch(@pedido.situacao)
    end

    def alterar_situacao
      authorize @pedido
      Pedidos::Transicionar.call(
        pedido: @pedido,
        nova_situacao: params[:nova_situacao],
        observacao: params[:observacao],
        usuario: current_usuario_administrativo
      )
      redirect_to administracao_pedido_path(@pedido), notice: "Situação atualizada."
    rescue ActiveRecord::RecordInvalid => erro
      redirect_to administracao_pedido_path(@pedido), alert: erro.record.errors.full_messages.to_sentence
    end

    private

    def buscar_pedido
      @pedido = Pedido.includes(:responsavel, :historicos_pedido, itens_pedido: %i[produto categoria]).find(params[:id])
    end
  end
end
