## ADDED Requirements

### Requirement: Catálogo acessível sem autenticação
O sistema SHALL disponibilizar a página inicial, categorias, listagens e detalhes de produtos sem exigir autenticação, usando HTML semântico e URLs indexáveis.

#### Scenario: Visitante acessa a página inicial
- **WHEN** um visitante acessa a página inicial
- **THEN** o sistema exibe destaques, categorias e lançamentos publicados sem solicitar login

#### Scenario: Robô acessa um produto publicado
- **WHEN** um agente de indexação acessa a URL canônica de um produto ativo
- **THEN** o sistema retorna conteúdo HTML com título, descrição e informações indexáveis do produto

### Requirement: Busca, filtros e ordenação
O sistema SHALL permitir buscar produtos por texto, filtrar por categoria, faixa de preço e disponibilidade e ordenar os resultados por critérios disponibilizados na interface.

#### Scenario: Combinação de critérios
- **WHEN** o visitante busca por um termo e seleciona categoria, faixa de preço e ordenação
- **THEN** o sistema exibe somente produtos publicados que atendem a todos os filtros na ordem escolhida e preserva os critérios na navegação

#### Scenario: Nenhum produto encontrado
- **WHEN** nenhum produto publicado atende aos critérios
- **THEN** o sistema exibe um estado vazio em português e oferece uma ação para limpar os filtros

### Requirement: Detalhes e disponibilidade do produto
O sistema SHALL exibir na página do produto galeria, preço vigente, descrição, características, disponibilidade e avaliações aprovadas, distinguindo produtos disponíveis, sem estoque, indisponíveis e inativos.

#### Scenario: Produto disponível
- **WHEN** um visitante acessa um produto ativo, publicado, disponível e com estoque positivo
- **THEN** o sistema apresenta seus detalhes e permite adicioná-lo ao carrinho

#### Scenario: Produto sem estoque
- **WHEN** um visitante acessa um produto publicado com estoque igual a zero
- **THEN** o sistema informa que o produto está sem estoque e não permite adicioná-lo ao carrinho

#### Scenario: Produto inativo
- **WHEN** um visitante tenta acessar diretamente a URL de um produto inativo
- **THEN** o sistema não expõe seus dados como item comprável e responde com o estado público de não encontrado

### Requirement: Recomendações editoriais
O sistema SHALL apresentar produtos relacionados e marcados como destaque apenas quando estiverem ativos e publicados.

#### Scenario: Produtos relacionados disponíveis
- **WHEN** um produto publicado possui outros produtos elegíveis na mesma categoria
- **THEN** o sistema exibe uma seleção de produtos relacionados sem incluir o próprio produto

