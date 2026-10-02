import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tables/students_table.dart';

part 'app_database.g.dart';

/// Base de dados local (Drift/SQLite), fonte offline-first.
///
/// Plataformas: Android/Windows usam SQLite nativo (`drift_flutter`); Web usa
/// `sqlite3.wasm` + `drift_worker.js` em `web/` (ver docs/08-persistencia-local.md).
@DriftDatabase(tables: [Students, SyncOutbox])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Base persistente no dispositivo (aberta de forma preguiçosa).
  factory AppDatabase.persistent({String name = 'erp_global'}) => AppDatabase(
    driftDatabase(
      name: name,
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    ),
  );

  /// Incrementar a cada alteração de schema e acrescentar o passo em [migration].
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // v1 é o schema inicial. Novos passos: `if (from < 3) { ... }`.
      if (from < 2) {
        // Outbox com estado, erro e base de merge (issue #83).
        await m.addColumn(syncOutbox, syncOutbox.status);
        await m.addColumn(syncOutbox, syncOutbox.lastError);
        await m.addColumn(syncOutbox, syncOutbox.baseJson);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

/// Base de dados única da app; fechada quando o provider é descartado.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.persistent();
  ref.onDispose(db.close);
  return db;
});
