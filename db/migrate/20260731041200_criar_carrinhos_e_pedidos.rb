class CriarCarrinhosEPedidos < ActiveRecord::Migration[8.1]
  def change
    create_table :carrinhos do |t|
      t.string :token, null: false
      t.datetime :expira_em, null: false
      t.timestamps
    end
    add_index :carrinhos, :token, unique: true
    add_index :carrinhos, :expira_em

    create_table :itens_carrinho do |t|
      t.references :carrinho, null: false, foreign_key: { to_table: :carrinhos }
      t.references :produto, null: false, foreign_key: { to_table: :produtos }
      t.integer :quantidade, null: false
      t.bigint :preco_unitario_centavos_observado, null: false
      t.timestamps
    end
    add_index :itens_carrinho, %i[carrinho_id produto_id], unique: true
    add_check_constraint :itens_carrinho, "quantidade > 0", name: "item_carrinho_quantidade_positiva"

    create_table :pedidos do |t|
      t.string :numero, null: false
      t.string :chave_idempotencia, null: false
      t.string :situacao, null: false, default: "iniciado"
      t.string :nome_cliente, null: false
      t.string :contato_cliente, null: false
      t.boolean :aceite_privacidade, null: false, default: false
      t.bigint :total_centavos, null: false, default: 0
      t.boolean :estoque_movimentado, null: false, default: false
      t.boolean :estoque_reposto, null: false, default: false
      t.datetime :confirmado_em
      t.datetime :concluido_em
      t.datetime :cancelado_em
      t.references :responsavel, foreign_key: { to_table: :usuarios_administrativos }
      t.timestamps
    end
    add_index :pedidos, :numero, unique: true
    add_index :pedidos, :chave_idempotencia, unique: true
    add_index :pedidos, %i[situacao created_at]
    add_index :pedidos, :confirmado_em
    add_index :pedidos, :contato_cliente
    add_check_constraint :pedidos, "total_centavos >= 0", name: "pedidos_total_nao_negativo"

    create_table :itens_pedido do |t|
      t.references :pedido, null: false, foreign_key: { to_table: :pedidos }
      t.references :produto, null: false, foreign_key: { to_table: :produtos }
      t.references :categoria, null: false, foreign_key: { to_table: :categorias }
      t.string :produto_nome, null: false
      t.string :produto_sku, null: false
      t.string :categoria_nome, null: false
      t.integer :quantidade, null: false
      t.bigint :preco_unitario_centavos, null: false
      t.bigint :custo_unitario_centavos, null: false
      t.timestamps
    end
    add_index :itens_pedido, %i[pedido_id produto_id]
    add_index :itens_pedido, %i[categoria_id produto_id]
    add_check_constraint :itens_pedido, "quantidade > 0", name: "item_pedido_quantidade_positiva"
    add_check_constraint :itens_pedido, "preco_unitario_centavos >= 0", name: "item_pedido_preco_nao_negativo"
    add_check_constraint :itens_pedido, "custo_unitario_centavos >= 0", name: "item_pedido_custo_nao_negativo"

    create_table :historicos_pedido do |t|
      t.references :pedido, null: false, foreign_key: { to_table: :pedidos }
      t.references :usuario_administrativo, foreign_key: { to_table: :usuarios_administrativos }
      t.string :situacao_anterior
      t.string :situacao_nova, null: false
      t.text :observacao
      t.timestamps
    end
    add_index :historicos_pedido, %i[pedido_id created_at]
  end
end
