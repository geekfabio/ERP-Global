# ERP-Global

ERP-Global é uma plataforma de gestão escolar completa, pensada para escolas, colégios, institutos e centros de formação que precisam centralizar a operação académica, administrativa, financeira e operacional.

O projecto será desenvolvido em **Flutter** no frontend, com backend atribuído a outra equipa/pessoa, seguindo uma arquitectura modular, offline first e preparada para sincronização opcional com cloud.

## Documentação

| Documento | Conteúdo |
|---|---|
| [ROADMAP](ROADMAP.md) | Marcos e fases |
| [docs/01 — Perfis e permissões](docs/01-perfis-e-permissoes.md) | 14 perfis, RBAC com âmbito, matriz de acessos |
| [docs/02 — Módulos e licenciamento](docs/02-modulos-e-licenciamento.md) | Catálogo de módulos, planos, licença assinada offline |
| [docs/03 — Funcionalidades](docs/03-funcionalidades.md) | Ano lectivo, trimestres, ficha do aluno, matrículas, notas, boletim, facturação… |
| [docs/04 — Design system](docs/04-design-system.md) | Tokens, componentes, animações, brief do logo por IA |
| [docs/05 — Orquestração de agentes](docs/05-orquestracao-agentes.md) | Como Claude Code e Codex trabalham por issues pequenas |
| [docs/06 — Modelo de dados](docs/06-modelo-de-dados.md) | Entidades e relações |
| [docs/07 — Mock API e login](docs/07-mock-api.md) | API simulada (Dio), contrato, seed, autenticação só-login |
| [docs/adr-fiscal](docs/adr-fiscal.md) | ADR (proposta): numeração fiscal, SAF-T e assinatura de documentos |
| [AGENTS.md](AGENTS.md) / [CLAUDE.md](CLAUDE.md) | Regras para agentes |

## Princípios

- **Modular e licenciado**: cada secção da escola é um módulo; a licença (assinada, validada offline) define o que está activo.
- **Multi-perfil**: direcção, coordenação, secretaria, professores, financeiro, encarregados, alunos e mais, cada um com a sua experiência.
- **Offline first**; API mockada realista (mesmo contrato do backend) até o backend existir.
- **Sem registo público**: só login; contas são criadas por administração (`super_admin`).
- **Design consistente** com tokens, componentes partilhados e animações com propósito.

## Agent Skills (Flutter)

**Regra:** todos os modelos/agentes que trabalham neste projecto (e em qualquer projecto Flutter) usam as agent skills oficiais — <https://docs.flutter.dev/ai/tools#agent-skills>. Repositórios: [flutter/agent-plugins](https://github.com/flutter/agent-plugins) (Flutter) e [dart-lang/skills](https://github.com/dart-lang/skills) (Dart).

- **Claude Code:** `claude plugin marketplace add flutter/agent-plugins` e `claude plugin install dart-flutter@dart-flutter`.
- **Outros agentes (Codex, Cursor…):** seguir <https://docs.flutter.dev/ai/get-started>; as skills ficam em `.agents/skills`.
- **Skills de pacotes:** após adicionar uma dependência, `dart run skills@ get` para descobrir as skills dela.

Ver a regra em [AGENTS.md](AGENTS.md) (nº 12).

## Visão do Produto

O ERP-Global pretende reunir num único ecossistema:

- Gestão académica
- Matrículas e alunos
- Professores e turmas
- Avaliações, notas e pautas
- Secretaria e gestão documental
- Financeiro e tesouraria
- Contabilidade
- RH
- Biblioteca
- Inventário e património
- Catracas e controlo de acesso
- Cartão escolar integrado
- Refeitório/restaurante escolar
- Saldo pré-pago com desconto por cartão
- Portal do encarregado
- Importação/exportação de dados
- Relatórios e dashboards
- Funcionamento offline first com sincronização cloud opcional

## Stack Frontend

A stack inicial prevista para o frontend é:

- Flutter
- Dart
- Riverpod para gestão de estado e injecção de dependências
- GoRouter para navegação
- Dio para comunicação HTTP
- Drift/SQLite para persistência local
- Freezed para models imutáveis
- Json Serializable para serialização
- Flutter Secure Storage para dados sensíveis
- Flutter Animate para micro-interacções
- Rive/Lottie apenas quando fizer sentido
- FVM para controlo da versão do Flutter

## Arquitectura

O projecto seguirá uma abordagem **Feature-first**, mantendo separação entre apresentação, domínio e dados.

Estrutura prevista:

```txt
lib/
  app/
    app.dart
    router/
    theme/
    config/
  core/
    constants/
    errors/
    network/
    database/
    sync/
    security/
    utils/
    widgets/
  features/
    auth/
      data/
        models/
        repositories/
        data_mocks/
      domain/
      presentation/
    students/
      data/
        models/
        repositories/
        data_mocks/
      domain/
      presentation/
    guardians/
      data/
        models/
        repositories/
        data_mocks/
      domain/
      presentation/
    academic/
      data/
        models/
        repositories/
        data_mocks/
      domain/
      presentation/
    finance/
      data/
        models/
        repositories/
        data_mocks/
      domain/
      presentation/
    accounting/
      data/
        models/
        repositories/
        data_mocks/
      domain/
      presentation/
    cafeteria/
      data/
        models/
        repositories/
        data_mocks/
      domain/
      presentation/
    access_control/
      data/
        models/
        repositories/
        data_mocks/
      domain/
      presentation/
    settings/
      data/
        models/
        repositories/
        data_mocks/
      domain/
      presentation/
```

## Models, Repositories e Data Mocks

Nesta fase inicial, o projecto deve manter dados simulados por módulo para permitir desenvolvimento do frontend mesmo antes do backend estar pronto.

Cada feature deverá conter:

- `models/` — estruturas de dados da funcionalidade
- `repositories/` — contratos e implementação inicial com dados mockados
- `data_mocks/` — dados simulados para prototipagem, testes e desenvolvimento visual

Exemplo:

```txt
features/students/data/
  models/
    student_model.dart
    guardian_model.dart
  repositories/
    student_repository.dart
    mock_student_repository.dart
  data_mocks/
    students_mock_data.dart
```

Quando a API real estiver pronta, os repositories poderão trocar gradualmente a fonte de dados mockada por chamadas HTTP/SQLite/sync engine, sem obrigar a reescrever a UI.

## Estratégia Offline First

O sistema deverá funcionar primeiro com dados locais e sincronizar com cloud quando disponível.

Fluxo esperado:

```txt
Flutter App
  -> Repository
  -> Local Database / Data Mocks
  -> Sync Engine
  -> Backend / Cloud
```

Na fase inicial, enquanto o backend não estiver pronto, os `data_mocks` simulam o comportamento da aplicação.

## Módulos Prioritários

1. Autenticação e perfis
2. Configurações gerais da instituição
3. Alunos e matrículas
4. Encarregados
5. Gestão académica
6. Financeiro
7. Contabilidade
8. Refeitório e saldo pré-pago
9. Cartão escolar
10. Catracas e controlo de acesso
11. Portal do encarregado
12. Importação/exportação
13. Relatórios e dashboards

## Estado Inicial

Este repositório começa com a documentação base do produto, roadmap e estrutura recomendada para orientar o desenvolvimento Flutter.
