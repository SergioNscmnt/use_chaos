## ADDED Requirements

### Requirement: Dados mínimos do checkout
O sistema SHALL coletar e validar somente nome e meio de contato necessários para identificar o cliente e continuar o atendimento, informando a finalidade do tratamento antes da conclusão.

#### Scenario: Dados válidos
- **WHEN** o visitante fornece nome e contato válidos e aceita a informação de privacidade aplicável
- **THEN** o sistema permite prosseguir para a validação do pedido

#### Scenario: Dados inválidos
- **WHEN** nome ou contato obrigatório está ausente ou inválido
- **THEN** o sistema não cria o pedido e apresenta mensagens localizadas junto aos campos correspondentes

### Requirement: Validação transacional do pedido
O sistema MUST revalidar no servidor atividade, disponibilidade, preço e estoque de todos os itens imediatamente antes de criar o pedido.

#### Scenario: Carrinho válido
- **WHEN** todos os itens continuam elegíveis, com preço vigente e estoque suficiente
- **THEN** o sistema cria o pedido e seus itens em uma única transação

#### Scenario: Preço ou estoque mudou
- **WHEN** ao menos um item teve preço alterado ou estoque reduzido desde a visualização do carrinho
- **THEN** o sistema não conclui o checkout, apresenta as divergências e exige confirmação do carrinho atualizado

### Requirement: Pedido interno e snapshot histórico
O sistema SHALL criar antes do redirecionamento um pedido com número público único, situação `iniciado` e itens contendo nome ou SKU, quantidade, preço unitário e custo unitário vigentes no momento da criação.

#### Scenario: Cadastro do produto muda depois
- **WHEN** nome, preço ou custo do produto é alterado após a criação do pedido
- **THEN** os valores e a descrição histórica dos itens do pedido permanecem inalterados

#### Scenario: Duplo envio
- **WHEN** a mesma tentativa de checkout é enviada novamente com a mesma chave de idempotência
- **THEN** o sistema retorna o pedido já criado e não duplica o pedido

### Requirement: Link e mensagem do WhatsApp
O sistema SHALL gerar uma URL compatível com dispositivos móveis e desktop contendo mensagem em português com número do pedido, cliente, itens, quantidades, valores unitários e total.

#### Scenario: Pedido criado com sucesso
- **WHEN** o pedido interno é persistido
- **THEN** o sistema oferece ou abre a URL configurada do WhatsApp com a mensagem corretamente codificada

#### Scenario: Caracteres especiais na mensagem
- **WHEN** nomes contêm espaços, acentos ou símbolos permitidos
- **THEN** a URL gerada preserva o conteúdo após decodificação e continua válida

### Requirement: Finalização do carrinho
O sistema SHALL esvaziar o carrinho somente depois de o pedido ser criado com sucesso.

#### Scenario: Falha ao criar pedido
- **WHEN** ocorre uma falha de validação ou persistência
- **THEN** o sistema mantém os itens do carrinho para correção e nova tentativa

#### Scenario: Pedido criado
- **WHEN** a transação de criação do pedido é confirmada
- **THEN** o sistema remove os itens do carrinho associado

