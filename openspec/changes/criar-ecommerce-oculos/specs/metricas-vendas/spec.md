## ADDED Requirements

### Requirement: Base das métricas financeiras
O sistema MUST considerar como vendas somente pedidos `confirmado` ou `concluido` e MUST usar o preço e o custo históricos dos itens desses pedidos.

#### Scenario: Conjunto misto de pedidos
- **WHEN** o período contém pedidos iniciados, em atendimento, confirmados, concluídos e cancelados
- **THEN** receita e custo incluem apenas itens de pedidos confirmados ou concluídos

#### Scenario: Produto teve valores alterados
- **WHEN** preço ou custo atual do produto difere do snapshot do item vendido
- **THEN** o sistema usa os valores históricos do item nas métricas

### Requirement: Fórmulas financeiras
O sistema SHALL calcular receita bruta como soma de preço histórico vezes quantidade, custo dos produtos vendidos como soma de custo histórico vezes quantidade, lucro bruto como receita menos custo, prejuízo como o valor absoluto do lucro negativo, margem como lucro dividido pela receita e ticket médio como receita dividida pela quantidade de vendas.

#### Scenario: Operação lucrativa
- **WHEN** a receita do filtro é maior que o custo
- **THEN** o sistema apresenta lucro positivo, prejuízo zero e margem correspondente

#### Scenario: Operação com prejuízo
- **WHEN** o custo do filtro é maior que a receita
- **THEN** o sistema apresenta lucro bruto negativo e prejuízo igual ao seu valor absoluto

#### Scenario: Período sem receita
- **WHEN** não há receita no filtro
- **THEN** margem e ticket médio são apresentados como zero sem erro de divisão

### Requirement: Funil e conversão
O sistema SHALL contabilizar pedidos por situação e SHALL calcular a conversão como pedidos iniciados no checkout que chegaram a `confirmado` ou `concluido` divididos pelo total de pedidos iniciados no período.

#### Scenario: Funil com abandonos
- **WHEN** dez pedidos foram iniciados no período e quatro chegaram a confirmado ou concluído
- **THEN** o sistema apresenta taxa de conversão de 40%

#### Scenario: Nenhum pedido iniciado
- **WHEN** nenhum pedido foi iniciado no período
- **THEN** o sistema apresenta conversão zero sem erro de divisão

### Requirement: Painel e filtros
O sistema SHALL permitir filtrar o painel por período, categoria, produto e situação do pedido, aplicando os mesmos filtros a todos os indicadores exibidos.

#### Scenario: Filtro por categoria
- **WHEN** o gestor seleciona uma categoria e período
- **THEN** vendas, valores, funil e rankings refletem exclusivamente os itens e pedidos compatíveis com o filtro

### Requirement: Indicadores operacionais
O sistema SHALL apresentar produtos e categorias mais vendidos, produtos mais bem avaliados e produtos com estoque igual ou inferior ao limiar configurado.

#### Scenario: Estoque baixo
- **WHEN** um produto ativo possui estoque no limiar ou abaixo dele
- **THEN** o painel o inclui na lista de estoque baixo com quantidade atual

#### Scenario: Ranking de avaliações
- **WHEN** o painel calcula produtos mais bem avaliados
- **THEN** o sistema usa somente avaliações aprovadas e informa média e quantidade consideradas

