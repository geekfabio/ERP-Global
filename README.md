# ERP-Global

ERP-Global é uma plataforma de gestão escolar completa, pensada para escolas, colégios, institutos e centros de formação que precisam centralizar a operação académica, administrativa, financeira e operacional.

O projecto será desenvolvido em **Flutter** no frontend, com backend atribuído a outra equipa/pessoa, seguindo uma arquitectura modular, offline first e preparada para sincronização opcional com cloud.

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
