module DadosTeste
  def criar_perfil(permissoes: [ "*" ])
    Perfil.create!(nome: "perfil-#{SecureRandom.hex(4)}", permissoes:)
  end

  def criar_usuario(permissoes: [ "*" ], ativo: true)
    UsuarioAdministrativo.create!(
      nome: "Usuário Teste",
      email: "usuario-#{SecureRandom.hex(4)}@example.test",
      password: "SenhaSegura123!",
      password_confirmation: "SenhaSegura123!",
      perfil: criar_perfil(permissoes:),
      ativo:
    )
  end

  def criar_categoria(ativa: true)
    sufixo = SecureRandom.hex(4)
    Categoria.create!(nome: "Categoria #{sufixo}", slug: "categoria-#{sufixo}", descricao: "Descrição", ativa:)
  end

  def criar_produto(categoria: criar_categoria, estoque: 10, preco: 10_000, custo: 4_000, publicado: true, ativo: true, disponivel: true, destaque: false)
    sufixo = SecureRandom.hex(4)
    Produto.create!(
      categoria:,
      nome: "Óculos #{sufixo}",
      slug: "oculos-#{sufixo}",
      sku: "SKU-#{sufixo}",
      descricao: "Óculos de teste com descrição pública.",
      caracteristicas: [ "Proteção UV" ],
      preco_centavos: preco,
      custo_centavos: custo,
      estoque:,
      publicado:,
      ativo:,
      disponivel:,
      destaque:
    )
  end

  def criar_pedido(produto:, situacao: "iniciado", quantidade: 2, confirmado_em: nil)
    pedido = Pedido.create!(
      chave_idempotencia: SecureRandom.uuid,
      nome_cliente: "Cliente Teste",
      contato_cliente: "cliente@example.test",
      aceite_privacidade: true,
      situacao:,
      confirmado_em:,
      total_centavos: produto.preco_centavos * quantidade
    )
    pedido.itens_pedido.create!(
      produto:,
      categoria: produto.categoria,
      produto_nome: produto.nome,
      produto_sku: produto.sku,
      categoria_nome: produto.categoria.nome,
      quantidade:,
      preco_unitario_centavos: produto.preco_centavos,
      custo_unitario_centavos: produto.custo_centavos
    )
    pedido
  end
end

ActiveSupport::TestCase.include DadosTeste
