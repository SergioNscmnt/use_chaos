# Criar e-commerce de óculos com catálogo público e checkout via WhatsApp

**Change ID:** `criar-ecommerce-oculos`

## Why

É necessário criar uma plataforma própria para comercialização de óculos de sol, esportivos para corrida e modelos casuais, oferecendo uma experiência pública de catálogo alinhada à identidade visual da marca e uma área administrativa capaz de controlar produtos, pedidos, estoque, avaliações e relacionamento com os clientes.

Além da exposição dos produtos, o negócio precisa registrar o funil iniciado pelo catálogo e concluído pelo WhatsApp, permitindo que a equipe confirme o resultado de cada atendimento. Esse registro é indispensável para gerar indicadores confiáveis de vendas, receita, custos, lucro ou prejuízo, desempenho dos produtos e satisfação dos usuários, sem depender de controles paralelos.

## What Changes

- Criar uma aplicação web monolítica com Ruby `4.0.1`, Rails `8+`, MySQL, Hotwire, Turbo Rails e Stimulus.
- Configurar a aplicação para português do Brasil:
  - idioma padrão `pt-BR`;
  - moeda em real brasileiro (`BRL`);
  - datas, horários, números e mensagens de validação localizados;
  - fuso horário configurável, inicialmente `America/Porto_Velho`;
  - interface integralmente escrita em português.
- Adotar nomes de domínio, classes, tabelas, atributos, métodos, serviços, rotas e testes em português, sem acentos nos identificadores de código.
- Configurar e testar as inflections do Active Support para o português, tomando como referência o repositório indicado, sem copiar regras incompatíveis indiscriminadamente e sem utilizar `inflect.clear` sem validação. Incluir regras explícitas e testes para termos do domínio, como `produto/produtos`, `categoria/categorias`, `avaliacao/avaliacoes`, `sugestao/sugestoes` e o termo incontável `oculos`.
- Criar um catálogo público, responsivo e indexável, sem exigir autenticação, com:
  - página inicial com destaques, categorias e lançamentos;
  - categorias de óculos de sol, corrida e casuais;
  - listagem com busca, ordenação e filtros;
  - página de detalhes com galeria, preço, descrição, características, disponibilidade e avaliações;
  - produtos relacionados e produtos em destaque;
  - estados adequados para produto indisponível, sem estoque ou inativo.
- Implementar carrinho persistente para visitantes, permitindo incluir, alterar quantidade e remover itens antes do checkout.
- Implementar checkout via WhatsApp:
  - coletar somente os dados necessários para identificação e contato;
  - validar disponibilidade e preço antes da conclusão;
  - criar um pedido interno com número único e situação inicial antes do redirecionamento;
  - montar uma mensagem em português com cliente, itens, quantidades, valores e número do pedido;
  - abrir o WhatsApp por link compatível com dispositivos móveis e desktop;
  - permitir que a administração atualize o pedido entre situações como iniciado, em atendimento, confirmado, concluído e cancelado;
  - considerar como venda, para métricas financeiras, somente pedidos confirmados ou concluídos, conforme regra documentada na especificação.
- Criar uma área administrativa autenticada e não pública para:
  - gerenciar produtos, categorias, imagens, preços, custos, estoque, destaques e disponibilidade;
  - consultar e atualizar pedidos e seus históricos;
  - moderar avaliações, sugestões e feedbacks;
  - consultar painéis, métricas e relatórios;
  - administrar usuários internos e seus níveis de acesso.
- Manter histórico dos valores relevantes do item no momento do pedido, evitando que alterações futuras no cadastro do produto modifiquem pedidos antigos.
- Permitir avaliações de produtos com nota e comentário, sujeitas a validação e moderação, e calcular a avaliação média apenas com registros aprovados.
- Disponibilizar um espaço público para sugestões e feedbacks, com confirmação de envio, prevenção de abuso e tratamento administrativo.
- Criar painel gerencial com filtros por período, categoria, produto e situação do pedido, apresentando pelo menos:
  - quantidade e valor das vendas;
  - receita bruta;
  - custo dos produtos vendidos;
  - lucro bruto e margem;
  - prejuízo quando os custos superarem a receita;
  - ticket médio;
  - pedidos iniciados, confirmados, concluídos e cancelados;
  - taxa de conversão dos pedidos iniciados no checkout;
  - produtos e categorias mais vendidos;
  - produtos mais bem avaliados;
  - produtos com estoque baixo.
