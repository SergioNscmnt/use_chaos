## ADDED Requirements

### Requirement: Ciclo de situações do pedido
O sistema SHALL controlar pedidos nas situações `iniciado`, `em_atendimento`, `confirmado`, `concluido` e `cancelado`, permitindo somente transições documentadas e autorizadas.

#### Scenario: Atendimento iniciado
- **WHEN** um atendente autorizado move um pedido `iniciado` para `em_atendimento`
- **THEN** o sistema atualiza a situação e registra a transição

#### Scenario: Transição inválida
- **WHEN** um usuário tenta executar uma transição não permitida para a situação atual
- **THEN** o sistema rejeita a operação sem alterar pedido ou estoque

### Requirement: Histórico de alterações
O sistema SHALL registrar em cada mudança a situação anterior, a nova situação, data e horário, usuário responsável e observação opcional.

#### Scenario: Consulta do histórico
- **WHEN** um usuário autorizado abre os detalhes de um pedido alterado
- **THEN** o sistema exibe as transições em ordem cronológica com seus responsáveis

### Requirement: Efeito da confirmação no estoque
O sistema MUST baixar o estoque uma única vez na primeira transição para `confirmado`, SHALL manter a baixa em `concluido` e MUST repor uma única vez as quantidades quando um pedido já baixado for cancelado.

#### Scenario: Confirmação com estoque suficiente
- **WHEN** um pedido ainda não baixado é confirmado e todos os itens têm estoque suficiente
- **THEN** o sistema baixa as quantidades e confirma o pedido na mesma transação

#### Scenario: Confirmação sem estoque
- **WHEN** ao menos um item não tem estoque suficiente no momento da confirmação
- **THEN** o sistema rejeita a transição, não altera nenhum estoque e informa os itens afetados

#### Scenario: Cancelamento após confirmação
- **WHEN** um pedido confirmado é cancelado
- **THEN** o sistema repõe as quantidades uma única vez e registra a reversão

### Requirement: Consulta operacional
O sistema SHALL permitir que usuários autorizados pesquisem pedidos por número ou contato e filtrem por período, situação e responsável.

#### Scenario: Filtro por situação e período
- **WHEN** o usuário seleciona uma situação e intervalo de datas
- **THEN** o sistema lista somente pedidos correspondentes e mantém os filtros visíveis

### Requirement: Venda reconhecida
O sistema SHALL classificar como venda somente pedidos nas situações `confirmado` ou `concluido`.

#### Scenario: Pedido em atendimento
- **WHEN** um pedido está `iniciado` ou `em_atendimento`
- **THEN** o sistema não o inclui em totais financeiros de vendas

