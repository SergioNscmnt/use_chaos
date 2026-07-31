## ADDED Requirements

### Requirement: Relatório filtrado
O sistema SHALL permitir gerar relatórios gerenciais usando período, categoria, produto e situação do pedido e SHALL usar as mesmas definições financeiras do painel.

#### Scenario: Geração com filtros
- **WHEN** o usuário autorizado solicita um relatório com filtros
- **THEN** o sistema aplica os filtros a todos os totais e linhas e identifica os critérios no resultado

#### Scenario: Ausência de dados
- **WHEN** nenhum registro atende aos filtros
- **THEN** o sistema gera um resultado válido com estado vazio e totais zerados

### Requirement: Exportação CSV
O sistema SHALL exportar CSV em codificação compatível com caracteres do português, com cabeçalhos localizados, linhas detalhadas e totais coerentes com a consulta.

#### Scenario: Download CSV
- **WHEN** o usuário solicita CSV de um relatório
- **THEN** o sistema entrega arquivo com extensão e tipo corretos, filtros, data de geração, cabeçalhos e dados correspondentes

### Requirement: Exportação PDF
O sistema SHALL exportar PDF adequado para impressão, contendo título, filtros aplicados, data e fuso da geração, indicadores e dados do relatório.

#### Scenario: Download PDF
- **WHEN** o usuário solicita PDF de um relatório
- **THEN** o sistema entrega documento legível com paginação e totais iguais aos da consulta filtrada

### Requirement: Autorização e rastreabilidade
O sistema MUST restringir geração e download de relatórios a perfis autorizados e SHALL registrar a geração com usuário, formato, filtros e horário.

#### Scenario: Acesso negado
- **WHEN** um usuário autenticado sem permissão solicita uma exportação
- **THEN** o sistema nega a operação e não gera nem expõe o arquivo

#### Scenario: Exportação autorizada
- **WHEN** um usuário autorizado conclui uma exportação
- **THEN** o sistema registra o evento de auditoria associado

### Requirement: Processamento de relatórios grandes
O sistema SHALL processar em background relatórios acima do limite configurado e SHALL impedir que um usuário baixe arquivo pertencente a outro usuário sem permissão administrativa.

#### Scenario: Relatório excede o limite
- **WHEN** a estimativa da consulta supera o limite síncrono
- **THEN** o sistema agenda a geração e informa ao solicitante que o arquivo ainda está em processamento