- Permitir a emissão e exportação de relatórios gerenciais em formatos adequados para impressão e análise, incluindo PDF e CSV, com indicação dos filtros aplicados e da data de geração.
- Construir a interface com os componentes e padrões do Tabler, aplicando uma camada visual própria definida no futuro `design.md`:
  - preto `#000000`;
  - roxo `#A020F0`;
  - laranja `#FF8C00`;
  - branco `#FFFFFF`;
  - tipografia Space Grotesk;
  - estética futurista com bordas luminosas e detalhes neon;
  - responsividade, contraste, foco visível e navegação por teclado.
- Usar Turbo Frames e Turbo Streams para interações parciais, e controllers Stimulus para comportamentos do cliente que não possam ser resolvidos apenas com HTML e Turbo.
- Implementar controles mínimos de segurança e privacidade:
  - autenticação e autorização da área administrativa;
  - proteção CSRF;
  - validação e sanitização de entradas;
  - limitação de requisições em formulários públicos;
  - proteção dos dados pessoais coletados;
  - registro de alterações administrativas relevantes;
  - política de retenção dos dados de pedidos e feedbacks.
- Incluir testes automatizados para regras de negócio, permissões, catálogo, carrinho, criação do pedido, link do WhatsApp, cálculos financeiros, relatórios, avaliações e inflections.

Ficam fora do escopo inicial:

- pagamento eletrônico dentro da aplicação;
- integração automática com transportadoras, cálculo de frete ou rastreamento;
- marketplace com múltiplos vendedores;
- aplicativo móvel nativo;
- automação da conversa ou confirmação automática pelo WhatsApp;
- emissão fiscal.

## Capabilities

### New Capabilities

- `catalogo-publico`: navegação pública, busca, filtros, categorias, detalhes, disponibilidade e destaques de produtos.
- `carrinho-compras`: manutenção dos itens e quantidades escolhidos pelo visitante até o checkout.
- `checkout-whatsapp`: criação do pedido interno e abertura do WhatsApp com mensagem estruturada.
- `gestao-produtos`: administração de produtos, categorias, imagens, preços, custos, estoque e disponibilidade.
- `gestao-pedidos`: acompanhamento do ciclo de atendimento, confirmação, conclusão e cancelamento dos pedidos.
- `avaliacoes-produtos`: recebimento, moderação, publicação e consolidação das notas dos produtos.
- `sugestoes-feedbacks`: recebimento e tratamento administrativo das manifestações dos usuários.
- `metricas-vendas`: consolidação de vendas, receita, custos, lucro, prejuízo, margem, conversão e ticket médio.
- `relatorios-gerenciais`: consulta filtrada e exportação de relatórios em PDF e CSV.
- `administracao-acesso`: autenticação, autorização por perfil e rastreabilidade das ações administrativas.
- `internacionalizacao-pt-br`: textos, formatos locais, nomenclatura de domínio e inflections em português.
- `identidade-visual`: aplicação do Tabler com tema futurista, paleta neon e tipografia Space Grotesk.

### Modified Capabilities

- Nenhuma. Trata-se da proposta inicial de uma aplicação nova.

## Impact

- **Aplicação:** criação integral do projeto Rails, das interfaces pública e administrativa e dos fluxos Hotwire.
- **Banco de dados:** criação do esquema MySQL para usuários administrativos, categorias, produtos, mídias, estoque, carrinhos, pedidos, itens de pedido, históricos, avaliações, sugestões, feedbacks e registros de auditoria.
- **Integrações externas:** abertura do WhatsApp por URL com mensagem pré-preenchida; não haverá integração com API paga ou automação de mensagens na primeira versão.
- **Dependências:** integração do Tabler e da Space Grotesk, além de bibliotecas estritamente necessárias para autenticação, autorização, upload de imagens, paginação, geração de PDF/CSV, gráficos e testes.
- **Relatórios e métricas:** os cálculos dependerão do custo histórico dos itens e da situação do pedido; as definições de receita, custo, lucro, prejuízo, margem e conversão deverão ser formalizadas nas specs.
- **Privacidade:** dados de contato e histórico de pedidos exigirão consentimento ou base legal adequada, acesso restrito, retenção definida e tratamento compatível com a LGPD.
- **Operação:** a equipe administrativa será responsável por atualizar a situação dos pedidos iniciados no WhatsApp para que estoque, vendas e indicadores permaneçam confiáveis.
- **Design:** o `design.md` deverá detalhar tokens de cor, tipografia, componentes do Tabler, estados interativos, responsividade e acessibilidade, preservando a identidade visual definida nesta proposta.
- **Compatibilidade linguística:** as regras de inflection deverão ser cobertas por testes, pois alterações globais no Active Support podem afetar nomes de tabelas, rotas e associações.
