## ADDED Requirements

### Requirement: Carrinho persistente para visitante
O sistema SHALL associar um carrinho anônimo a um token seguro mantido em cookie assinado e SHALL preservar seus itens entre requisições até a expiração configurada ou conclusão do checkout.

#### Scenario: Visitante retorna ao catálogo
- **WHEN** um visitante com cookie válido retorna antes da expiração do carrinho
- **THEN** o sistema recupera os mesmos itens e quantidades sem exigir autenticação

#### Scenario: Token inválido
- **WHEN** a requisição contém um token de carrinho inválido ou adulterado
- **THEN** o sistema ignora o token, cria um novo carrinho seguro e não expõe itens de outro visitante

### Requirement: Manutenção dos itens
O sistema SHALL permitir adicionar produto elegível, alterar sua quantidade e removê-lo, validando no servidor que a quantidade seja inteira, positiva e não superior ao estoque disponível.

#### Scenario: Inclusão de produto
- **WHEN** o visitante adiciona uma quantidade válida de um produto comprável
- **THEN** o sistema inclui ou incrementa o item e atualiza quantidade e subtotal exibidos

#### Scenario: Quantidade acima do estoque
- **WHEN** o visitante solicita uma quantidade superior ao estoque disponível
- **THEN** o sistema rejeita a alteração, preserva uma quantidade válida e informa o limite disponível

#### Scenario: Remoção de item
- **WHEN** o visitante remove um item do carrinho
- **THEN** o sistema exclui o item e recalcula o total informativo do carrinho

### Requirement: Elegibilidade reavaliada
O sistema SHALL impedir novas inclusões de produtos inativos, não publicados, indisponíveis ou sem estoque e SHALL sinalizar itens que deixaram de ser elegíveis após terem sido adicionados.

#### Scenario: Produto fica indisponível no carrinho
- **WHEN** um produto do carrinho se torna indisponível antes do checkout
- **THEN** o sistema identifica o item afetado e impede a conclusão até que ele seja removido ou corrigido

### Requirement: Atualizações progressivas
O sistema SHALL oferecer todas as operações do carrinho por HTML e SHALL melhorar a experiência com Turbo Frames ou Turbo Streams quando disponíveis.

#### Scenario: Navegador sem JavaScript
- **WHEN** o visitante altera o carrinho em um navegador sem JavaScript
- **THEN** o sistema conclui a operação por requisição HTML e apresenta o carrinho atualizado

