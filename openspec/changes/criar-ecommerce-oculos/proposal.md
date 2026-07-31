## Why

O negócio precisa de uma plataforma própria para comercializar óculos de sol, esportivos e casuais, com catálogo público alinhado à marca e gestão centralizada de produtos, estoque, pedidos e relacionamento com clientes. Como a compra será concluída pelo WhatsApp, a aplicação também deve registrar e acompanhar esse funil para produzir indicadores confiáveis de vendas, custos, rentabilidade, conversão e satisfação sem controles paralelos.

## What Changes

- Criar uma aplicação web monolítica em Ruby 4.0.1, Rails 8+, MySQL e Hotwire, configurada integralmente para português do Brasil, moeda BRL e fuso horário inicialmente definido como `America/Porto_Velho`.
- Adotar identificadores de domínio em português, sem acentos, e configurar inflections do Active Support com regras explícitas e testadas para os termos do negócio, incluindo o incontável `oculos`.
- Disponibilizar um catálogo público, responsivo e indexável com página inicial, categorias, busca, ordenação, filtros, detalhes, galeria, avaliações, destaques, lançamentos, produtos relacionados e estados de indisponibilidade.
- Implementar carrinho persistente para visitantes, com inclusão, alteração de quantidade e remoção de itens.
- Criar o checkout via WhatsApp: validar preço e estoque, coletar somente os dados necessários, registrar um pedido interno numerado e abrir uma mensagem pré-preenchida com cliente, itens, quantidades e valores.
- Permitir o acompanhamento administrativo dos pedidos nas situações iniciado, em atendimento, confirmado, concluído e cancelado, considerando somente pedidos confirmados ou concluídos nas métricas de venda.
- Criar uma área administrativa autenticada e autorizada para gerenciar catálogo, imagens, preços, custos, estoque, pedidos, usuários internos, avaliações, manifestações públicas, métricas e relatórios.
- Preservar nos itens do pedido os dados financeiros e descritivos relevantes do momento da compra para que mudanças posteriores no produto não alterem o histórico.
- Receber avaliações de produtos com nota e comentário, submetê-las à moderação e calcular médias somente com registros aprovados.
- Oferecer um canal público para sugestões e feedbacks com confirmação de envio, prevenção de abuso e tratamento administrativo.
- Apresentar painel gerencial filtrável com vendas, receita, custo, lucro ou prejuízo, margem, ticket médio, conversão, situações dos pedidos, desempenho de produtos e categorias, avaliações e estoque baixo.
- Exportar relatórios em PDF e CSV, adequados para impressão e análise, com filtros aplicados e data de geração.
- Usar os componentes do Tabler com identidade visual futurista própria: preto `#000000`, roxo `#A020F0`, laranja `#FF8C00`, branco `#FFFFFF`, tipografia Space Grotesk, detalhes neon, responsividade e acessibilidade.
- Aplicar controles de segurança, privacidade e rastreabilidade, incluindo CSRF, validação e sanitização, limitação de requisições públicas, proteção e retenção de dados pessoais e auditoria administrativa.
- Cobrir com testes automatizados as regras de negócio, permissões, catálogo, carrinho, checkout, WhatsApp, finanças, relatórios, avaliações e inflections.
- Manter fora do escopo inicial pagamento eletrônico, frete e rastreamento, marketplace, aplicativo nativo, automação de conversas ou confirmações pelo WhatsApp e emissão fiscal.

## Capabilities

### New Capabilities

- `catalogo-publico`: navegação pública, busca, filtros, categorias, detalhes, disponibilidade, produtos relacionados, lançamentos e destaques.
- `carrinho-compras`: persistência e manutenção dos itens e quantidades escolhidos por visitantes.
- `checkout-whatsapp`: validação do checkout, criação do pedido interno e abertura do WhatsApp com mensagem estruturada.
- `gestao-produtos`: administração de categorias, produtos, imagens, preços, custos, estoque, destaques e disponibilidade.
- `gestao-pedidos`: acompanhamento do ciclo de atendimento e histórico das mudanças de situação dos pedidos.
- `avaliacoes-produtos`: recebimento, moderação, publicação e consolidação das notas dos produtos.
- `sugestoes-feedbacks`: recebimento seguro e tratamento administrativo das manifestações dos usuários.
- `metricas-vendas`: cálculo filtrável de vendas, receita, custos, lucro, prejuízo, margem, conversão e ticket médio.
- `relatorios-gerenciais`: consulta e exportação de relatórios gerenciais em PDF e CSV.
- `administracao-acesso`: autenticação, autorização por perfil e auditoria das ações administrativas.
- `internacionalizacao-pt-br`: localização, formatos, nomenclatura do domínio e inflections em português do Brasil.
- `identidade-visual`: aplicação acessível e responsiva do Tabler com tema futurista, paleta neon e Space Grotesk.

### Modified Capabilities

Nenhuma. Esta é a proposta inicial de uma aplicação nova.

## Impact

- **Aplicação e dados:** criação integral do projeto Rails, das interfaces pública e administrativa, dos fluxos Hotwire e do esquema MySQL para catálogo, carrinho, pedidos, avaliações, manifestações, usuários e auditoria.
- **Integrações:** geração de URL pública do WhatsApp com mensagem pré-preenchida, sem API paga ou automação de mensagens na primeira versão.
- **Dependências:** Tabler, Space Grotesk e bibliotecas estritamente necessárias para autenticação, autorização, imagens, paginação, gráficos, PDF, CSV e testes.
- **Operação:** a equipe administrativa deverá manter as situações dos pedidos atualizadas para que estoque e indicadores permaneçam confiáveis.
- **Privacidade:** dados de contato e pedidos estarão sujeitos a acesso restrito, retenção documentada e tratamento compatível com a LGPD.
- **Compatibilidade:** regras globais de inflection serão limitadas e testadas para evitar efeitos indevidos em tabelas, rotas e associações.
