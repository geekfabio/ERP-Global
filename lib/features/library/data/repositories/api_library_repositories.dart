import 'package:dio/dio.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/library_repositories.dart';
import '../models/library_models.dart';

Map<String, dynamic> _query(
  int page,
  int pageSize, {
  String? q,
  Enum? status,
}) => {
  'page': page,
  'pageSize': pageSize,
  if (q != null && q.trim().isNotEmpty) 'q': q.trim(),
  if (status != null) 'filter[status]': status.wire,
};

Future<Result<T>> _send<T>(
  ApiClient client,
  String method,
  String path,
  T Function(Map<String, dynamic>) fromJson, {
  Map<String, dynamic>? data,
}) => Result.guard(() async {
  final response = await client.dio.request<dynamic>(
    path,
    data: data,
    options: Options(method: method),
  );
  return ApiEnvelope.object(response, fromJson);
});

Future<Result<PagedList<T>>> _page<T>(
  ApiClient client,
  String path,
  Map<String, dynamic> query,
  T Function(Map<String, dynamic>) fromJson,
) => Result.guard(() async {
  final response = await client.dio.get<dynamic>(path, queryParameters: query);
  return ApiEnvelope.page(response, fromJson);
});

class ApiBookRepository implements BookRepository {
  ApiBookRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<BookModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? q,
  }) => _page(
    _client,
    '/v1/library/books',
    _query(page, pageSize, q: q),
    BookModel.fromJson,
  );

  @override
  Future<Result<BookModel>> create(BookModel book, {int copies = 1}) => _send(
    _client,
    'POST',
    '/v1/library/books',
    BookModel.fromJson,
    data: {...book.toJson(), 'copies': copies},
  );

  @override
  Future<Result<List<CopyModel>>> copies(String bookId) =>
      Result.guard(() async {
        final response = await _client.dio.get<dynamic>(
          '/v1/library/books/$bookId/copies',
        );
        return [
          for (final c in ApiEnvelope.data(response)! as List)
            CopyModel.fromJson(c as Map<String, dynamic>),
        ];
      });

  @override
  Future<Result<CopyModel>> addCopy(String bookId, {required String barcode}) =>
      _send(
        _client,
        'POST',
        '/v1/library/books/$bookId/copies',
        CopyModel.fromJson,
        data: {'barcode': barcode},
      );

  @override
  Future<Result<CopyModel>> setCopyStatus(String copyId, CopyStatus status) =>
      _send(
        _client,
        'PATCH',
        '/v1/library/copies/$copyId',
        CopyModel.fromJson,
        data: {'status': status.wire},
      );
}

class ApiCirculationRepository implements CirculationRepository {
  ApiCirculationRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<LoanModel>>> loans({
    int page = 1,
    int pageSize = 20,
    String? q,
    LoanStatus? status,
  }) => _page(
    _client,
    '/v1/library/loans',
    _query(page, pageSize, q: q, status: status),
    LoanModel.fromJson,
  );

  @override
  Future<Result<LoanModel>> checkout({
    required String cardUid,
    required String barcode,
  }) => _send(
    _client,
    'POST',
    '/v1/library/loans',
    LoanModel.fromJson,
    data: {'cardUid': cardUid, 'barcode': barcode},
  );

  @override
  Future<Result<LoanModel>> giveBack(String loanId) => _send(
    _client,
    'POST',
    '/v1/library/loans/$loanId/return',
    LoanModel.fromJson,
    data: const {},
  );

  @override
  Future<Result<PagedList<FineModel>>> fines({
    int page = 1,
    int pageSize = 20,
    FineStatus? status,
  }) => _page(
    _client,
    '/v1/library/fines',
    _query(page, pageSize, status: status),
    FineModel.fromJson,
  );

  @override
  Future<Result<FineModel>> payFine(String fineId) => _send(
    _client,
    'POST',
    '/v1/library/fines/$fineId/pay',
    FineModel.fromJson,
    data: const {},
  );

  @override
  Future<Result<PagedList<ReservationModel>>> reservations({
    int page = 1,
    int pageSize = 20,
    ReservationStatus? status,
  }) => _page(
    _client,
    '/v1/library/reservations',
    _query(page, pageSize, status: status),
    ReservationModel.fromJson,
  );

  @override
  Future<Result<ReservationModel>> reserve({
    required String bookId,
    required String cardUid,
  }) => _send(
    _client,
    'POST',
    '/v1/library/reservations',
    ReservationModel.fromJson,
    data: {'bookId': bookId, 'cardUid': cardUid},
  );

  @override
  Future<Result<ReservationModel>> cancelReservation(String id) => _send(
    _client,
    'POST',
    '/v1/library/reservations/$id/cancel',
    ReservationModel.fromJson,
    data: const {},
  );
}
