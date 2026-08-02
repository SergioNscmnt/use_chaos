# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_02_060000) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "avaliacoes", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.text "comentario", null: false
    t.datetime "created_at", null: false
    t.datetime "moderada_em"
    t.bigint "moderada_por_id"
    t.string "nome_autor"
    t.integer "nota", null: false
    t.string "origem_hash"
    t.bigint "produto_id", null: false
    t.string "situacao", default: "pendente", null: false
    t.datetime "updated_at", null: false
    t.index ["moderada_por_id"], name: "index_avaliacoes_on_moderada_por_id"
    t.index ["origem_hash"], name: "index_avaliacoes_on_origem_hash"
    t.index ["produto_id", "situacao", "created_at"], name: "index_avaliacoes_on_produto_id_and_situacao_and_created_at"
    t.index ["produto_id"], name: "index_avaliacoes_on_produto_id"
    t.check_constraint "`nota` between 1 and 5", name: "avaliacoes_nota_valida"
  end

  create_table "carrinhos", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expira_em", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["expira_em"], name: "index_carrinhos_on_expira_em"
    t.index ["token"], name: "index_carrinhos_on_token", unique: true
  end

  create_table "categorias", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.boolean "ativa", default: true, null: false
    t.datetime "created_at", null: false
    t.text "descricao"
    t.string "nome", null: false
    t.integer "posicao", default: 0, null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["ativa", "posicao"], name: "index_categorias_on_ativa_and_posicao"
    t.index ["nome"], name: "index_categorias_on_nome", unique: true
    t.index ["slug"], name: "index_categorias_on_slug", unique: true
  end

  create_table "geracoes_relatorio", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "erro"
    t.text "filtros", size: :long, null: false, collation: "utf8mb4_bin"
    t.string "formato", null: false
    t.datetime "gerado_em"
    t.string "situacao", default: "pendente", null: false
    t.datetime "updated_at", null: false
    t.bigint "usuario_administrativo_id", null: false
    t.index ["situacao"], name: "index_geracoes_relatorio_on_situacao"
    t.index ["usuario_administrativo_id", "created_at"], name: "idx_geracoes_relatorio_usuario"
    t.index ["usuario_administrativo_id"], name: "index_geracoes_relatorio_on_usuario_administrativo_id"
    t.check_constraint "json_valid(`filtros`)", name: "filtros"
  end

  create_table "historicos_manifestacao", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "manifestacao_id", null: false
    t.text "observacao"
    t.string "situacao_anterior"
    t.string "situacao_nova", null: false
    t.datetime "updated_at", null: false
    t.bigint "usuario_administrativo_id"
    t.index ["manifestacao_id", "created_at"], name: "idx_historicos_manifestacao_cronologia"
    t.index ["manifestacao_id"], name: "index_historicos_manifestacao_on_manifestacao_id"
    t.index ["usuario_administrativo_id"], name: "index_historicos_manifestacao_on_usuario_administrativo_id"
  end

  create_table "historicos_pedido", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "observacao"
    t.bigint "pedido_id", null: false
    t.string "situacao_anterior"
    t.string "situacao_nova", null: false
    t.datetime "updated_at", null: false
    t.bigint "usuario_administrativo_id"
    t.index ["pedido_id", "created_at"], name: "index_historicos_pedido_on_pedido_id_and_created_at"
    t.index ["pedido_id"], name: "index_historicos_pedido_on_pedido_id"
    t.index ["usuario_administrativo_id"], name: "index_historicos_pedido_on_usuario_administrativo_id"
  end

  create_table "imagens_produto", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "posicao", default: 0, null: false
    t.boolean "principal", default: false, null: false
    t.bigint "produto_id", null: false
    t.string "texto_alternativo", null: false
    t.datetime "updated_at", null: false
    t.index ["produto_id", "posicao"], name: "index_imagens_produto_on_produto_id_and_posicao"
    t.index ["produto_id"], name: "index_imagens_produto_on_produto_id"
  end

  create_table "itens_carrinho", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "carrinho_id", null: false
    t.datetime "created_at", null: false
    t.bigint "preco_unitario_centavos_observado", null: false
    t.bigint "produto_id", null: false
    t.integer "quantidade", null: false
    t.datetime "updated_at", null: false
    t.index ["carrinho_id", "produto_id"], name: "index_itens_carrinho_on_carrinho_id_and_produto_id", unique: true
    t.index ["carrinho_id"], name: "index_itens_carrinho_on_carrinho_id"
    t.index ["produto_id"], name: "index_itens_carrinho_on_produto_id"
    t.check_constraint "`quantidade` > 0", name: "item_carrinho_quantidade_positiva"
  end

  create_table "itens_pedido", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "categoria_id", null: false
    t.string "categoria_nome", null: false
    t.datetime "created_at", null: false
    t.bigint "custo_unitario_centavos", null: false
    t.bigint "pedido_id", null: false
    t.bigint "preco_unitario_centavos", null: false
    t.bigint "produto_id", null: false
    t.string "produto_nome", null: false
    t.string "produto_sku", null: false
    t.integer "quantidade", null: false
    t.datetime "updated_at", null: false
    t.index ["categoria_id", "produto_id"], name: "index_itens_pedido_on_categoria_id_and_produto_id"
    t.index ["categoria_id"], name: "index_itens_pedido_on_categoria_id"
    t.index ["pedido_id", "produto_id"], name: "index_itens_pedido_on_pedido_id_and_produto_id"
    t.index ["pedido_id"], name: "index_itens_pedido_on_pedido_id"
    t.index ["produto_id"], name: "index_itens_pedido_on_produto_id"
    t.check_constraint "`custo_unitario_centavos` >= 0", name: "item_pedido_custo_nao_negativo"
    t.check_constraint "`preco_unitario_centavos` >= 0", name: "item_pedido_preco_nao_negativo"
    t.check_constraint "`quantidade` > 0", name: "item_pedido_quantidade_positiva"
  end

  create_table "manifestacoes", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "categoria", null: false
    t.string "contato"
    t.datetime "created_at", null: false
    t.text "mensagem", null: false
    t.text "observacao_interna"
    t.string "origem_hash"
    t.bigint "responsavel_id"
    t.string "situacao", default: "nova", null: false
    t.string "tipo", null: false
    t.datetime "tratada_em"
    t.datetime "updated_at", null: false
    t.index ["origem_hash"], name: "index_manifestacoes_on_origem_hash"
    t.index ["responsavel_id"], name: "index_manifestacoes_on_responsavel_id"
    t.index ["tipo", "situacao", "created_at"], name: "index_manifestacoes_on_tipo_and_situacao_and_created_at"
  end

  create_table "movimentacoes_estoque", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "motivo", null: false
    t.bigint "origem_id"
    t.string "origem_type"
    t.bigint "produto_id", null: false
    t.integer "quantidade_anterior", null: false
    t.integer "quantidade_nova", null: false
    t.string "tipo", null: false
    t.datetime "updated_at", null: false
    t.bigint "usuario_administrativo_id"
    t.index ["origem_type", "origem_id"], name: "index_movimentacoes_estoque_on_origem_type_and_origem_id"
    t.index ["produto_id", "created_at"], name: "index_movimentacoes_estoque_on_produto_id_and_created_at"
    t.index ["produto_id"], name: "index_movimentacoes_estoque_on_produto_id"
    t.index ["usuario_administrativo_id"], name: "index_movimentacoes_estoque_on_usuario_administrativo_id"
    t.check_constraint "`quantidade_anterior` >= 0", name: "movimentacao_anterior_nao_negativa"
    t.check_constraint "`quantidade_nova` >= 0", name: "movimentacao_nova_nao_negativa"
  end

  create_table "pedidos", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.boolean "aceite_privacidade", default: false, null: false
    t.datetime "cancelado_em"
    t.string "chave_idempotencia", null: false
    t.datetime "concluido_em"
    t.datetime "confirmado_em"
    t.string "contato_cliente", null: false
    t.datetime "created_at", null: false
    t.boolean "estoque_movimentado", default: false, null: false
    t.boolean "estoque_reposto", default: false, null: false
    t.string "nome_cliente", null: false
    t.string "numero", null: false
    t.bigint "responsavel_id"
    t.string "situacao", default: "iniciado", null: false
    t.bigint "total_centavos", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["chave_idempotencia"], name: "index_pedidos_on_chave_idempotencia", unique: true
    t.index ["confirmado_em"], name: "index_pedidos_on_confirmado_em"
    t.index ["contato_cliente"], name: "index_pedidos_on_contato_cliente"
    t.index ["numero"], name: "index_pedidos_on_numero", unique: true
    t.index ["responsavel_id"], name: "index_pedidos_on_responsavel_id"
    t.index ["situacao", "created_at"], name: "index_pedidos_on_situacao_and_created_at"
    t.check_constraint "`total_centavos` >= 0", name: "pedidos_total_nao_negativo"
  end

  create_table "perfis", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nome", null: false
    t.text "permissoes", size: :long, null: false, collation: "utf8mb4_bin"
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_perfis_on_nome", unique: true
    t.check_constraint "json_valid(`permissoes`)", name: "permissoes"
  end

  create_table "produtos", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.text "caracteristicas", size: :long, collation: "utf8mb4_bin"
    t.bigint "categoria_id", null: false
    t.datetime "created_at", null: false
    t.bigint "custo_centavos", null: false
    t.text "descricao", null: false
    t.boolean "destaque", default: false, null: false
    t.boolean "disponivel", default: true, null: false
    t.integer "estoque", default: 0, null: false
    t.datetime "lancamento_em"
    t.integer "limiar_estoque_baixo"
    t.string "nome", null: false
    t.bigint "preco_centavos", null: false
    t.boolean "publicado", default: false, null: false
    t.string "sku", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["ativo", "publicado", "disponivel", "estoque"], name: "idx_produtos_elegibilidade"
    t.index ["categoria_id", "destaque", "created_at"], name: "idx_produtos_catalogo"
    t.index ["categoria_id"], name: "index_produtos_on_categoria_id"
    t.index ["sku"], name: "index_produtos_on_sku", unique: true
    t.index ["slug"], name: "index_produtos_on_slug", unique: true
    t.check_constraint "`custo_centavos` >= 0", name: "produtos_custo_nao_negativo"
    t.check_constraint "`estoque` >= 0", name: "produtos_estoque_nao_negativo"
    t.check_constraint "`preco_centavos` >= 0", name: "produtos_preco_nao_negativo"
    t.check_constraint "json_valid(`caracteristicas`)", name: "caracteristicas"
  end

  create_table "registros_auditoria", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "acao", null: false
    t.bigint "alvo_id"
    t.string "alvo_type"
    t.datetime "created_at", null: false
    t.text "dados_anteriores", size: :long, collation: "utf8mb4_bin"
    t.text "dados_novos", size: :long, collation: "utf8mb4_bin"
    t.text "detalhes", size: :long, collation: "utf8mb4_bin"
    t.string "endereco_ip"
    t.datetime "updated_at", null: false
    t.bigint "usuario_administrativo_id"
    t.index ["acao", "created_at"], name: "index_registros_auditoria_on_acao_and_created_at"
    t.index ["alvo_type", "alvo_id"], name: "index_registros_auditoria_on_alvo_type_and_alvo_id"
    t.index ["usuario_administrativo_id"], name: "index_registros_auditoria_on_usuario_administrativo_id"
    t.check_constraint "json_valid(`dados_anteriores`)", name: "dados_anteriores"
    t.check_constraint "json_valid(`dados_novos`)", name: "dados_novos"
    t.check_constraint "json_valid(`detalhes`)", name: "detalhes"
  end

  create_table "usuarios_administrativos", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "nome", null: false
    t.bigint "perfil_id", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "whatsapp", limit: 15
    t.index ["ativo"], name: "index_usuarios_administrativos_on_ativo"
    t.index ["email"], name: "index_usuarios_administrativos_on_email", unique: true
    t.index ["perfil_id"], name: "index_usuarios_administrativos_on_perfil_id"
    t.index ["reset_password_token"], name: "index_usuarios_administrativos_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "avaliacoes", "produtos"
  add_foreign_key "avaliacoes", "usuarios_administrativos", column: "moderada_por_id"
  add_foreign_key "geracoes_relatorio", "usuarios_administrativos"
  add_foreign_key "historicos_manifestacao", "manifestacoes"
  add_foreign_key "historicos_manifestacao", "usuarios_administrativos"
  add_foreign_key "historicos_pedido", "pedidos"
  add_foreign_key "historicos_pedido", "usuarios_administrativos"
  add_foreign_key "imagens_produto", "produtos"
  add_foreign_key "itens_carrinho", "carrinhos"
  add_foreign_key "itens_carrinho", "produtos"
  add_foreign_key "itens_pedido", "categorias"
  add_foreign_key "itens_pedido", "pedidos"
  add_foreign_key "itens_pedido", "produtos"
  add_foreign_key "manifestacoes", "usuarios_administrativos", column: "responsavel_id"
  add_foreign_key "movimentacoes_estoque", "produtos"
  add_foreign_key "movimentacoes_estoque", "usuarios_administrativos"
  add_foreign_key "pedidos", "usuarios_administrativos", column: "responsavel_id"
  add_foreign_key "produtos", "categorias"
  add_foreign_key "registros_auditoria", "usuarios_administrativos"
  add_foreign_key "usuarios_administrativos", "perfis"
end
