## Context

O projeto parte de uma base vazia e precisa entregar, em uma única aplicação, um catálogo público indexável, um carrinho para visitantes, a abertura do atendimento no WhatsApp e uma operação administrativa capaz de transformar esses atendimentos em pedidos rastreáveis. Os principais interessados são visitantes, clientes, equipe de atendimento e administradores.

A solução deve usar Ruby 4.0.1, Rails 8+, MySQL, Hotwire, Turbo Rails e Stimulus. A interface e o domínio serão escritos em português do Brasil, com Tabler e uma camada visual própria. Como o WhatsApp não notificará a aplicação sobre o resultado da conversa, a consistência de estoque e métricas dependerá da atualização administrativa das situações dos pedidos.

## Goals / Non-Goals

**Goals:**

- Entregar uma arquitetura monolítica Rails modular, adequada ao escopo inicial e evolutiva.
- Manter catálogo, carrinho, pedidos, estoque, manifestações, métricas e relatórios em uma única fonte de verdade.
- Preservar o histórico financeiro do pedido e tornar explícitas as regras de venda, receita, custo e conversão.
- Oferecer uma experiência pública rápida, indexável, responsiva e acessível, com interações incrementais via Hotwire.
- Restringir a administração por autenticação e autorização, protegendo dados pessoais e registrando ações relevantes.
- Isolar integrações e cálculos em serviços de domínio testáveis.

**Non-Goals:**

- Processar pagamentos, frete, rastreamento ou documentos fiscais.
- Automatizar conversas, enviar mensagens por API ou receber confirmações automáticas do WhatsApp.
- Suportar múltiplos vendedores ou um aplicativo móvel nativo.
- Criar uma API pública separada da aplicação web na primeira versão.

## Decisions

### 1. Monólito Rails organizado por áreas de domínio

A aplicação usará Rails MVC com namespaces de controladores `Publico` e `Administracao`, modelos de domínio em português e serviços para operações transacionais ou cálculos complexos. Rotas públicas não exigirão sessão autenticada; rotas administrativas ficarão sob namespace e política de autorização.

Essa opção reduz complexidade operacional e mantém transações de pedido e estoque no mesmo banco. Microserviços foram descartados porque adicionariam consistência distribuída e infraestrutura sem benefício proporcional ao estágio do produto.

### 2. Modelo de dados transacional e histórico imutável do item

As entidades centrais serão `Categoria`, `Produto`, anexos de imagem via Active Storage, `Carrinho`, `ItemCarrinho`, `Pedido`, `ItemPedido`, `HistoricoPedido`, `Avaliacao`, `Manifestacao`, `UsuarioAdministrativo` e `RegistroAuditoria`.

`ItemPedido` copiará no checkout o nome/SKU, preço unitário e custo unitário vigentes. Totais serão armazenados em centavos inteiros e recalculados no servidor. O pedido terá número público único não sequencial e dados mínimos de contato. Guardar apenas referências ao cadastro foi descartado porque alterações posteriores destruiriam a fidelidade histórica.

### 3. Reserva e baixa de estoque no ciclo do pedido

O checkout validará o estoque em transação com bloqueio das linhas de produto e criará o pedido como `iniciado`, sem baixar estoque. A baixa ocorrerá uma única vez ao passar para `confirmado`; `concluido` mantém a baixa, e o cancelamento de um pedido já confirmado ou concluído repõe as quantidades uma única vez. O histórico registrará situação anterior, nova situação, responsável e horário.

Reservar estoque indefinidamente ao abrir o WhatsApp foi descartado porque abandonos bloqueariam produtos sem confirmação. A contrapartida é a possibilidade de indisponibilidade entre início e confirmação, tratada pela equipe no atendimento.

### 4. Carrinho anônimo identificado por token seguro

O carrinho será persistido no banco e associado a um token aleatório armazenado em cookie assinado, com expiração deslizante. Quantidades serão sempre validadas no servidor; preço exibido no carrinho é informativo e será revalidado no checkout. O carrinho será esvaziado após a criação bem-sucedida do pedido.

Armazenar todo o carrinho no navegador foi descartado por dificultar validações, expiração e evolução do fluxo.

### 5. Checkout como operação idempotente e integração por URL

Um serviço transacional validará contato, itens ativos, preços e disponibilidade, criará o pedido e seus itens históricos e retornará uma URL `https://wa.me/<numero>?text=<mensagem-codificada>`. Um token de idempotência por tentativa impedirá pedidos duplicados causados por duplo clique ou reenvio. A mensagem conterá número do pedido, cliente, itens, quantidades, valores e total, sem inserir dados desnecessários.

Uma integração com a API oficial do WhatsApp foi descartada porque automação e confirmação automática estão fora do escopo.

### 6. Métricas financeiras com definições centralizadas

Consultas e objetos de relatório compartilharão as seguintes definições:

- venda: pedido em `confirmado` ou `concluido`;
- receita bruta: soma do preço histórico multiplicado pela quantidade dos itens de venda;
- custo dos produtos vendidos: soma do custo histórico multiplicado pela quantidade;
- lucro bruto: receita bruta menos custo;
- prejuízo: valor absoluto do lucro bruto quando negativo, caso contrário zero;
- margem bruta: lucro bruto dividido pela receita bruta, sendo zero quando a receita for zero;
- ticket médio: receita bruta dividida pela quantidade de pedidos de venda;
- conversão: pedidos que chegaram a `confirmado` ou `concluido` divididos pelos pedidos iniciados no período.

