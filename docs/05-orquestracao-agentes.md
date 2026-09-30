# 05 — Orquestração de Agentes (Claude Code + Codex)

O trabalho é dividido em **issues pequenas** que um agente conclui sozinho, rápido e com pouco contexto. Um humano (ou agente coordenador) revê e faz merge.

## Regras de uma boa issue

- **Uma issue = um PR**, idealmente ≤ 300 linhas alteradas e ≤ 1 hora de trabalho de agente.
- Título no imperativo: `[students] Criar StudentModel e mock de dados`.
- Contém sempre: **Contexto** (link para docs), **Tarefas**, **Critérios de aceitação**, **Ficheiros esperados**, **Fora de âmbito**, **Depende de** (`#n`).
- Testável: `flutter analyze` sem avisos + testes da issue a passar.
- Sem decisões em aberto — se houver, o coordenador resolve antes de a issue ir para `ready`.

## Labels

| Grupo | Labels |
|---|---|
| Agente | `agent:claude`, `agent:codex` |
| Tamanho | `size:xs` (<50 linhas), `size:s` (<150), `size:m` (<300) |
| Tipo | `type:feature`, `type:docs`, `type:chore`, `type:test`, `type:design` |
| Módulo | `module:core`, `module:students`, `module:academic`, `module:grades`, `module:billing`, `module:cafeteria`, `module:access`, `module:portal`, `module:reports`, `module:license`, `module:design-system` … |
| Fase | `phase:0` … `phase:15` |
| Estado | `status:ready`, `status:blocked` |

## Quem faz o quê

| Tipo de tarefa | Agente |
|---|---|
| Models/DTOs, mocks, repositories mock, widgets simples e repetitivos, CRUD de lista/formulário seguindo padrão já existente, testes de unidade de modelos | **Codex** |
| Arquitectura, design system, licenciamento, router/guards, motor de fórmulas de notas, PDFs, animações, fluxos multi-módulo, revisão de PRs, refactors, testes de integração | **Claude Code** |

Regra prática: se a issue **segue um padrão já existente** → Codex; se **cria o padrão** ou cruza módulos → Claude.

## Fluxo

1. Coordenador cria/refina issues (`status:ready`, com agente atribuído por label).
2. Cada agente trabalha num **worktree/branch próprio**: `feat/<issue>-<slug>` (ex.: `feat/12-student-model`).
3. Agente abre PR com `Closes #n`, executa `flutter analyze` + `flutter test` antes.
4. Revisão (Claude Code `/code-review` ou humano) → merge em `master` (squash).
5. Issues dependentes passam a `status:ready`.

Com o **Orca**: usar `orca-cli` para criar worktrees por issue e lançar `claude`/`codex` em terminais paralelos; a skill `orchestration` coordena dependências e recolhe `worker_done`.

## Regras para conflitos

- Ficheiros partilhados (router, `module_registry`, tema) só são tocados por issues `agent:claude` ou por uma issue dedicada de registo.
- Cada feature vive na sua pasta `features/<modulo>/`; issues de módulos diferentes podem correr em paralelo sem conflitos.
- Registo do módulo no `ModuleRegistry` faz parte da issue "bootstrap do módulo" (Claude); as issues seguintes só adicionam ficheiros dentro do módulo.

## Definition of Done

- [ ] Critérios de aceitação cumpridos
- [ ] `flutter analyze` limpo, `dart format` aplicado
- [ ] Testes adicionados/actualizados
- [ ] Sem valores fixos (cores, textos, espaçamentos) fora dos tokens/i18n
- [ ] Respeita permissões e licença do módulo
- [ ] Documentação/README do módulo actualizado se aplicável
