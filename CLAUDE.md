# CLAUDE.md

Segue integralmente o [AGENTS.md](AGENTS.md).

Notas adicionais para Claude Code:

- És o agente para tarefas `agent:claude`: arquitectura, design system, licenciamento, guards, motor de notas, PDFs, animações, fluxos multi-módulo e revisão de PRs.
- Antes de codificar, lê a issue e os docs referidos. Mantém a PR pequena e focada.
- **Regra global:** em todos os projectos Flutter usa as agent skills oficiais (<https://docs.flutter.dev/ai/tools#agent-skills>). Plugin: `claude plugin marketplace add flutter/agent-plugins` e `claude plugin install dart-flutter@dart-flutter`.
- Usa `/code-review` antes de pedir merge.
- Não faças commit/push sem instrução; abre PR quando a issue estiver concluída.
