# Homologação final

## Decisões encerradas

| Tema | Valor final |
| --- | --- |
| WhatsApp | Um número por ambiente, em `WHATSAPP_NUMERO`, com 10 a 15 dígitos e sem formatação. Desenvolvimento e teste usam `5569999999999`, exclusivamente como número técnico de demonstração. Produção não inicia sem um número válido. |
| Texto institucional | `Olá! Quero continuar o pedido {número}.`, seguido por cliente, contato, itens, quantidades, preços e total. |
| Perfis administrativos | `administrador`, `atendimento`, `gestor` e `moderador`. |
| Estoque baixo | 5 unidades, global e substituível por `ESTOQUE_BAIXO`; personalização por produto fica fora da primeira versão. |
| Pedido atrasado | 24 horas sem conclusão. |
| Expiração do carrinho | 30 dias. |
| Retenção | Pedidos e contatos: 60 meses; manifestações: 24 meses; avaliações: 36 meses; auditoria: 60 meses. |
| Fonte | Space Grotesk hospedada e servida pela própria aplicação. |
| Relatório assíncrono | Acima de 5.000 linhas. |

## WhatsApp

A homologação técnica foi concluída em 31/07/2026:

- o serviço gera `https://wa.me/{numero}?text={mensagem}` com conteúdo
  codificado, acentos, itens, quantidades e total;
- o número configurado aceita somente 10 a 15 dígitos;
- o endpoint `wa.me` respondeu com redirecionamento HTTP 302 para o envio do
  WhatsApp;
- testes automatizados cobrem a URL e a mensagem geradas.

O número de demonstração não representa uma linha comercial. Antes de liberar
tráfego em produção, o responsável operacional deve definir o número definitivo
como segredo do ambiente e confirmar a abertura no celular e no WhatsApp Web.
Essa confirmação operacional não deve ser substituída por um número gravado no
repositório.

## Evidências automatizadas

- Catálogo e produto auditados em 1440 × 900 e 390 × 844.
- Navegação por teclado, skip link, rótulos e preferência de movimento reduzido.
- Auditoria axe com WCAG 2 A, AA e 2.1 AA nas páginas públicas essenciais.
- Fluxos sem JavaScript para busca, carrinho, checkout, avaliação e manifestação.
- URL canônica, descrição SEO, filtros e conteúdo público cobertos por testes de
  integração.
