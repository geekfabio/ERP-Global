import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/access_log_repository.dart';
import '../models/access_log_model.dart';
import '../models/access_models.dart';

class ApiAccessLogRepository implements AccessLogRepository {
  ApiAccessLogRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<AccessLogModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? zoneId,
    bool? allowed,
  }) => Result.guard(
    () async => ApiEnvelope.page(
      await _client.dio.get<dynamic>(
        '/v1/access-logs',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          'sort': '-occurredAt',
          'filter[zoneId]': ?zoneId,
          'filter[allowed]': ?allowed?.toString(),
        },
      ),
      AccessLogModel.fromJson,
    ),
  );

  @override
  Future<Result<AccessLogModel>> record(AccessLogModel log) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.post<dynamic>('/v1/access-logs', data: log.toBody()),
      AccessLogModel.fromJson,
    ),
  );
}

/// Resolve cartões, alunos e encarregados pelos endpoints dos respectivos
/// módulos (`/v1/cards`, `/v1/students`), sem importar os seus internals.
class ApiAccessHolderResolver implements AccessHolderResolver {
  ApiAccessHolderResolver(this._client);

  final ApiClient _client;

  Future<Object?> _get(String path, [Map<String, dynamic>? query]) async =>
      ApiEnvelope.data(
        await _client.dio.get<dynamic>(path, queryParameters: query),
      );

  Future<Map<dynamic, dynamic>?> _tryGet(String path) async {
    final result = await Result.guard(() => _get(path));
    return result.valueOrNull as Map?;
  }

  @override
  Future<Result<AccessHolder?>> byCardUid(String uid) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/cards',
      queryParameters: {'q': uid, 'pageSize': 50},
    );
    final cards = ApiEnvelope.data(response)! as List;
    final card = cards.cast<Map<String, dynamic>>().firstWhere(
      (c) => c['uid'] == uid,
      orElse: () => const {},
    );
    if (card.isEmpty) return null;

    final holderId = card['holderId'] as String;
    final blocked = card['status'] != 'active';
    if (card['holderType'] != 'student') {
      return AccessHolder(
        id: holderId,
        name: card['holderName'] as String,
        subject: AccessSubject.staff,
        cardBlocked: blocked,
      );
    }
    // Titular sem ficha de aluno (ex.: cartão importado): sem restrições.
    final student = await _tryGet('/v1/students/$holderId');
    final finance = await _tryGet('/v1/students/$holderId/finance');
    final charges = ((finance?['charges'] as List?) ?? const []).cast<Map>();
    return AccessHolder(
      id: holderId,
      name: card['holderName'] as String,
      subject: AccessSubject.student,
      cardBlocked: blocked,
      studentActive: student == null || student['status'] == 'active',
      financialClear: !charges.any((c) => c['status'] == 'overdue'),
    );
  });

  @override
  Future<Result<List<String>>> guardianUserIds(String studentId) =>
      Result.guard(() async {
        final items =
            (await _get('/v1/students/$studentId/guardians'))! as List;
        final now = DateTime.now().toUtc();
        final ids = <String>{};
        for (final item in items.cast<Map>()) {
          final guardian = item['guardian'] as Map;
          final link = item['link'] as Map;
          final until = link['validUntil'] as String?;
          final userId = guardian['userId'] as String?;
          final expired = until != null && DateTime.parse(until).isBefore(now);
          if (userId != null && !expired) ids.add(userId);
        }
        return ids.toList();
      });
}
