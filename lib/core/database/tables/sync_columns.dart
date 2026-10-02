import 'package:drift/drift.dart';

/// Estados de sincronização de um registo local (docs/06-modelo-de-dados.md).
enum SyncState { synced, pendingCreate, pendingUpdate, pendingDelete }

/// Colunas comuns a todas as entidades persistidas: id ULID gerado no cliente,
/// datas em UTC, remoção lógica e estado de sync.
mixin SyncColumns on Table {
  TextColumn get id => text().withLength(min: 26, max: 26)();
  TextColumn get institutionId => text()();
  TextColumn get campusId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncState => text().withDefault(const Constant('synced'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
