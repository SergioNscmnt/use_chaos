# Privacidade e retenção

## Mapa preliminar de operações e hipóteses legais

Este mapa é uma especificação operacional, não um parecer jurídico. O
controlador e o responsável por privacidade devem confirmar as hipóteses no
contexto real antes da produção. A LGPD exige uma hipótese legal para cada
operação e os princípios de finalidade, adequação e necessidade.

| Operação | Dados mínimos | Finalidade | Hipótese preliminar | Acesso |
| --- | --- | --- | --- | --- |
| Carrinho | token aleatório, produto e quantidade | manter a seleção temporária | legítimo interesse, condicionado a necessidade, expectativa e salvaguardas | aplicação; sem identificação direta |
| Pedido/WhatsApp | nome, contato e snapshots dos itens | atender solicitação e executar procedimentos preliminares à compra | execução de contrato ou procedimentos preliminares a pedido do titular (art. 7º, V) | atendimento e perfis autorizados |
| Avaliação | nota, comentário, nome opcional e hash de origem | moderar e publicar conteúdo solicitado pelo visitante; prevenir abuso | legítimo interesse (art. 7º, IX), condicionado a teste de balanceamento; reavaliar consentimento para usos adicionais | moderação; público somente após aprovação |
| Sugestão/feedback | mensagem, categoria, contato opcional e hash de origem | receber, analisar e eventualmente responder à manifestação | legítimo interesse (art. 7º, IX), condicionado a teste de balanceamento e à expectativa do titular | moderação; contato somente com permissão específica |
| Auditoria | usuário interno, ação, alterações necessárias, data e IP quando aplicável | segurança, rastreabilidade e exercício regular de direitos | legítimo interesse e, conforme o caso concreto, exercício regular de direitos (art. 7º, VI e IX) | administração e operação autorizada |

O legítimo interesse somente deve ser confirmado após documentar finalidade,
necessidade, balanceamento e salvaguardas; não se aplica a dados sensíveis
neste projeto. Usos novos ou marketing exigem avaliação própria e não estão
autorizados por este mapa. Referências: [artigos 6º e 7º da
LGPD](https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709compilado.htm)
e [guia da ANPD sobre legítimo
interesse](https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/guia_orientativo_hipoteses_legais_tratamento_de_dados_pessoais_legitimo_interesse).

## Finalidades e acesso

- Pedidos coletam nome e contato para identificar o atendimento iniciado pelo
  cliente e manter o histórico comercial. Atendimento e administração têm
  acesso conforme perfil.
- Avaliações coletam nota, comentário e nome opcional para publicação após
  moderação.
- Sugestões e feedbacks coletam mensagem e contato opcional para resposta.
- Auditoria registra o usuário interno, a ação e apenas os valores necessários
  à rastreabilidade. Senhas, tokens e contatos não entram nos logs.

As hipóteses e os prazos definitivos devem ser homologados pelo responsável de
privacidade antes da produção e registrados no checklist de implantação.

## Prazos iniciais configuráveis

- Pedidos e auditoria: 60 meses.
- Avaliações: 36 meses.
- Manifestações: 24 meses.

`AplicarRetencaoDadosJob` anonimiza os dados pessoais elegíveis e elimina
auditorias vencidas. Agregados financeiros baseados nos snapshots dos itens são
preservados.

## Direitos e incidentes

Solicitações de acesso, correção ou eliminação devem ser autenticadas e
registradas. Em incidente, revogue sessões, preserve a auditoria necessária,
avalie o alcance e siga o procedimento legal de comunicação.
