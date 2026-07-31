## ADDED Requirements

### Requirement: Administração do catálogo
O sistema SHALL permitir que usuários autorizados criem, consultem, alterem e inativem categorias e produtos com nome, SKU único, descrição, características, categoria, preço, custo, estoque, publicação, disponibilidade e destaque.

#### Scenario: Produto válido
- **WHEN** um usuário autorizado salva um produto com todos os campos obrigatórios e SKU único
- **THEN** o sistema persiste o produto e confirma a operação

#### Scenario: Dados financeiros inválidos
- **WHEN** preço ou custo informado é negativo ou não representa um valor monetário válido
- **THEN** o sistema rejeita a alteração e apresenta erros localizados

#### Scenario: Inativação de produto referenciado
- **WHEN** um usuário autorizado remove de operação um produto presente em pedidos históricos
- **THEN** o sistema o inativa para o catálogo sem apagar os itens dos pedidos existentes

### Requirement: Gestão de imagens
O sistema SHALL permitir anexar, ordenar e remover imagens de produto, definir uma imagem principal e exigir texto alternativo para imagens publicadas.

#### Scenario: Reordenação da galeria
- **WHEN** um usuário autorizado altera a ordem das imagens e define a principal
- **THEN** o catálogo público apresenta a galeria na nova ordem com a imagem principal em destaque

#### Scenario: Arquivo inválido
- **WHEN** o usuário envia um arquivo com tipo ou tamanho não permitido
- **THEN** o sistema rejeita o anexo sem substituir as imagens válidas existentes

### Requirement: Controle de estoque
O sistema SHALL manter uma quantidade de estoque não negativa por produto e SHALL registrar cada ajuste administrativo com quantidade anterior, nova quantidade, motivo e responsável.

#### Scenario: Ajuste válido
- **WHEN** um usuário autorizado informa nova quantidade não negativa e motivo
- **THEN** o sistema atualiza o estoque e cria o respectivo registro de auditoria

#### Scenario: Estoque negativo
- **WHEN** uma operação tenta reduzir o estoque abaixo de zero
- **THEN** o sistema rejeita toda a operação e preserva a quantidade anterior

### Requirement: Visibilidade pública
O sistema SHALL considerar comprável somente o produto ativo, publicado, disponível e com estoque positivo.

#### Scenario: Produto deixa de ser publicado
- **WHEN** um administrador desmarca a publicação de um produto
- **THEN** o produto deixa de aparecer em busca, listagens e recomendações públicas

