# Regras deliberadamente restritas ao domínio. Não limpamos as regras padrão
# porque isso quebraria convenções internas do Rails e de gems.
ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular "produto", "produtos"
  inflect.irregular "categoria", "categorias"
  inflect.irregular "avaliacao", "avaliacoes"
  inflect.irregular "sugestao", "sugestoes"
  inflect.irregular "manifestacao", "manifestacoes"
  inflect.irregular "situacao", "situacoes"
  inflect.irregular "perfil", "perfis"
  inflect.irregular "usuario_administrativo", "usuarios_administrativos"
  inflect.irregular "item_carrinho", "itens_carrinho"
  inflect.irregular "item_pedido", "itens_pedido"
  inflect.irregular "historico_pedido", "historicos_pedido"
  inflect.irregular "imagem_produto", "imagens_produto"
  inflect.irregular "movimentacao_estoque", "movimentacoes_estoque"
  inflect.irregular "registro_auditoria", "registros_auditoria"
  inflect.irregular "historico_manifestacao", "historicos_manifestacao"
  inflect.irregular "geracao_relatorio", "geracoes_relatorio"
  inflect.uncountable "oculos"
end
