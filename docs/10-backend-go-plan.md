# Plano da API Go — ERP-Global

## Decisão
Monorepositório: manter Flutter na raiz e criar `backend/` em Go com Gin e PostgreSQL. Monólito modular. Não criar serviços separados prematuramente.

## Vocabulário do domínio
A única unidade de organização administrativa é **instituição** (`institution`, `institution_id`). Não introduzir outra entidade de subdivisão institucional. O isolamento, as permissões, as licenças e as operações usam o mesmo identificador. Alterações a campos legados devem passar por análise de migração e actualização coordenada dos DTOs Flutter, mocks e OpenAPI, sem mudanças de esquema silenciosas.

## Etapas
1. Fundação: HTTP, readiness/liveness, PostgreSQL, Docker, migrações, testes e CI.
2. Identidade: login sem registo público, refresh rotativo, papéis, permissões e auditoria.
3. Configuração: instituição, ano lectivo, períodos, turmas, cursos, disciplinas.
4. Alunos: ficheiros, matrículas, encarregados e documentos.
5. Avaliação e financeiro: notas, presenças, cobranças, pagamentos, contabilidade e auditoria.
6. Serviços: cartões, controlo de acesso, refeitório, relatórios e importação/exportação.
7. Offline: outbox, idempotência, cursores, tombstones e conflitos por domínio.
8. Produção: backup/restauro, monitorização, revisão de segurança, testes de integração e instalação local ou cloud.

## Critérios obrigatórios
- Mesmas respostas, erros, filtros e paginação do contrato mock.
- Migrações reversíveis quando seguro, e testadas contra PostgreSQL.
- Escopo de instituição imposto pelo servidor em cada consulta.
- Sem edição destrutiva de movimentos financeiros e documentos fiscais.
- Operações offline sensíveis: restrições transaccionais e reconciliação, não last-write-wins.
- Licenças assinadas; chave privada nunca distribuída com a aplicação.
- O Flutter permanece funcional com a API mockada até os endpoints reais passarem nos testes.
- Antes de substituir nomes e campos legados, inventariar as referências em código, fixtures, testes, migrações e OpenAPI.

## Estado desta entrega
Fundação com health checks, PostgreSQL, Docker, migração inicial de identidade e testes unitários. Restantes etapas não implementadas.
