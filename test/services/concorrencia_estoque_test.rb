require "test_helper"

class ConcorrenciaEstoqueTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  setup do
    @usuario = criar_usuario
    @produto = criar_produto(estoque: 1)
  end

  teardown do
    ids_pedidos = Pedido.where(chave_idempotencia: @chaves_pedidos).pluck(:id)
    HistoricoPedido.where(pedido_id: ids_pedidos).delete_all
    RegistroAuditoria.where(alvo_type: "Pedido", alvo_id: ids_pedidos).delete_all
    ItemPedido.where(pedido_id: ids_pedidos).delete_all
    Pedido.where(id: ids_pedidos).delete_all
    MovimentacaoEstoque.where(produto_id: @produto&.id).delete_all
    RegistroAuditoria.where(alvo_type: "Produto", alvo_id: @produto&.id).delete_all
    Produto.where(id: @produto&.id).delete_all
    Categoria.where(id: @produto&.categoria_id).delete_all
    UsuarioAdministrativo.where(id: @usuario&.id).delete_all
    Perfil.where(id: @usuario&.perfil_id).delete_all
  end

  test "somente um pedido confirma quando dois disputam o último item" do
    pedidos = 2.times.map { criar_pedido(produto: @produto, quantidade: 1) }
    @chaves_pedidos = pedidos.map(&:chave_idempotencia)

    resultados = executar_em_concorrencia(pedidos.map(&:id)) do |pedido_id|
      Pedidos::Transicionar.call(
        pedido: Pedido.find(pedido_id),
        nova_situacao: "confirmado",
        usuario: UsuarioAdministrativo.find(@usuario.id)
      )
      :confirmado
    rescue ActiveRecord::RecordInvalid
      :sem_estoque
    end

    assert_equal [ :confirmado, :sem_estoque ], resultados.sort
    assert_equal 0, @produto.reload.estoque
    assert_equal 1, Pedido.where(id: pedidos.map(&:id), situacao: "confirmado").count
    assert_equal 1, @produto.movimentacoes_estoque.where(tipo: "baixa_pedido").count
  end

  test "ajustes simultâneos preservam uma cadeia auditável" do
    resultados = executar_em_concorrencia([ 8, 9 ]) do |quantidade|
      Estoque::Ajustar.call(
        produto: Produto.find(@produto.id),
        quantidade:,
        motivo: "Contagem concorrente #{quantidade}",
        usuario: UsuarioAdministrativo.find(@usuario.id)
      )
      quantidade
    end

    movimentos = @produto.movimentacoes_estoque.order(:created_at, :id).to_a
    assert_equal [ 8, 9 ], resultados.sort
    assert_equal 2, movimentos.size
    assert_equal 1, movimentos.first.quantidade_anterior
    assert_equal movimentos.first.quantidade_nova, movimentos.second.quantidade_anterior
    assert_equal movimentos.second.quantidade_nova, @produto.reload.estoque
  end

  private

  def executar_em_concorrencia(valores)
    prontos = Queue.new
    iniciar = Queue.new
    resultados = Queue.new
    threads = valores.map do |valor|
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          prontos << true
          iniciar.pop
          resultados << yield(valor)
        end
      end
    end
    valores.size.times { prontos.pop }
    valores.size.times { iniciar << true }
    threads.each(&:join)
    valores.size.times.map { resultados.pop }
  end
end
