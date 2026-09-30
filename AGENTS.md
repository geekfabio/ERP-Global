# AGENTS.md — Instruções para agentes (Codex, Claude Code, outros)

Projecto: **ERP-Global** — plataforma modular de gestão escolar em Flutter (offline first, backend por outra equipa).

Ler antes de começar: `README.md`, `docs/02-modulos-e-licenciamento.md`, `docs/04-design-system.md`, `docs/05-orquestracao-agentes.md`. Detalhes funcionais em `docs/03-funcionalidades.md`; dados em `docs/06-modelo-de-dados.md`; API mockada e login em `docs/07-mock-api.md`.

## Regras

1. **Trabalha só na issue atribuída.** Não amplies o âmbito; se faltar algo, comenta na issue.
2. **Feature-first modular**: código do módulo em `lib/features/<modulo>/{data,domain,presentation}`. Não importes internals de outro módulo; usa contratos/eventos em `core/`.
3. **Sem dados fixos na UI**: cores/espaçamentos/tipografia via tokens do tema; textos via i18n (pt-AO base).
4. **Dinheiro em `int`** (menor unidade), nunca `double`. IDs em ULID. Datas em UTC na persistência.
5. **Mock API, não mock de repository**: a UI só fala com a interface do repository (Riverpod); a implementação é `Api...Repository` (Dio + DTOs). O que é simulado é a rede: handlers em `data/mock_api/` + fixtures em `data_mocks/`, com envelope, paginação, latência e erros conforme `docs/07-mock-api.md`. Nunca devolvas listas Dart directas à UI.
6. **Sem registo**: só existe login. Não criar ecrãs/endpoints de sign-up nem recuperação auto-serviço; contas são criadas por admin.
7. **Permissões e licença**: rotas e acções passam por `PermissionGuard` e `ModuleGuard`.
8. **Stack**: Riverpod, GoRouter, Freezed + json_serializable, Drift, Dio, flutter_animate. Não adiciones dependências novas sem justificar na PR.
9. **Qualidade**: `dart format .`, `flutter analyze` sem avisos, testes para lógica (modelos, regras, repositories mock).
10. **Git**: branch `feat/<n>-<slug>`; commits convencionais (`feat(students): ...`); PR com `Closes #n`, ≤ ~300 linhas.
11. Idioma: código e identificadores em **inglês**; UI, docs e mensagens ao utilizador em **português (pt-AO)**.
12. **Agent skills oficiais do Flutter (obrigatório)**: todos os modelos/agentes, neste e em qualquer projecto Flutter, usam as skills oficiais descritas em <https://docs.flutter.dev/ai/tools#agent-skills> ([flutter/agent-plugins](https://github.com/flutter/agent-plugins), [dart-lang/skills](https://github.com/dart-lang/skills)) — testes de widget, layout responsivo, routing, l10n, arquitectura, serialização JSON. Antes de improvisar, verifica se existe uma skill para a tarefa. Instalação: ver [README.md](README.md#agent-skills-flutter).
