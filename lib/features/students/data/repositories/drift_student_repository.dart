import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/students_table.dart';
import '../../../../core/database/tables/sync_columns.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/network/mock/mock_query.dart' show foldText;
import '../../domain/student_duplicates.dart';
import '../../domain/student_repositories.dart';
import '../models/student_model.dart';

/// [StudentRepository] sobre SQLite local (Drift). Escreve também na outbox
/// (`sync_outbox`) para o futuro motor de sync.
///
/// Limitação conhecida: `StudentQuery.gradeId/classroomId` exigem a tabela de
/// matrículas (ainda só existe via API) e são ignorados aqui.
class DriftStudentRepository implements StudentRepository {
  DriftStudentRepository(this._db);

  final AppDatabase _db;

  static const _maxPageSize = 100;

  @override
  Future<Result<PagedList<StudentModel>>> list(
    StudentQuery q,
  ) => Result.guard(() async {
    final page = q.page < 1 ? 1 : q.page;
    final pageSize = q.pageSize.clamp(1, _maxPageSize);
    final needle = foldText(q.q?.trim() ?? '');
    final status = q.status == null ? null : _snake(q.status!.name);

    Expression<bool> where(Students s) {
      Expression<bool> e = s.deletedAt.isNull();
      if (needle.isNotEmpty) {
        e = e & s.searchText.like('%${_escapeLike(needle)}%', escapeChar: r'\');
      }
      if (status != null) e = e & s.status.equals(status);
      if (q.gender != null) e = e & s.gender.equals(q.gender!.name);
      return e;
    }

    final countExp = _db.students.id.count();
    final total =
        await (_db.selectOnly(_db.students)
              ..addColumns([countExp])
              ..where(where(_db.students)))
            .map((r) => r.read(countExp)!)
            .getSingle();

    final rows =
        await (_db.select(_db.students)
              ..where(where)
              ..orderBy([for (final k in q.sort) _order(k)])
              ..limit(pageSize, offset: (page - 1) * pageSize))
            .get();

    return PagedList(
      items: rows.map(_toModel).toList(),
      meta: PageMeta(page: page, pageSize: pageSize, total: total),
    );
  });

  @override
  Future<Result<StudentModel>> get(String id) => Result.guard(() async {
    final row = await _find(id);
    if (row == null) throw _notFound();
    return _toModel(row);
  });

  @override
  Future<Result<StudentModel>> create(
    StudentModel student, {
    bool confirmDuplicate = false,
  }) => Result.guard(() async {
    return _db.transaction(() async {
      if (await _findAny(student.id) != null) {
        throw UnknownFailure(
          code: 'CONFLICT',
          message: 'Identificador já existe',
        );
      }
      final found = await _duplicates(
        fullName: student.fullName,
        birthDate: student.birthDate,
        idNumber: student.idNumber,
      );
      if (found.any((d) => d.blocking)) {
        throw UnknownFailure(
          code: 'CONFLICT',
          message: 'Já existe um aluno com este BI',
        );
      }
      if (found.isNotEmpty && !confirmDuplicate) {
        throw UnknownFailure(
          code: 'CONFLICT',
          message: 'Já existe um aluno com o mesmo nome e data de nascimento',
        );
      }
      final now = DateTime.now().toUtc();
      final saved = student.copyWith(
        createdAt: now,
        updatedAt: now,
        syncState: SyncState.pendingCreate.name,
      );
      await _db.into(_db.students).insert(_toCompanion(saved));
      await _enqueue('create', saved);
      return saved;
    });
  });

  @override
  Future<Result<List<StudentDuplicate>>> findDuplicates({
    required String fullName,
    required DateTime birthDate,
    String? idNumber,
  }) => Result.guard(
    () => _duplicates(
      fullName: fullName,
      birthDate: birthDate,
      idNumber: idNumber,
    ),
  );

  Future<List<StudentDuplicate>> _duplicates({
    required String fullName,
    required DateTime birthDate,
    String? idNumber,
  }) async {
    final rows = await (_db.select(
      _db.students,
    )..where((s) => s.deletedAt.isNull())).get();
    return findStudentDuplicates(
      rows.map(_toModel),
      fullName: fullName,
      birthDate: birthDate,
      idNumber: idNumber,
    );
  }

  @override
  Future<Result<StudentModel>> update(
    StudentModel student,
  ) => Result.guard(() async {
    return _db.transaction(() async {
      final current = await _find(student.id);
      if (current == null) throw _notFound();
      await _assertUniqueIdNumber(student.idNumber, exceptId: student.id);
      // Um registo ainda não enviado continua a ser um `create` no servidor.
      final isCreate = current.syncState == SyncState.pendingCreate.name;
      final saved = student.copyWith(
        createdAt: current.createdAt.toUtc(),
        updatedAt: DateTime.now().toUtc(),
        deletedAt: null,
        syncState:
            (isCreate ? SyncState.pendingCreate : SyncState.pendingUpdate).name,
      );
      await (_db.update(
        _db.students,
      )..where((s) => s.id.equals(saved.id))).write(_toCompanion(saved));
      await _enqueue(isCreate ? 'create' : 'update', saved);
      return saved;
    });
  });

  @override
  Future<Result<void>> delete(String id) => Result.guard(() async {
    await _db.transaction(() async {
      if (await _find(id) == null) throw _notFound();
      final now = DateTime.now().toUtc();
      await (_db.update(_db.students)..where((s) => s.id.equals(id))).write(
        StudentsCompanion(
          deletedAt: Value(now),
          updatedAt: Value(now),
          syncState: Value(SyncState.pendingDelete.name),
        ),
      );
      await _db
          .into(_db.syncOutbox)
          .insert(
            SyncOutboxCompanion.insert(
              entity: 'student',
              entityId: id,
              operation: 'delete',
              createdAt: now,
            ),
          );
    });
  });

  // ---- helpers ----------------------------------------------------------

  Future<StudentRow?> _findAny(String id) => (_db.select(
    _db.students,
  )..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<StudentRow?> _find(String id) => (_db.select(
    _db.students,
  )..where((s) => s.id.equals(id) & s.deletedAt.isNull())).getSingleOrNull();

  Failure _notFound() =>
      UnknownFailure(code: 'NOT_FOUND', message: 'Aluno não encontrado');

  Future<void> _assertUniqueIdNumber(
    String? idNumber, {
    String? exceptId,
  }) async {
    if (idNumber == null || idNumber.isEmpty) return;
    final query = _db.select(_db.students)
      ..where((s) => s.idNumber.equals(idNumber) & s.deletedAt.isNull());
    if (exceptId != null) query.where((s) => s.id.equals(exceptId).not());
    if ((await query.get()).isNotEmpty) {
      throw UnknownFailure(
        code: 'CONFLICT',
        message: 'Já existe um aluno com este documento de identificação',
      );
    }
  }

  Future<void> _enqueue(String operation, StudentModel s) => _db
      .into(_db.syncOutbox)
      .insert(
        SyncOutboxCompanion.insert(
          entity: 'student',
          entityId: s.id,
          operation: operation,
          payload: Value(jsonEncode(s.toJson())),
          createdAt: DateTime.now().toUtc(),
        ),
      );

  OrderingTerm Function(Students) _order(String key) {
    final desc = key.startsWith('-');
    final field = desc ? key.substring(1) : key;
    final mode = desc ? OrderingMode.desc : OrderingMode.asc;
    return (s) => OrderingTerm(
      expression: switch (field) {
        'fullName' => s.searchText,
        'processNumber' => s.processNumber,
        'birthDate' => s.birthDate,
        'createdAt' => s.createdAt,
        _ => throw UnknownFailure(
          code: 'BAD_REQUEST',
          message: 'Campo de ordenação inválido',
        ),
      },
      mode: mode,
    );
  }

  static String _escapeLike(String v) =>
      v.replaceAllMapped(RegExp(r'[\\%_]'), (m) => '\\${m[0]}');

  /// `snake_case` como no JSON (`transferred`, `dropout`…).
  static String _snake(String name) =>
      name.replaceAllMapped(RegExp('[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

  StudentsCompanion _toCompanion(StudentModel s) {
    final json = s.toJson();
    return StudentsCompanion(
      id: Value(s.id),
      institutionId: Value(s.institutionId),
      campusId: Value(s.campusId),
      createdAt: Value(s.createdAt),
      updatedAt: Value(s.updatedAt),
      deletedAt: Value(s.deletedAt),
      syncState: Value(s.syncState),
      processNumber: Value(s.processNumber),
      fullName: Value(s.fullName),
      searchText: Value(
        foldText('${s.fullName} ${s.processNumber} ${s.idNumber ?? ''}'),
      ),
      photoUrl: Value(s.photoUrl),
      birthDate: Value(s.birthDate),
      birthPlace: Value(s.birthPlace),
      gender: Value(json['gender']! as String),
      nationality: Value(s.nationality),
      idNumber: Value(s.idNumber),
      nif: Value(s.nif),
      address: Value(s.address),
      phone: Value(s.phone),
      email: Value(s.email),
      originSchool: Value(s.originSchool),
      status: Value(json['status']! as String),
      healthJson: Value(jsonEncode(json['health'])),
    );
  }

  StudentModel _toModel(StudentRow r) => StudentModel.fromJson({
    'id': r.id,
    'institutionId': r.institutionId,
    'campusId': r.campusId,
    'createdAt': r.createdAt.toUtc().toIso8601String(),
    'updatedAt': r.updatedAt.toUtc().toIso8601String(),
    'deletedAt': r.deletedAt?.toUtc().toIso8601String(),
    'syncState': r.syncState,
    'processNumber': r.processNumber,
    'fullName': r.fullName,
    'photoUrl': r.photoUrl,
    'birthDate': r.birthDate.toUtc().toIso8601String(),
    'birthPlace': r.birthPlace,
    'gender': r.gender,
    'nationality': r.nationality,
    'idNumber': r.idNumber,
    'nif': r.nif,
    'address': r.address,
    'phone': r.phone,
    'email': r.email,
    'originSchool': r.originSchool,
    'status': r.status,
    'health': jsonDecode(r.healthJson),
  });
}
