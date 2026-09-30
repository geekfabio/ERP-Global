# Como contribuir

Antes de começar, lê [AGENTS.md](AGENTS.md), [README.md](README.md),
[módulos e licenciamento](docs/02-modulos-e-licenciamento.md),
[design system](docs/04-design-system.md),
[orquestração de agentes](docs/05-orquestracao-agentes.md) e
[Mock API e login](docs/07-mock-api.md).

## Fluxo de trabalho

1. Trabalha apenas na issue atribuída; comenta na issue se faltar algo.
2. Cria uma branch a partir de `master`: `feat/<n>-<slug>` (ex.: `feat/4-contributing-pr-template`).
3. Mantém um PR por issue, idealmente até 300 linhas alteradas.
4. Usa commits convencionais: `feat(students): adicionar ficha do aluno`,
   `fix(auth): corrigir validação` ou `docs(core): documentar contribuição`.
5. Abre o PR contra `master`, preenche o template e inclui `Closes #n`.
   O coordenador revê e faz merge; o agente não faz merge.

## Convenções

- Código e identificadores em inglês; UI, documentação e mensagens em português (pt-AO).
- Arquitectura feature-first em `lib/features/<modulo>/{data,domain,presentation}`;
  comunicação entre módulos por contratos/eventos em `core/`.
- UI com tokens do tema e i18n; rotas/acções com `PermissionGuard` e `ModuleGuard`.
- Dinheiro em `int` (menor unidade), IDs ULID e datas UTC na persistência.
- UI usa interfaces de repository via Riverpod; `Api...Repository` usa Dio e DTOs.
  Simula a rede com handlers e fixtures, nunca listas directas de um repository mock.
- Só login: contas e recuperação de acesso são geridas por administração.
- Não adiciones dependências sem necessidade da issue e justificação no PR.

## Validação antes do PR

Usa a versão Flutter fixada em `.fvmrc`. Com esse SDK no `PATH`, executa:

```sh
flutter pub get
dart format .
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

A análise deve terminar sem avisos e os testes devem passar. Adiciona/actualiza
testes para lógica alterada (modelos, regras e repositories com API mockada),
regista os resultados no PR e actualiza a documentação relevante.
