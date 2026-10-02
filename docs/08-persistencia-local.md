# 08 — Persistência local (Drift/SQLite)

Camada offline-first em `lib/core/database`. Por omissão a app continua a usar `Api...Repository` + Mock API; o Drift é activado por configuração.

## Estrutura

- `app_database.dart` — `AppDatabase` (Drift), `schemaVersion`, `MigrationStrategy` e `appDatabaseProvider`.
- `tables/sync_columns.dart` — mixin `SyncColumns`: `id` (ULID), `institutionId`, `campusId`, `createdAt`, `updatedAt`, `deletedAt`, `syncState`; enum `SyncState`.
- `tables/students_table.dart` — `Students` (usa `SyncColumns`) e `SyncOutbox` (fila de alterações por enviar).
- Referência: `features/students/data/repositories/drift_student_repository.dart` (`DriftStudentRepository implements StudentRepository`).

## Trocar Mock/API ↔ Drift

`studentRepositoryProvider` escolhe a implementação com `useLocalDbProvider` (`AppConfig.useLocalDb`):

```
flutter run --dart-define=USE_LOCAL_DB=true     # Drift
flutter run                                      # Api + Mock API (padrão)
```

A UI só conhece `StudentRepository`; nada muda nos ecrãs. O repository Drift ignora `gradeId/classroomId` (precisam da tabela de matrículas).

## Migrações

Alterar schema = incrementar `schemaVersion` e acrescentar `if (from < N)` em `onUpgrade`. Regenerar: `dart run build_runner build --delete-conflicting-outputs` (o `app_database.g.dart` é versionado).

## Configuração por plataforma

| Plataforma | Notas |
|---|---|
| Android / Windows | `drift_flutter` abre SQLite nativo (ficheiro na pasta de dados da app). Sem passos extra (SQLite vem via `sqlite3` com build hooks). Nota: `flutter build windows` exige o componente ATL do Visual Studio por causa de `flutter_secure_storage_windows` (`atlstr.h`), independente do Drift. |
| Web | Requer `web/sqlite3.wasm` e `web/drift_worker.js` (versões compatíveis com `sqlite3`/`drift` do `pubspec.lock`; ver <https://drift.simonbinder.eu/platforms/web/>). A base só abre quando `USE_LOCAL_DB=true`, por isso o build Web continua a compilar e a funcionar com Mock API sem esses ficheiros. |
| Testes | `AppDatabase(NativeDatabase.memory())`. |

## Sincronização (`lib/core/sync`)

- `sync_outbox` (schema v2) tem `status` (`pending`|`error`), `lastError` e `baseJson` (registo da última sync, base do merge por campo). Estado de um registo: `OutboxStore.statusOf` → `ok` / `pending` / `error`.
- `SyncEngine.run()` funde as entradas por registo (`create`+`update` → um `create`; `create`+`delete` → nada a enviar), envia por `SyncRepository` (`POST /v1/sync/push`, `GET /v1/sync/{entity}/{id}`) e limpa a outbox. Sem rede: pára e mantém pendente. Outros erros: entrada em `error` (bloqueia o registo até o utilizador repetir ou descartar).
- Conflitos (`409 CONFLICT`): `ConflictPolicies` — baixo risco = `fieldMerge` (por campo face à base; choques → `updatedAt` mais recente), financeiro/fiscal (`invoice`, `payment`, …) = `serverWins`.
- Cada módulo regista um `SyncEntityBinding` em `syncBindingsProvider` (aplicar versão do servidor, marcar `synced`, apagar). Os repositories Drift devem gravar `baseJson` ao enfileirar updates; sem base, o merge trata todos os campos diferentes como choque.
- Ecrã: `/settings/sync` (permissão `core.sync.manage`).
