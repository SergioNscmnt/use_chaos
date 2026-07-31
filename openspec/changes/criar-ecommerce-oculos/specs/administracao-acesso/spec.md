## ADDED Requirements

### Requirement: Autenticação administrativa
O sistema MUST exigir autenticação para toda rota administrativa, proteger a sessão contra fixação e encerrar ou renovar sessões conforme política configurada.

#### Scenario: Visitante tenta acessar a administração
- **WHEN** uma pessoa não autenticada solicita uma rota administrativa
- **THEN** o sistema não expõe o conteúdo e direciona para autenticação

#### Scenario: Credenciais válidas
- **WHEN** um usuário interno ativo fornece credenciais válidas
- **THEN** o sistema cria uma nova sessão segura e permite acesso às funções autorizadas

#### Scenario: Usuário inativo
- **WHEN** um usuário interno inativo fornece credenciais anteriormente válidas
- **THEN** o sistema nega a autenticação e não cria sessão

### Requirement: Autorização por perfil
O sistema SHALL associar usuários internos a perfis e SHALL verificar permissão para cada ação administrativa sensível no servidor.

#### Scenario: Operação permitida
- **WHEN** um usuário autenticado possui a permissão requerida
- **THEN** o sistema executa a operação e retorna somente os dados permitidos

#### Scenario: Operação não permitida
- **WHEN** um usuário autenticado não possui a permissão requerida
- **THEN** o sistema nega a operação sem efetuar alterações

### Requirement: Proteções de requisição e entrada
O sistema MUST manter proteção CSRF nas operações mutáveis, permitir explicitamente os parâmetros aceitos e sanitizar conteúdo exibido.

#### Scenario: Token CSRF ausente
- **WHEN** uma requisição administrativa mutável não contém token CSRF válido
- **THEN** o sistema rejeita a requisição sem persistir alterações

### Requirement: Auditoria administrativa
O sistema SHALL registrar ator, ação, alvo, horário e alterações permitidas para mudanças relevantes em produtos, preços, custos, estoque, disponibilidade, pedidos, avaliações, manifestações, usuários e perfis.

#### Scenario: Preço alterado
- **WHEN** um usuário autorizado modifica o preço de um produto
- **THEN** o sistema registra usuário, produto, valor anterior, novo valor e horário

#### Scenario: Falha de persistência
- **WHEN** uma alteração administrativa falha e é revertida
- **THEN** o sistema não cria um registro que indique falsamente que a mudança foi concluída

### Requirement: Proteção e retenção de dados pessoais
O sistema MUST limitar dados pessoais a perfis e telas necessários, MUST evitar seu registro em logs e SHALL executar política documentada de retenção e descarte.

#### Scenario: Prazo de retenção atingido
- **WHEN** um registro elegível ultrapassa seu prazo configurado e não existe impedimento legal
- **THEN** o sistema elimina ou anonimiza os dados pessoais conforme a política e registra a execução

