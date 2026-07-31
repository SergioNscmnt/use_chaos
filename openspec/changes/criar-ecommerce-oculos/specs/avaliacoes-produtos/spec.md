## ADDED Requirements

### Requirement: Envio público de avaliação
O sistema SHALL permitir que um visitante envie para produto publicado uma avaliação contendo nota na escala configurada e comentário dentro dos limites definidos, mantendo-a pendente até moderação.

#### Scenario: Avaliação válida
- **WHEN** o visitante envia nota e comentário válidos
- **THEN** o sistema registra a avaliação como pendente e confirma o recebimento sem publicá-la

#### Scenario: Conteúdo inválido
- **WHEN** a nota está fora da escala ou o comentário viola tamanho ou formato permitido
- **THEN** o sistema não registra a avaliação e apresenta erros localizados

### Requirement: Moderação
O sistema SHALL permitir que usuário autorizado aprove, rejeite ou oculte uma avaliação, registrando responsável, horário e decisão.

#### Scenario: Avaliação aprovada
- **WHEN** um moderador aprova uma avaliação pendente
- **THEN** o sistema a torna pública no produto e atualiza os dados consolidados

#### Scenario: Avaliação rejeitada
- **WHEN** um moderador rejeita uma avaliação
- **THEN** o sistema mantém o registro restrito à administração e não expõe seu conteúdo no catálogo

### Requirement: Média de avaliações
O sistema MUST calcular quantidade e média de notas usando exclusivamente avaliações aprovadas e publicáveis.

#### Scenario: Existem avaliações em diferentes situações
- **WHEN** um produto possui avaliações aprovadas, pendentes e rejeitadas
- **THEN** o sistema calcula e exibe a média somente a partir das aprovadas

#### Scenario: Nenhuma avaliação aprovada
- **WHEN** um produto não possui avaliação aprovada
- **THEN** o sistema apresenta estado sem avaliações em vez de uma média enganosa

### Requirement: Proteção contra abuso
O sistema SHALL limitar a frequência de envios públicos e sanitizar comentários antes da exibição.

#### Scenario: Limite excedido
- **WHEN** uma origem ultrapassa o limite configurado de avaliações
- **THEN** o sistema rejeita temporariamente novos envios sem revelar detalhes internos do mecanismo