Os filtros usarão a data de criação para funil e a data da primeira confirmação para vendas financeiras. Cálculos duplicados em controladores e relatórios foram descartados para evitar divergência.

### 7. Hotwire por padrão e JavaScript apenas para comportamento local

Turbo Frames atualizarão carrinho, filtros, paginação e formulários administrativos; Turbo Streams refletirão mudanças parciais. Stimulus controlará galeria, contadores, confirmação de ações, filtros dependentes e melhorias progressivas. Todos os fluxos essenciais continuarão utilizáveis com HTML enviado pelo servidor.

Uma SPA foi descartada para preservar indexação, reduzir duplicação de estado e aproveitar os padrões do Rails.

### 8. Design system sobre Tabler

Tabler fornecerá estrutura e componentes, encapsulados em parciais e helpers locais para evitar acoplamento direto em cada tela. Tokens CSS definirão `--cor-fundo: #000000`, `--cor-primaria: #A020F0`, `--cor-destaque: #FF8C00`, `--cor-texto: #FFFFFF`, escalas de espaçamento, raios, sombras neon e estados de foco. Space Grotesk será carregada localmente ou com fallback seguro para evitar que a interface dependa de rede em tempo de execução.

Contraste, foco visível, navegação por teclado, textos alternativos e preferência por redução de movimento serão critérios de aceite. Alterar diretamente o tema do fornecedor em cada página foi descartado por dificultar manutenção.

### 9. Segurança, privacidade e auditoria em camadas

A autenticação administrativa usará mecanismo consolidado do ecossistema Rails; a autorização será baseada em perfis e políticas. CSRF permanecerá ativo, parâmetros serão permitidos explicitamente, conteúdo público será sanitizado e formulários públicos terão limitação por IP e impressão digital não invasiva. Dados pessoais não aparecerão em logs e terão acesso administrativo restrito.

Mudanças de preço, custo, estoque, disponibilidade, perfis e situações de pedido gerarão auditoria com ator, ação, alvo, antes/depois permitido e horário. A política de retenção será configurável e executada por job, preservando agregados anonimizados quando permitido.

### 10. Processamento síncrono no núcleo e jobs para trabalho pesado

Criação de pedido, transição de situação e movimentação de estoque serão síncronas e transacionais. Geração de relatórios grandes, limpeza por retenção e processamento de imagens poderão usar Active Job, com adaptador persistente suportado pelo Rails. O usuário verá progresso ou receberá o arquivo quando pronto.

Executar mudanças críticas de estoque em background foi descartado porque introduziria uma janela de inconsistência.

### 11. Estratégia de testes

Testes de modelo e serviço cobrirão validações, transições, estoque, snapshot financeiro e fórmulas. Testes de request/system cobrirão catálogo, carrinho, checkout, URL do WhatsApp, autenticação, políticas e moderação. Testes específicos validarão inflections e nomes de tabelas/rotas. Exportações terão testes de conteúdo, filtros e metadados.

## Risks / Trade-offs

- [A confirmação manual no WhatsApp pode deixar pedidos desatualizados] → destacar pedidos antigos no painel, registrar responsáveis e criar alertas operacionais.
- [Dois atendimentos podem disputar o último item] → bloquear o produto e revalidar estoque na confirmação; informar indisponibilidade sem permitir estoque negativo.
- [Inflections globais em português podem alterar convenções inesperadamente] → declarar somente regras necessárias, não usar `inflect.clear` e cobrir pluralização, tabelas, rotas e associações com testes.
- [Relatórios amplos podem sobrecarregar o banco] → usar índices, agregações SQL, paginação e geração assíncrona acima de um limite mensurável.
- [Dependência visual do Tabler pode dificultar atualizações] → concentrar adaptações em componentes e tokens próprios e fixar versões.
- [PDF pode divergir da tela] → compartilhar objetos de consulta e apresentação entre painel, CSV e PDF, testando totais e filtros.
- [Retenção de dados pode conflitar com rastreabilidade financeira] → documentar base legal e prazos por categoria de dado e anonimizar apenas o que não precisa ser preservado.
- [Cookie perdido separa o visitante do carrinho] → aceitar a limitação no escopo anônimo e manter o token sem dados pessoais.

## Migration Plan

1. Inicializar a aplicação e a infraestrutura MySQL, configurar ambiente, locale, fuso e inflections com testes.
2. Criar migrations e seeds mínimos para administração, catálogo e perfis de acesso.
3. Entregar catálogo e administração de produtos antes de habilitar carrinho e checkout.
4. Implantar carrinho, pedidos, estoque e WhatsApp inicialmente em ambiente de homologação com número configurável.
5. Validar fórmulas e relatórios contra um conjunto conhecido de pedidos antes da abertura pública.
6. Habilitar avaliações e manifestações com moderação e limites conservadores.
7. Fazer backup do banco antes de cada implantação e usar migrations reversíveis. Em rollback, desabilitar criação pública de pedidos, manter leitura administrativa e reverter aplicação antes de qualquer migration destrutiva.

## Open Questions

- Qual número de WhatsApp e qual texto institucional devem ser configurados por ambiente?
- Quais perfis administrativos serão necessários além de administrador, atendimento e gestor?
- Qual limiar define estoque baixo por padrão e ele poderá ser personalizado por produto?
- Quais prazos de retenção serão adotados para pedidos, contatos, avaliações, manifestações e auditoria?
- A fonte Space Grotesk será hospedada pela aplicação ou fornecida por um serviço externo aprovado?
- Qual volume esperado determinará o limite para geração assíncrona de relatórios?
