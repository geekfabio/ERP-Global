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
