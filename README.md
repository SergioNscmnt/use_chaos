# Óculos Neon

E-commerce Rails para catálogo público de óculos e checkout assistido pelo
WhatsApp.

## Ambiente

- Ruby 4.0.1 e Rails 8.1
- MySQL/MariaDB com `utf8mb4`
- Node 22, esbuild, Sass, Turbo e Stimulus
- Fuso inicial: `America/Porto_Velho`

As conexões usam `DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_USER`,
`DATABASE_PASSWORD`, `DATABASE_NAME` e `DATABASE_NAME_TEST`. A integração usa
`URL_PUBLICA` e `WHATSAPP_NUMERO`.

## Padrões operacionais configuráveis

Na ausência de decisão específica, a aplicação assume os perfis
`administrador`, `atendimento`, `gestor` e `moderador`; estoque baixo em 5
unidades; relatório assíncrono acima de 5.000 linhas; e retenção de 60 meses
para pedidos e auditoria, 36 para avaliações e 24 para manifestações. Todos os
valores podem ser substituídos por variáveis documentadas em
`config/initializers/configuracoes_negocio.rb`.

Space Grotesk, Tabler e ícones são empacotados localmente pelo Yarn.

## Comandos

```sh
bin/setup
bin/dev
bin/rails test
bin/rubocop
bin/brakeman --no-pager
bin/bundler-audit
```

Antes de publicar, siga o
[checklist de implantação e homologação](docs/checklist-implantacao.md), além
dos procedimentos de [operação](docs/operacao.md) e
[privacidade e retenção](docs/privacidade-e-retencao.md).
