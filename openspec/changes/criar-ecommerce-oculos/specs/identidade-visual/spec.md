## ADDED Requirements

### Requirement: Tema visual da marca
O sistema SHALL aplicar sobre componentes do Tabler tokens centralizados com preto `#000000`, roxo `#A020F0`, laranja `#FF8C00`, branco `#FFFFFF`, tipografia Space Grotesk e detalhes luminosos coerentes.

#### Scenario: Tela pública
- **WHEN** um visitante abre uma página do catálogo
- **THEN** a página usa os tokens da marca e componentes consistentes sem estilos essenciais duplicados na própria tela

#### Scenario: Tela administrativa
- **WHEN** um usuário abre a administração
- **THEN** a tela mantém a identidade visual e diferencia claramente navegação, conteúdo, ações e estados

### Requirement: Responsividade
O sistema SHALL adaptar catálogo, carrinho, checkout, administração, tabelas e gráficos a larguras móveis e desktop sem perda de funcionalidade.

#### Scenario: Navegação móvel
- **WHEN** a interface é acessada em uma viewport móvel suportada
- **THEN** conteúdo e ações essenciais permanecem legíveis, alcançáveis e sem rolagem horizontal não intencional

### Requirement: Acessibilidade de interação
O sistema MUST oferecer contraste suficiente, foco visível, navegação por teclado, rótulos associados, textos alternativos e estados que não dependam somente de cor.

#### Scenario: Navegação por teclado
- **WHEN** uma pessoa percorre a página usando apenas teclado
- **THEN** todos os controles interativos recebem foco em ordem compreensível e podem ser acionados

#### Scenario: Erro de formulário
- **WHEN** um formulário contém erros
- **THEN** o sistema associa cada mensagem ao campo, apresenta um resumo acessível quando necessário e não comunica o erro somente por cor

#### Scenario: Imagem de produto
- **WHEN** uma imagem informativa do produto é renderizada
- **THEN** o sistema fornece texto alternativo administrado

### Requirement: Movimento e efeitos neon
O sistema SHALL limitar animações a melhorias não essenciais e SHALL respeitar a preferência do usuário por redução de movimento.

#### Scenario: Redução de movimento ativada
- **WHEN** o sistema operacional informa `prefers-reduced-motion: reduce`
- **THEN** a interface remove ou reduz animações e transições não essenciais

### Requirement: Melhoria progressiva com Hotwire
O sistema SHALL usar Turbo Frames e Turbo Streams para atualizações parciais e SHALL reservar Stimulus para comportamentos de cliente que HTML e Turbo não resolvam, preservando o fluxo essencial sem JavaScript.

#### Scenario: Atualização parcial disponível
- **WHEN** um usuário altera filtro, carrinho ou formulário compatível com Turbo
- **THEN** o sistema atualiza a região pertinente sem recarregar conteúdo não relacionado

#### Scenario: JavaScript indisponível
- **WHEN** JavaScript está desativado
- **THEN** navegação, consulta e submissões essenciais continuam funcionando por HTML

