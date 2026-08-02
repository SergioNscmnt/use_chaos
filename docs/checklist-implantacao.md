# Checklist de implantação e homologação

As decisões e evidências técnicas desta versão estão registradas em
[homologacao-final.md](homologacao-final.md). Os itens abaixo que dependem do
ambiente ou de responsáveis humanos devem ser executados a cada publicação.

## Antes da publicação

- [ ] Definir `URL_PUBLICA` com HTTPS e configurar DNS/certificado.
- [ ] Definir `WHATSAPP_NUMERO` somente com código do país, DDD e número.
- [ ] Substituir `ADMIN_EMAIL` e `ADMIN_PASSWORD` por credenciais definitivas.
- [ ] Homologar os prazos de retenção com o responsável por privacidade.
- [ ] Homologar estoque baixo, prazo de pedido atrasado e limite de relatório
      assíncrono com a operação.
- [ ] Configurar banco MySQL, armazenamento persistente e executor do Solid Queue.
- [ ] Executar migrations e seeds mínimos no ambiente de destino.
- [ ] Executar `bin/rails test`, `bin/rubocop`, `bin/brakeman --no-pager` e
      `bin/bundler-audit`.
- [ ] Fazer backup inicial e testar a restauração em ambiente isolado.

## Homologação funcional

- [x] Validar catálogo, filtros e produto em celular e desktop.
- [x] Validar navegação completa por teclado e com JavaScript desativado.
- [ ] Enviar pedido de teste e conferir número, itens, quantidades, total e
      caracteres acentuados na mensagem do WhatsApp.
- [ ] Abrir o link `wa.me` em celular e WhatsApp Web com o número definitivo.
- [ ] Confirmar o pedido e conferir baixa única de estoque; cancelar e conferir
      reposição única.
- [ ] Aprovar uma avaliação e tratar uma manifestação com e sem permissão para
      dados pessoais.
- [ ] Comparar painel, CSV e PDF para o mesmo período.

## Depois da publicação

- [ ] Confirmar health check, logs sem dados sensíveis e processamento da fila.
- [ ] Agendar e monitorar backup e `AplicarRetencaoDadosJob`.
- [ ] Registrar responsáveis por pedidos, moderação, privacidade e incidentes.
- [ ] Registrar a versão implantada e o procedimento de rollback aplicável.
