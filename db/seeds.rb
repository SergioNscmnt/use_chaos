perfis = {
  "administrador" => [ "*" ],
  "atendimento" => %w[gerenciar_pedidos visualizar_dados_pessoais],
  "gestor" => %w[visualizar_metricas gerar_relatorios gerenciar_catalogo],
  "moderador" => %w[moderar_conteudo visualizar_dados_pessoais]
}.transform_values do |permissoes|
  permissoes.sort
end

perfis.each do |nome, permissoes|
  Perfil.find_or_create_by!(nome:) { |perfil| perfil.permissoes = permissoes }
end

administrador = UsuarioAdministrativo.find_or_initialize_by(
  email: ENV.fetch("ADMIN_EMAIL", "admin@oculosneon.test")
)
administrador.assign_attributes(
  nome: ENV.fetch("ADMIN_NOME", "Administrador"),
  perfil: Perfil.find_by!(nome: "administrador"),
  ativo: true
)
if administrador.new_record?
  administrador.password = ENV.fetch("ADMIN_PASSWORD", "TroqueEstaSenha123!")
  administrador.password_confirmation = administrador.password
end
administrador.save!

categorias = [
  [ "Óculos de sol", "oculos-de-sol", "Proteção e atitude para dias luminosos." ],
  [ "Óculos para corrida", "oculos-para-corrida", "Leveza e estabilidade para acompanhar seu ritmo." ],
  [ "Óculos casuais", "oculos-casuais", "Modelos versáteis para todos os dias." ]
].map.with_index do |(nome, slug, descricao), posicao|
  Categoria.find_or_create_by!(slug:) do |categoria|
    categoria.assign_attributes(nome:, descricao:, posicao:, ativa: true)
  end
end

produtos = [
  [ "Eclipse Roxo", "ON-SOL-001", categorias[0], 29_990, 12_000, 15 ],
  [ "Velocity Neon", "ON-COR-001", categorias[1], 34_990, 14_500, 8 ],
  [ "Órbita Urbana", "ON-CAS-001", categorias[2], 24_990, 10_000, 4 ]
]

produtos.each_with_index do |(nome, sku, categoria, preco, custo, estoque), indice|
  Produto.find_or_create_by!(sku:) do |produto|
    produto.assign_attributes(
      nome:,
      slug: nome.parameterize,
      categoria:,
      descricao: "Modelo demonstrativo #{nome}, criado sem dados pessoais reais.",
      caracteristicas: [ "Proteção UV", "Armação leve" ],
      preco_centavos: preco,
      custo_centavos: custo,
      estoque:,
      ativo: true,
      publicado: true,
      disponivel: true,
      destaque: indice.zero?,
      lancamento_em: indice.days.ago
    )
  end
end
