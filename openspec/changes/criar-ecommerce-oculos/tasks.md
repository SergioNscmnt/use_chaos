## 1. Fundação da aplicação

- [x] 1.1 Inicializar a aplicação com Ruby 4.0.1, Rails 8+, MySQL, Hotwire, Turbo Rails e Stimulus, fixando as versões suportadas
- [x] 1.2 Configurar ambientes, credenciais e variáveis para banco, URL pública, número do WhatsApp, fuso e limites operacionais
- [x] 1.3 Configurar `pt-BR`, BRL, formatos locais e `America/Porto_Velho`, com testes de moeda, datas, horários e validações
- [x] 1.4 Implementar inflections explícitas para os termos do domínio sem `inflect.clear` e testar pluralização, singularização, tabelas, rotas e associações
- [x] 1.5 Configurar suíte de testes, análise estática, verificação de segurança e pipeline de integração contínua
- [x] 1.6 Registrar decisões para perfis, estoque baixo, retenção, hospedagem da fonte e limite assíncrono usando padrões configuráveis enquanto valores finais não forem definidos

## 2. Design system e estrutura de interface

- [x] 2.1 Integrar Tabler e Space Grotesk com versões fixadas e fallback local seguro
- [x] 2.2 Criar tokens CSS da paleta, tipografia, espaçamento, raios, sombras neon, foco e estados semânticos
- [x] 2.3 Criar layouts e componentes compartilhados para as áreas pública e administrativa
- [x] 2.4 Implementar navegação responsiva, estados vazios, alertas, formulários e tabelas acessíveis
- [x] 2.5 Adicionar suporte a `prefers-reduced-motion`, navegação por teclado e contraste verificável
- [x] 2.6 Testar os componentes principais em viewports móveis e desktop e com JavaScript desativado
- [x] 2.7 Aplicar máscaras progressivas de moeda brasileira e telefone em formulários e filtros, preservando normalização no servidor e o fluxo sem JavaScript
- [x] 2.8 Adicionar ao menu público responsivo um acesso à autenticação ou ao painel administrativo conforme a sessão atual
- [x] 2.9 Manter o rodapé público após o conteúdo e no fim da viewport em páginas curtas, sem sobreposição em desktop ou celular

## 3. Autenticação, autorização e auditoria

- [x] 3.1 Criar usuários administrativos, perfis e permissões com migrations, validações e seeds mínimos
- [x] 3.2 Implementar autenticação segura, renovação de sessão, logout e bloqueio de usuário inativo
- [x] 3.3 Implementar namespace `Administracao` protegido e políticas de autorização por ação
- [x] 3.4 Criar `RegistroAuditoria` e serviço transacional para registrar alterações administrativas relevantes
- [x] 3.5 Configurar CSRF, parâmetros permitidos, sanitização e filtragem de dados pessoais nos logs
- [x] 3.6 Testar autenticação, acesso negado, matriz de permissões, CSRF e conteúdo da auditoria

## 4. Domínio e gestão do catálogo

- [x] 4.1 Criar migrations de categorias e produtos com valores monetários em centavos, SKU único, estoque não negativo e índices de consulta
- [x] 4.2 Implementar modelos, associações, validações, scopes de publicação e regra central de produto comprável
- [x] 4.3 Configurar Active Storage e metadados para galeria ordenada, imagem principal e texto alternativo
- [x] 4.4 Implementar CRUD administrativo de categorias e produtos com inativação em vez de exclusão destrutiva
- [x] 4.5 Implementar upload, validação, ordenação e remoção de imagens no fluxo administrativo
- [x] 4.6 Implementar ajuste de estoque com motivo, bloqueio de valor negativo e auditoria de antes/depois
- [x] 4.7 Testar validações, scopes, imagens, inativação, ajustes concorrentes e auditoria do catálogo

## 5. Catálogo público

