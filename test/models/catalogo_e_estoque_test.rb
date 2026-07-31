require "test_helper"

class CatalogoEEstoqueTest < ActiveSupport::TestCase
  test "produto só é comprável quando toda elegibilidade é atendida" do
    produto = criar_produto
    assert produto.compravel?

    produto.update!(estoque: 0)
    assert_not produto.compravel?
    assert produto.sem_estoque?
  end

  test "produto rejeita valores e estoque negativos" do
    produto = criar_produto
    produto.assign_attributes(preco_centavos: -1, custo_centavos: -1, estoque: -1)
    assert_not produto.valid?
    assert produto.errors[:preco_centavos].any?
    assert produto.errors[:estoque].any?
  end

  test "ajuste de estoque registra movimento e auditoria" do
    produto = criar_produto(estoque: 4)
    usuario = criar_usuario

    assert_difference [ "MovimentacaoEstoque.count", "RegistroAuditoria.count" ], 1 do
      Estoque::Ajustar.call(produto:, quantidade: 9, motivo: "Inventário", usuario:)
    end
    assert_equal 9, produto.reload.estoque
    assert_equal [ 4, 9 ], produto.movimentacoes_estoque.last.values_at(:quantidade_anterior, :quantidade_nova)
  end

  test "imagem exige tipo permitido e texto alternativo" do
    imagem = ImagemProduto.new(produto: criar_produto, texto_alternativo: "")
    imagem.arquivo.attach(io: StringIO.new("arquivo"), filename: "malicioso.txt", content_type: "text/plain")
    assert_not imagem.valid?
    assert imagem.errors[:texto_alternativo].any?
    assert imagem.errors[:arquivo].any?
  end
end
