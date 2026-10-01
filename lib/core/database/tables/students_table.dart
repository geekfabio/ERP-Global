import 'package:drift/drift.dart';

import 'sync_columns.dart';

/// Alunos (espelho local de `StudentModel`). Enums guardados como texto
/// `snake_case` (igual ao JSON) e a ficha de saúde como JSON.
@DataClassName('StudentRow')
class Students extends Table with SyncColumns {
  TextColumn get processNumber => text()();
  TextColumn get fullName => text()();

  /// `fullName` sem acentos/maiúsculas, para pesquisa e ordenação.
  TextColumn get searchText => text()();
  TextColumn get photoUrl => text().nullable()();
  DateTimeColumn get birthDate => dateTime()();
  TextColumn get birthPlace => text().nullable()();
  TextColumn get gender => text()();
  TextColumn get nationality =>
      text().withDefault(const Constant('Angolana'))();
  TextColumn get idNumber => text().nullable()();
  TextColumn get nif => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get originSchool => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get healthJson => text().withDefault(const Constant('{}'))();
}

/// Fila de alterações locais por enviar (outbox) para o futuro motor de sync.
@DataClassName('OutboxRow')
class SyncOutbox extends Table {
  IntColumn get seq => integer().autoIncrement()();
  TextColumn get entity => text()();
  TextColumn get entityId => text()();

  /// `create` | `update` | `delete`.
  TextColumn get operation => text()();
  TextColumn get payload => text().withDefault(const Constant('{}'))();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();

  /// `pending` | `error` (ver `core/sync`). Entradas em erro esperam acção do utilizador.
  TextColumn get status => text().withDefault(const Constant('pending'))();

  /// Última mensagem de erro (pt-AO) quando [status] é `error`.
  TextColumn get lastError => text().nullable()();

  /// Cópia do registo como estava na última sincronização (base do merge por campo).
  TextColumn get baseJson => text().nullable()();
}