- [x] 5.1 Criar rotas e controladores públicos para início, categorias, listagem e detalhes com URLs canônicas
- [x] 5.2 Implementar busca textual, filtros de categoria, preço e disponibilidade, ordenação e paginação preservando parâmetros
- [x] 5.3 Construir página inicial com destaques, categorias e lançamentos elegíveis
- [x] 5.4 Construir página de produto com galeria, características, disponibilidade, avaliações aprovadas e ação de compra
- [x] 5.5 Implementar produtos relacionados sem duplicar o produto atual nem exibir itens não publicados
- [x] 5.6 Adicionar metadados indexáveis, respostas de não encontrado e estados para sem estoque, indisponível e inativo
- [x] 5.7 Cobrir catálogo, filtros, SEO básico, responsividade e fluxos sem JavaScript com testes de request e system

## 6. Carrinho de compras

- [x] 6.1 Criar migrations e modelos de carrinho e itens com token único, expiração e restrições de quantidade
- [x] 6.2 Implementar resolução do carrinho por cookie assinado, renovação de expiração e tratamento seguro de token inválido
- [x] 6.3 Implementar serviços para adicionar, alterar e remover itens com validação de elegibilidade e estoque
- [x] 6.4 Criar página e resumo do carrinho com subtotais e total informativo calculados no servidor
- [x] 6.5 Adicionar Turbo Frames e Turbo Streams para atualizações parciais, mantendo respostas HTML completas
- [x] 6.6 Sinalizar e bloquear checkout quando um item existente se tornar inelegível
- [x] 6.7 Testar persistência, adulteração do cookie, limites de quantidade, mudanças de estoque e melhoria progressiva

## 7. Checkout e integração com WhatsApp

- [x] 7.1 Criar migrations de pedidos e itens com número público único, chave de idempotência, situações, contato e snapshots históricos
- [x] 7.2 Implementar modelos e validações de pedido, item, totais em centavos e dados mínimos de cliente
- [x] 7.3 Criar serviço transacional de checkout que bloqueie produtos e revalide publicação, disponibilidade, preço e estoque
- [x] 7.4 Implementar criação idempotente do pedido `iniciado`, snapshots dos itens e limpeza do carrinho somente após commit
- [x] 7.5 Criar gerador da mensagem em português e da URL `wa.me` com codificação correta e número configurável
- [x] 7.6 Construir formulário público de checkout, aviso de privacidade, tratamento de divergências e ação de abertura do WhatsApp
- [x] 7.7 Testar dados inválidos, mudança de preço, falta de estoque, rollback, duplo envio, snapshots e caracteres especiais na URL

## 8. Gestão de pedidos e movimentação de estoque

- [x] 8.1 Criar modelo de histórico e definir a matriz permitida de transições entre situações
- [x] 8.2 Implementar serviço transacional de transição com responsável, observação e registro cronológico
- [x] 8.3 Implementar baixa única de estoque na primeira confirmação com bloqueio de linhas e rollback integral em insuficiência
- [x] 8.4 Implementar manutenção da baixa na conclusão e reposição única ao cancelar pedido que já movimentou estoque
- [x] 8.5 Criar listagem administrativa com busca por número ou contato e filtros por período, situação e responsável
- [x] 8.6 Criar detalhes do pedido com snapshots, totais, contato protegido, histórico e ações permitidas
- [x] 8.7 Destacar pedidos iniciados ou em atendimento acima do prazo operacional configurado
- [x] 8.8 Testar matriz de transição, concorrência pelo último item, idempotência de estoque, cancelamento e permissões

## 9. Avaliações de produtos

- [x] 9.1 Criar migration e modelo de avaliação com nota, comentário, situação de moderação e metadados do responsável
- [x] 9.2 Implementar formulário público com validação, sanitização, confirmação e limitação de requisições
- [x] 9.3 Criar fila administrativa para aprovar, rejeitar e ocultar avaliações com auditoria
- [x] 9.4 Implementar consulta de média e quantidade usando somente avaliações aprovadas
- [x] 9.5 Integrar avaliações aprovadas e estado sem avaliações à página do produto
- [x] 9.6 Testar escala de notas, moderação, sanitização, rate limiting e recálculo dos consolidados

