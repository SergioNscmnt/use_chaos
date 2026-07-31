class CriarAcessosECatalogo < ActiveRecord::Migration[8.1]
  def change
    create_table :perfis do |t|
      t.string :nome, null: false
      t.json :permissoes, null: false
      t.timestamps
    end
    add_index :perfis, :nome, unique: true

    create_table :usuarios_administrativos do |t|
      t.string :nome, null: false
      t.references :perfil, null: false, foreign_key: { to_table: :perfis }
      t.boolean :ativo, null: false, default: true

      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer :sign_in_count, null: false, default: 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip
      t.timestamps null: false
    end
    add_index :usuarios_administrativos, :email, unique: true
    add_index :usuarios_administrativos, :reset_password_token, unique: true
    add_index :usuarios_administrativos, :ativo

    create_table :registros_auditoria do |t|
      t.references :usuario_administrativo, foreign_key: { to_table: :usuarios_administrativos }
      t.string :acao, null: false
      t.string :alvo_type
      t.bigint :alvo_id
      t.json :dados_anteriores
      t.json :dados_novos
      t.json :detalhes
      t.string :endereco_ip
      t.timestamps
    end
    add_index :registros_auditoria, %i[alvo_type alvo_id]
    add_index :registros_auditoria, %i[acao created_at]

    create_table :categorias do |t|
      t.string :nome, null: false
      t.string :slug, null: false
      t.text :descricao
      t.boolean :ativa, null: false, default: true
      t.integer :posicao, null: false, default: 0
      t.timestamps
    end
    add_index :categorias, :nome, unique: true
    add_index :categorias, :slug, unique: true
    add_index :categorias, %i[ativa posicao]

    create_table :produtos do |t|
      t.references :categoria, null: false, foreign_key: { to_table: :categorias }
      t.string :nome, null: false
      t.string :slug, null: false
      t.string :sku, null: false
      t.text :descricao, null: false
      t.json :caracteristicas
      t.bigint :preco_centavos, null: false
      t.bigint :custo_centavos, null: false
      t.integer :estoque, null: false, default: 0
      t.integer :limiar_estoque_baixo
      t.boolean :ativo, null: false, default: true
      t.boolean :publicado, null: false, default: false
      t.boolean :disponivel, null: false, default: true
      t.boolean :destaque, null: false, default: false
      t.datetime :lancamento_em
      t.timestamps
    end
    add_index :produtos, :slug, unique: true
    add_index :produtos, :sku, unique: true
    add_index :produtos, %i[ativo publicado disponivel estoque], name: "idx_produtos_elegibilidade"
    add_index :produtos, %i[categoria_id destaque created_at], name: "idx_produtos_catalogo"
    add_check_constraint :produtos, "preco_centavos >= 0", name: "produtos_preco_nao_negativo"
    add_check_constraint :produtos, "custo_centavos >= 0", name: "produtos_custo_nao_negativo"
    add_check_constraint :produtos, "estoque >= 0", name: "produtos_estoque_nao_negativo"

    create_table :imagens_produto do |t|
      t.references :produto, null: false, foreign_key: { to_table: :produtos }
      t.string :texto_alternativo, null: false
      t.integer :posicao, null: false, default: 0
      t.boolean :principal, null: false, default: false
      t.timestamps
    end
    add_index :imagens_produto, %i[produto_id posicao]

    create_table :movimentacoes_estoque do |t|
      t.references :produto, null: false, foreign_key: { to_table: :produtos }
      t.references :usuario_administrativo, foreign_key: { to_table: :usuarios_administrativos }
      t.string :tipo, null: false
      t.integer :quantidade_anterior, null: false
      t.integer :quantidade_nova, null: false
      t.string :motivo, null: false
      t.string :origem_type
      t.bigint :origem_id
      t.timestamps
    end
    add_index :movimentacoes_estoque, %i[origem_type origem_id]
    add_index :movimentacoes_estoque, %i[produto_id created_at]
    add_check_constraint :movimentacoes_estoque, "quantidade_anterior >= 0", name: "movimentacao_anterior_nao_negativa"
    add_check_constraint :movimentacoes_estoque, "quantidade_nova >= 0", name: "movimentacao_nova_nao_negativa"
  end
end
