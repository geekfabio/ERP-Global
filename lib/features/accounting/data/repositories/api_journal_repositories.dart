import 'package:dio/dio.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/json_converters.dart';
import '../../domain/journal_repositories.dart';
import '../models/journal_models.dart';

const _date = DateOnlyConverter();

Map<String, dynamic> _period(DateTime? from, DateTime? to) => {
  if (from != null) 'from': _date.toJson(from),
  if (to != null) 'to': _date.toJson(to),
};

Future<Result<T>> _call<T>(
  ApiClient client,
  String method,
  String path,
  T Function(Map<String, dynamic>) fromJson, {
  Map<String, dynamic>? data,
  Map<String, dynamic>? query,
}) => Result.guard(() async {
  final response = await client.dio.request<dynamic>(
    path,
    data: data,
    queryParameters: query,
    options: Options(method: method),
  );
  return ApiEnvelope.object(response, fromJson);
});

class ApiJournalRepository implements JournalRepository {
  ApiJournalRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<JournalEntryModel>>> list({
    int page = 1,
    int pageSize = 50,
    DateTime? from,
    DateTime? to,
    String? accountId,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/journal-entries',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        ..._period(from, to),
        'accountId': ?accountId,
      },
    );
    return ApiEnvelope.page(response, JournalEntryModel.fromJson);
  });

  @override
  Future<Result<JournalEntryModel>> create(JournalEntryModel entry) => _call(
    _client,
    'POST',
    '/v1/journal-entries',
    JournalEntryModel.fromJson,
    data: entry.toJson(),
  );

  @override
  Future<Result<JournalEntryModel>> reverse(String id) => _call(
    _client,
    'POST',
    '/v1/journal-entries/$id/reverse',
    JournalEntryModel.fromJson,
    data: const {},
  );

  @override
  Future<Result<LedgerModel>> ledger(
    String accountId, {
    DateTime? from,
    DateTime? to,
  }) => _call(
    _client,
    'GET',
    '/v1/ledger',
    LedgerModel.fromJson,
    query: {'accountId': accountId, ..._period(from, to)},
  );

  @override
  Future<Result<TrialBalanceModel>> trialBalance({
    DateTime? from,
    DateTime? to,
  }) => _call(
    _client,
    'GET',
    '/v1/trial-balance',
    TrialBalanceModel.fromJson,
    query: _period(from, to),
  );

  @override
  Future<Result<JournalEntryModel>> postBillingEvent(BillingEventModel event) =>
      _call(
        _client,
        'POST',
        '/v1/journal-entries/billing-events',
        JournalEntryModel.fromJson,
        data: event.toJson(),
      );
}

class ApiOpenItemRepository implements OpenItemRepository {
  ApiOpenItemRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<OpenItemModel>>> list({
    int page = 1,
    int pageSize = 50,
    OpenItemKind? kind,
    OpenItemStatus? status,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/open-items',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'filter[kind]': ?kind?.name,
        'filter[status]': ?status?.name,
      },
    );
    return ApiEnvelope.page(response, OpenItemModel.fromJson);
  });

  @override
  Future<Result<OpenItemModel>> create(OpenItemModel item) => _call(
    _client,
    'POST',
    '/v1/open-items',
    OpenItemModel.fromJson,
    data: item.toJson(),
  );

  @override
  Future<Result<OpenItemModel>> settle(
    String id, {
    required int amountMinor,
    required DateTime date,
    required String cashAccountId,
  }) => _call(
    _client,
    'POST',
    '/v1/open-items/$id/settle',
    OpenItemModel.fromJson,
    data: {
      'amountMinor': amountMinor,
      'date': _date.toJson(date),
      'cashAccountId': cashAccountId,
    },
  );
}
