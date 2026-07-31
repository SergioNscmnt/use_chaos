class CriarAvaliacoesManifestacoesERelatorios < ActiveRecord::Migration[8.1]
  def change
    create_table :avaliacoes do |t|
      t.references :produto, null: false, foreign_key: { to_table: :produtos }
      t.string :nome_autor
      t.integer :nota, null: false
      t.text :comentario, null: false
      t.string :situacao, null: false, default: "pendente"
      t.references :moderada_por, foreign_key: { to_table: :usuarios_administrativos }
      t.datetime :moderada_em
      t.string :origem_hash
      t.timestamps
    end
    add_index :avaliacoes, %i[produto_id situacao created_at]
    add_index :avaliacoes, :origem_hash
    add_check_constraint :avaliacoes, "nota BETWEEN 1 AND 5", name: "avaliacoes_nota_valida"

    create_table :manifestacoes do |t|
      t.string :tipo, null: false
      t.string :categoria, null: false
      t.text :mensagem, null: false
      t.string :contato
      t.string :situacao, null: false, default: "nova"
      t.references :responsavel, foreign_key: { to_table: :usuarios_administrativos }
      t.text :observacao_interna
      t.string :origem_hash
      t.datetime :tratada_em
      t.timestamps
    end
    add_index :manifestacoes, %i[tipo situacao created_at]
    add_index :manifestacoes, :origem_hash

    create_table :historicos_manifestacao do |t|
      t.references :manifestacao, null: false, foreign_key: { to_table: :manifestacoes }
      t.references :usuario_administrativo, foreign_key: { to_table: :usuarios_administrativos }
      t.string :situacao_anterior
      t.string :situacao_nova, null: false
      t.text :observacao
      t.timestamps
    end
    add_index :historicos_manifestacao, %i[manifestacao_id created_at], name: "idx_historicos_manifestacao_cronologia"

    create_table :geracoes_relatorio do |t|
      t.references :usuario_administrativo, null: false, foreign_key: { to_table: :usuarios_administrativos }
      t.string :formato, null: false
      t.string :situacao, null: false, default: "pendente"
      t.json :filtros, null: false
      t.datetime :gerado_em
      t.text :erro
      t.timestamps
    end
    add_index :geracoes_relatorio, %i[usuario_administrativo_id created_at], name: "idx_geracoes_relatorio_usuario"
    add_index :geracoes_relatorio, :situacao
  end
end
