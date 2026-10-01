import 'dart:async';

import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/security/permission_service.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../domain/grade_entry_repository.dart';
import '../models/assessment_scheme_model.dart';
import '../models/grade_sheet_models.dart';

/// Estado de um trimestre, conhecido pelo servidor (módulo académico).
class GradeTermInfo {
  const GradeTermInfo({required this.closed, this.deadline});

  final bool closed;

  /// Último dia (inclusive) para lançar notas.
  final DateTime? deadline;
}

typedef GradeTermLookup = FutureOr<GradeTermInfo?> Function(String termId);

/// Diz se o utilizador lecciona a disciplina na turma (o servidor real resolve
/// pelas atribuições do professor).
typedef GradeEntryAccess =
    FutureOr<bool> Function(String classroomId, String subjectId);

/// Handlers de `/v1/grade-sheets` (lançamento de notas): valida a escala,
/// bloqueia trimestre fechado/prazo terminado, exige `approve` + justificação
/// para editar com a folha bloqueada e guarda o log de alterações.
class GradeEntryMockHandlers implements MockApiModule {
  GradeEntryMockHandlers({
    required this.schemes,
    this.permissions,
    this.termLookup,
    this.access,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  /// Esquemas de avaliação em vigor (partilhados com `GradesMockHandlers`).
  final Iterable<AssessmentSchemeModel> Function() schemes;
  final PermissionService Function()? permissions;
  final GradeTermLookup? termLookup;

  /// Restrição às disciplinas atribuídas; `null` = sem restrição. Quem aprova
  /// (`approve`) vê todas as turmas.
  final GradeEntryAccess? access;
  final DateTime Function() _now;

  /// `classroom|subject|term|student → componente → nota`.
  final Map<String, Map<String, double>> _scores = {};
  final List<GradeChangeModel> _changes = [];
  final SeedGenerator _ids = SeedGenerator(471);

  void reset() {
    _scores.clear();
    _changes.clear();
  }

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(reset)
      ..get('/v1/grade-sheets', _get)
      ..put('/v1/grade-sheets', _put)
      ..get('/v1/grade-sheets/changes', _list);
  }

  bool _can(String permission) =>
      permissions?.call().canAny(permission) ?? true;

  static String _slot(Map<String, dynamic> k, String student) =>
      '${k['classroomId']}|${k['subjectId']}|${k['termId']}|$student';

  Future<void> _requireAccess(Map<String, dynamic> k) async {
    if (access == null || _can(gradeEntryApprovePermission)) return;
    if (!await access!('${k['classroomId']}', '${k['subjectId']}')) {
      throw const MockApiException.forbidden(
        'Disciplina não atribuída ao professor nesta turma',
      );
    }
  }

  static void _requireKey(Map<String, dynamic> k) {
    final errors = {
      for (final f in ['classroomId', 'subjectId', 'termId'])
        if ('${k[f] ?? ''}'.isEmpty) f: 'Campo obrigatório',
    };
    if (errors.isNotEmpty) throw MockApiException.validation(errors);
  }

  AssessmentSchemeModel _scheme(Map<String, dynamic> k) {
    final all = schemes().toList();
    AssessmentSchemeModel? pick(bool Function(AssessmentSchemeModel) test) =>
        all.where(test).firstOrNull;
    final gradeId = k['gradeId'] as String?;
    final courseId = k['courseId'] as String?;
    return (gradeId != null && courseId != null
            ? pick((s) => s.gradeId == gradeId && s.courseId == courseId)
            : null) ??
        (gradeId == null
            ? null
            : pick((s) => s.gradeId == gradeId && s.courseId == null)) ??
        (courseId == null
            ? null
            : pick((s) => s.courseId == courseId && s.gradeId == null)) ??
        pick((s) => s.gradeId == null && s.courseId == null) ??
        (throw const MockApiException.notFound(
          'Sem esquema de avaliação para esta turma',
        ));
  }

  static String _date(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<GradeSheetModel> _sheet(Map<String, dynamic> k) async {
    final info = await termLookup?.call(k['termId'] as String);
    final deadline = info?.deadline;
    final prefix = '${k['classroomId']}|${k['subjectId']}|${k['termId']}|';
    final rows = [
      for (final e in _scores.entries)
        if (e.key.startsWith(prefix) && e.value.isNotEmpty)
          GradeRowModel(
            studentId: e.key.substring(prefix.length),
            scores: Map.of(e.value),
          ),
    ];
    return GradeSheetModel(
      classroomId: k['classroomId'] as String,
      subjectId: k['subjectId'] as String,
      termId: k['termId'] as String,
      scheme: _scheme(k),
      termClosed: info?.closed ?? false,
      deadline: deadline == null ? null : _date(deadline),
      deadlinePassed:
          deadline != null &&
          _now().toUtc().isAfter(
            DateTime.utc(
              deadline.year,
              deadline.month,
              deadline.day,
            ).add(const Duration(days: 1)),
          ),
      rows: rows,
    );
  }

  Future<MockResponse> _get(MockRequest q) async {
    if (!_can(gradeEntryReadPermission) &&
        !_can(gradeEntryWritePermission) &&
        !_can(gradeEntryApprovePermission)) {
      throw const MockApiException.forbidden();
    }
    _requireKey(q.query);
    await _requireAccess(q.query);
    return MockResponse.ok((await _sheet(q.query)).toJson());
  }

  Future<MockResponse> _put(MockRequest q) async {
    final body = q.jsonBody;
    final approver = _can(gradeEntryApprovePermission);
    if (!_can(gradeEntryWritePermission) && !approver) {
      throw const MockApiException.forbidden();
    }
    _requireKey(body);
    await _requireAccess(body);
    final sheet = await _sheet(body);
    final List<GradeRowModel> rows;
    try {
      rows = [
        for (final r in body['rows'] as List<dynamic>? ?? const [])
          GradeRowModel.fromJson(r as Map<String, dynamic>),
      ];
    } on Object {
      throw const MockApiException.validation({'rows': 'Dados inválidos'});
    }

    final errors = <String, String>{};
    final codes = {for (final c in sheet.scheme.components) c.code};
    for (final row in rows) {
      for (final e in row.scores.entries) {
        final field = '${row.studentId}.${e.key}';
        if (!codes.contains(e.key)) {
          errors[field] = 'Componente desconhecido';
        } else if (e.value.isNaN ||
            e.value < 0 ||
            e.value > sheet.scheme.scaleMax) {
          errors[field] = 'Nota entre 0 e ${sheet.scheme.scaleMax}';
        }
      }
    }
    if (errors.isNotEmpty) throw MockApiException.validation(errors);

    final at = _now().toUtc();
    final pending = <GradeChangeModel>[];
    final next = <String, Map<String, double>>{};
    final justification = (body['justification'] as String?)?.trim();
    for (final row in rows) {
      final slot = _slot(body, row.studentId);
      final current = _scores[slot] ?? const <String, double>{};
      final merged = <String, double>{...row.scores};
      next[slot] = merged;
      for (final code in {...current.keys, ...merged.keys}) {
        final before = current[code];
        final after = merged[code];
        if (before == after) continue;
        pending.add(
          GradeChangeModel(
            id: _ids.ulid(at),
            classroomId: sheet.classroomId,
            subjectId: sheet.subjectId,
            termId: sheet.termId,
            studentId: row.studentId,
            componentCode: code,
            before: before,
            after: after,
            afterLock: sheet.locked,
            justification: sheet.locked ? justification : null,
            changedAt: at,
          ),
        );
      }
    }

    if (pending.isNotEmpty && sheet.locked) {
      if (!approver) {
        throw MockApiException.conflict(
          sheet.termClosed
              ? 'Trimestre fechado: só quem aprova pode alterar notas'
              : 'Prazo de lançamento terminado: só quem aprova pode alterar notas',
        );
      }
      if (justification == null || justification.isEmpty) {
        throw const MockApiException.validation({
          'justification': 'Indique a justificação da alteração',
        });
      }
    }
    _scores.addAll(next);
    _changes.addAll(pending);
    return MockResponse.ok((await _sheet(body)).toJson());
  }

  Future<MockResponse> _list(MockRequest q) async {
    if (!_can(gradeEntryReadPermission) &&
        !_can(gradeEntryWritePermission) &&
        !_can(gradeEntryApprovePermission)) {
      throw const MockApiException.forbidden();
    }
    _requireKey(q.query);
    await _requireAccess(q.query);
    final rows = [
      for (final c in _changes.reversed)
        if (c.classroomId == q.query['classroomId'] &&
            c.subjectId == q.query['subjectId'] &&
            c.termId == q.query['termId'])
          c,
    ];
    return mockPaginate(rows, q, toJson: (c) => c.toJson());
  }
}
