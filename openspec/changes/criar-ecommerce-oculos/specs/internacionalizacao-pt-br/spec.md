## ADDED Requirements

### Requirement: Locale e interface em português do Brasil
O sistema SHALL usar `pt-BR` como locale padrão e SHALL apresentar textos, mensagens de validação e comunicação com o WhatsApp em português do Brasil.

#### Scenario: Erro de validação
- **WHEN** um usuário envia um formulário com campo obrigatório vazio
- **THEN** o sistema apresenta a mensagem de validação correspondente em português do Brasil

#### Scenario: Chave de tradução ausente
- **WHEN** uma tela de produção solicita uma chave de tradução inexistente
- **THEN** o monitoramento registra a falha e a interface não exibe a chave técnica como conteúdo final

### Requirement: Formatos locais
O sistema SHALL formatar valores monetários em BRL, números, datas e horários segundo as convenções de `pt-BR`.

#### Scenario: Exibição de valor
- **WHEN** o sistema apresenta o valor de 123456 centavos
- **THEN** a interface o formata como moeda brasileira sem usar ponto flutuante no cálculo

#### Scenario: Exibição de data
- **WHEN** uma data ou horário é apresentado ao usuário
- **THEN** o sistema usa formato localizado e o fuso configurado para a aplicação

### Requirement: Fuso horário configurável
O sistema SHALL armazenar instantes em UTC e SHALL exibi-los no fuso configurável da aplicação, inicialmente `America/Porto_Velho`.

#### Scenario: Horário persistido
- **WHEN** um evento ocorre e é consultado na interface
- **THEN** o banco preserva o instante e a interface o converte para o fuso configurado

### Requirement: Nomenclatura do domínio
O código da aplicação SHALL usar nomes em português sem acentos para classes, tabelas, atributos, métodos, serviços, rotas e testes pertencentes ao domínio.

#### Scenario: Nova entidade de domínio
- **WHEN** uma entidade do negócio é adicionada
- **THEN** seus identificadores de código seguem a nomenclatura em português sem caracteres acentuados

### Requirement: Inflections do Active Support
O sistema MUST declarar e testar regras explícitas para `produto/produtos`, `categoria/categorias`, `avaliacao/avaliacoes`, `sugestao/sugestoes` e o termo incontável `oculos`, sem limpar indiscriminadamente as regras padrão.

#### Scenario: Pluralizações do domínio
- **WHEN** o Active Support pluraliza ou singulariza os termos configurados
- **THEN** o resultado corresponde aos pares de domínio esperados e `oculos` permanece invariável

#### Scenario: Convenções Rails
- **WHEN** modelos e associações dos termos configurados resolvem tabelas e classes
- **THEN** os nomes resultantes correspondem ao esquema e às constantes esperadas

