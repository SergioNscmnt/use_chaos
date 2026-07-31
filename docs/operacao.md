# Operação, backup e rollback

## Configuração obrigatória

Defina `DATABASE_*`, `URL_PUBLICA`, `WHATSAPP_NUMERO`, `FUSO_HORARIO`,
`ADMIN_EMAIL` e `ADMIN_PASSWORD`. Homologue o link `wa.me` em celular e
desktop antes da abertura pública.

## Responsabilidade operacional

A equipe deve mover cada pedido iniciado para atendimento, confirmação,
conclusão ou cancelamento. A confirmação baixa estoque; o cancelamento após
baixa repõe as quantidades. Pedidos parados além do limite configurado são
destacados.

## Backup e restauração

1. Gere um dump consistente do banco e copie os objetos do Active Storage.
2. Valide periodicamente a restauração em ambiente isolado.
3. Antes de migrations, registre a versão da aplicação e confirme o backup.

## Rollback

Desabilite temporariamente o checkout, reverta a versão da aplicação e execute
somente migrations reversíveis. Não reverta uma migration destrutiva sem
restaurar o backup e conferir pedidos/estoque. O catálogo pode permanecer em
modo de leitura durante a recuperação.

## Relatórios

Relatórios pequenos são síncronos. Acima do limite configurado, Solid Queue
gera o arquivo em background e restringe o download ao solicitante ou ao perfil
administrador.
