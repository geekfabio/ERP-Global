import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/network/mock/mock_reference_data.dart';
import '../../domain/renewal_repository.dart';
import '../../domain/renewal_rules.dart';
import '../models/enrollment_model.dart';

/// Renovação em massa. O que é do módulo de matrículas vem de
/// `/v1/enrollment-renewals`; o resultado final vem do contrato HTTP das
/// pautas (`/v1/class-councils`) e a ordem das classes de `/v1/grades`, sem
/// importar código desses módulos (AGENTS.md §2).
class ApiRenewalRepository implements RenewalRepository {
  ApiRenewalRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<List<RenewalYear>>> years() => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/academic-years',
      queryParameters: {'pageSize': 100, 'sort': 'code'},
    );
    return [
      for (final y in ApiEnvelope.page(response, RenewalYear.fromJson).items) y,
    ];
  });

  /// Ids das classes por ordem crescente.
  Future<List<String>> _orderedGrades() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/grades',
      queryParameters: {'pageSize': 100},
    );
    final raw = ApiEnvelope.page(
      response,
      (j) => (id: j['id'] as String, order: (j['order'] as num?)?.toInt() ?? 0),
    ).items.toList()..sort((a, b) => a.order.compareTo(b.order));
    final ids = [for (final g in raw) g.id];
    // Dados mock: o seed académico gera ids próprios; a matrícula usa os ids
    // de referência partilhados (`MockRef`), que seguem a ordem das classes.
    if (!ids.contains(MockRef.gradeId(1))) {
      return [for (var i = 0; i < MockRef.gradeCount; i++) MockRef.gradeId(i)];
    }
    return ids;
  }

  /// `alunoId → resultado`: o da pauta aprovada, com a decisão do conselho
  /// de turma a prevalecer. Sem acesso às pautas, nada é sugerido.
  Future<Map<String, String>> _results(
    String classroomId,
    String yearId,
  ) async {
    try {
      final response = await _client.dio.get<dynamic>(
        '/v1/class-councils',
        queryParameters: {'classroomId': classroomId, 'yearId': yearId},
      );
      final council = ApiEnvelope.object(response, (j) => j);
      return {
        for (final e in ((council['results'] as Map?) ?? const {}).entries)
          e.key as String: e.value as String,
        for (final d in (council['decisions'] as List?) ?? const [])
          (d as Map)['studentId'] as String: d['result'] as String,
      };
    } on Object {
      return const {};
    }
  }

  @override
  Future<Result<RenewalPreview>> preview({
    required String sourceYearId,
    required String targetYearId,
    required String classroomId,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/enrollment-renewals/preview',
      queryParameters: {
        'sourceYearId': sourceYearId,
        'targetYearId': targetYearId,
        'classroomId': classroomId,
      },
    );
    final raw = ApiEnvelope.data(response)! as List;
    final order = await _orderedGrades();
    final results = await _results(classroomId, sourceYearId);
    return RenewalPreview(
      rows: [
        for (final item in raw.cast<Map<String, dynamic>>())
          _row(item, order, results),
      ],
      gradeOrder: order,
    );
  });

  RenewalRow _row(
    Map<String, dynamic> item,
    List<String> order,
    Map<String, String> results,
  ) {
    final enrollment = EnrollmentModel.fromJson(
      item['enrollment'] as Map<String, dynamic>,
    );
    final result = results[enrollment.studentId];
    final action = defaultRenewalAction(result);
    return RenewalRow(
      enrollment: enrollment,
      studentName: item['studentName'] as String,
      processNumber: item['processNumber'] as String,
      alreadyRenewed: item['alreadyRenewed'] as bool,
      result: result,
      action: action,
      targetGradeId: targetGradeFor(action, enrollment.gradeId, order),
    );
  }

  @override
  Future<Result<RenewalOutcome>> apply({
    required String sourceYearId,
    required String targetYearId,
    required List<RenewalItem> items,
  }) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/enrollment-renewals',
      data: {
        'sourceYearId': sourceYearId,
        'targetYearId': targetYearId,
        'items': [for (final i in items) i.toJson()],
      },
    );
    return ApiEnvelope.object(response, RenewalOutcome.fromJson);
  });
}
