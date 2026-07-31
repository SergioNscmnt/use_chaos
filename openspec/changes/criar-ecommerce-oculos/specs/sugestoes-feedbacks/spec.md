## ADDED Requirements

### Requirement: Recebimento de manifestações
O sistema SHALL oferecer formulário público para sugestão ou feedback com categoria, mensagem e contato opcional, coletando somente os dados necessários e confirmando o recebimento.

#### Scenario: Sugestão válida
- **WHEN** o visitante envia uma sugestão com os campos obrigatórios válidos
- **THEN** o sistema registra a manifestação como nova e apresenta uma confirmação sem expor dados pessoais

#### Scenario: Feedback com contato opcional
- **WHEN** o visitante envia feedback sem contato e a categoria não exige retorno
- **THEN** o sistema aceita a manifestação e a identifica como anônima

### Requirement: Prevenção de abuso
O sistema SHALL validar e sanitizar as entradas, limitar requisições e usar mecanismo não invasivo adicional quando necessário para conter automação abusiva.

#### Scenario: Conteúdo potencialmente executável
- **WHEN** uma manifestação contém marcação ou script não permitido
- **THEN** o sistema impede sua execução e armazena ou rejeita o conteúdo conforme a política de sanitização

#### Scenario: Frequência excessiva
- **WHEN** uma origem excede o limite configurado de submissões
- **THEN** o sistema recusa temporariamente o envio e retorna uma mensagem pública genérica

### Requirement: Tratamento administrativo
O sistema SHALL permitir que usuários autorizados filtrem manifestações por tipo, situação e período, atribuam responsável, registrem observações internas e alterem a situação.

#### Scenario: Manifestação tratada
- **WHEN** o responsável marca uma manifestação como tratada e adiciona uma observação
- **THEN** o sistema salva a situação, a observação, o responsável e o horário no histórico administrativo

### Requirement: Privacidade das manifestações
O sistema MUST restringir dados de contato à administração autorizada e SHALL aplicar a política configurada de retenção.

#### Scenario: Usuário sem permissão
- **WHEN** um usuário sem permissão tenta consultar o contato de uma manifestação
- **THEN** o sistema nega o acesso e não inclui o dado na resposta

