# API ERP-Global — plano em 10 fases com agentes

## Restrições obrigatórias
- Apenas instituição (`institution` / `institutionId` / `institution_id`) como contexto administrativo.
- **Sem migrations, PostgreSQL activo, Neon, ligação remota nem credenciais de base de dados** até decisão posterior.
- Contratos OpenAPI + schemas Go + fixtures e adaptadores de memória. Não alegar persistência real.
- Flutter e mocks existentes não devem ser quebrados.
- O código Go usa inglês; documentação e interface usam português.
- Dados monetários em inteiros na menor unidade, IDs ULID, datas UTC, soft-delete e versão de registo.
- `institutionId` tem de ser derivado do contexto autenticado em endpoints futuros; nunca confiado cegamente no corpo do pedido.
- Cada fase deve ter testes unitários, contrato, autorização e casos de falha; não avançar sem CI verde.

## Agentes e ownership
- **A0 — Arquitecto / integrador:** contratos globais, decisões, review e sequência de merge.
- **A1 — Identidade:** sessão, autenticação, RBAC, licenças e auditoria de acesso.
- **A2 — Académico:** anos lectivos, períodos, turmas, professores, disciplinas e horários.
- **A3 — Pessoas:** alunos, encarregados, matrículas e documentos.
- **A4 — Financeiro:** propinas, pagamentos, documentos fiscais, contabilidade, transacções.
- **A5 — Operacional:** cartões, controlo de acesso, refeitório, biblioteca, inventário.
- **A6 — Qualidade / contratos:** OpenAPI, mock HTTP, testes de contrato, segurança, carga e CI.
- **A7 — Offline / sync:** outbox, idempotência, conflitos, cursores e sincronização simulada.

Os agentes trabalham em issues pequenas e branches distintas; A0 é responsável pela integração. Nunca editar o mesmo ficheiro simultaneamente; alterar o contrato comum via PR de A0.

## Fases
| Fase | Entrega | Agentes | Critério para aceitar |
|---|---|---|---|
| 1 | Esquema base, vocabulário, envelopes de API, runner sem DB | A0, A6 | Testes do núcleo e build executáveis |
| 2 | Identidade, instituições, utilizadores, RBAC e licenças (schemas) | A1, A6 | Testes de scope e negação por omissão |
| 3 | Estrutura escolar: ano, período, disciplinas, turmas, horários | A2, A6 | Datas e relacionamentos validados |
| 4 | Alunos, responsáveis, matrícula e documentos | A3, A6 | Duplicados, vínculos e estados testados |
| 5 | Docentes, presenças, avaliação, notas e boletins | A2, A3, A6 | Regras e fechos auditáveis |
| 6 | Cobrança, pagamentos, documentos fiscais e caixa | A4, A6 | Idempotência, soma e imutabilidade |
| 7 | Contabilidade, RH e reconciliação em memória | A4, A6 | Partidas balanceadas, isolamento |
| 8 | Cartões, acesso, refeitório, inventário e biblioteca | A5, A7, A6 | Eventos duplicados e offline testados |
| 9 | Sync, licenciamento offline e relatórios | A7, A1, A6 | Conflitos, versões e replays testados |
| 10 | Hardening, testes de contrato ponta a ponta, prontidão PostgreSQL | Todos, A0 integra | CI verde, sem DB real, cobertura dos fluxos críticos |

## Convenções de entrega
1. Definir schema/DTO e casos de erro primeiro.
2. Alinhar no contrato OpenAPI antes de criar handlers.
3. Criar repository de memória por interface, com seed determinístico e resets de teste.
4. Implementar regras de domínio antes de HTTP.
5. Testar `401`, `403`, `404`, `409`, `422`, limites de instituição, licença e reenvio de pedidos.
6. Executar `go test ./...`, `go vet ./...` e os contract tests Flutter relevantes.
7. PR com checklist, riscos, referências das issues e testes executados.
8. Só depois projectar o mapeamento SQL/PostgreSQL, sem aplicar migrations nem contactar Neon.

## Progresso
- Fase 1: scaffold em Go, rotas de saúde e catálogo de schemas, testes básicos; **validação de CI pendente**.
- Fases 2–10: modelos iniciais de entidades estabelecidos; handlers, casos de uso e testes completos **ainda pendentes**.
- Agentes: responsabilidades definidas neste documento; execução autónoma não foi iniciada.