## 10. Sugestões e feedbacks

- [x] 10.1 Criar migration e modelo de manifestação com tipo, mensagem, contato opcional, situação, responsável e histórico
- [x] 10.2 Implementar formulário público, confirmação de envio, sanitização e limites contra abuso
- [x] 10.3 Criar gestão administrativa com filtros, atribuição, observações internas e mudança de situação
- [x] 10.4 Restringir dados de contato conforme permissão e ocultá-los de logs e respostas não autorizadas
- [x] 10.5 Testar envio anônimo, validações, conteúdo hostil, rate limiting, tratamento e privacidade

## 11. Métricas e painel gerencial

- [x] 11.1 Criar objetos de filtro compartilhados para período, categoria, produto e situação
- [x] 11.2 Implementar consulta financeira baseada em snapshots e pedidos confirmados ou concluídos
- [x] 11.3 Implementar receita, custo, lucro, prejuízo, margem e ticket médio, incluindo divisões por zero
- [x] 11.4 Implementar contagem do funil e conversão por data de início, usando a primeira confirmação para métricas de venda
- [x] 11.5 Implementar rankings de produtos, categorias, avaliações aprovadas e estoque baixo
- [x] 11.6 Construir painel administrativo com indicadores, gráficos, filtros persistentes e estados vazios
- [x] 11.7 Adicionar índices e revisar planos das consultas de maior volume
- [x] 11.8 Testar todas as fórmulas e filtros contra conjuntos conhecidos de pedidos lucrativos, deficitários e vazios

## 12. Relatórios gerenciais

- [x] 12.1 Criar objeto de apresentação compartilhado entre painel, CSV e PDF para impedir divergência de regras
- [x] 12.2 Implementar relatório consultável com linhas, totais, filtros aplicados e data de geração
- [x] 12.3 Implementar exportação CSV localizada com codificação, cabeçalhos, metadados e totais
- [x] 12.4 Implementar PDF paginado e imprimível com filtros, fuso, indicadores e totais
- [x] 12.5 Implementar geração assíncrona acima do limite configurado, estado de progresso e armazenamento protegido do arquivo
- [x] 12.6 Aplicar autorização por perfil e registrar auditoria de formato, filtros, solicitante e horário
- [x] 12.7 Testar paridade entre tela, CSV e PDF, arquivos vazios, caracteres portugueses e isolamento entre usuários

## 13. Privacidade, retenção e operação

- [x] 13.1 Documentar bases de tratamento, dados coletados, acesso e prazos configurados para pedidos, avaliações, manifestações e auditoria
- [x] 13.2 Implementar job de retenção que elimine ou anonimize somente registros elegíveis e registre sua execução
- [x] 13.3 Configurar limites de requisição por formulário e respostas públicas que não revelem o mecanismo de proteção
- [x] 13.4 Criar seeds e dados de demonstração sem informações pessoais reais para categorias, produtos e perfis
- [x] 13.5 Documentar backup, restauração, rollback, configuração do WhatsApp e responsabilidade operacional pelas situações
- [x] 13.6 Testar retenção, anonimização, filtros de log e acesso mínimo a dados pessoais

## 14. Validação integrada e entrega

- [x] 14.1 Executar fluxo de ponta a ponta do catálogo ao WhatsApp e da confirmação administrativa à baixa de estoque
- [x] 14.2 Validar que pedidos iniciados, cancelados, confirmados e concluídos produzem métricas e relatórios coerentes
- [x] 14.3 Executar a suíte completa, análise estática, verificação de segurança e testes de concorrência críticos
- [x] 14.4 Realizar auditoria de acessibilidade por teclado, contraste, rótulos, redução de movimento e viewports suportadas
- [x] 14.5 Verificar desempenho das páginas públicas e consultas gerenciais com volume representativo
- [x] 14.6 Preparar checklist de implantação, homologar o número do WhatsApp e registrar os valores finais das questões em aberto
