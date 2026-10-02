import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/card_repository.dart';
import '../models/card_model.dart';

class ApiCardRepository implements CardRepository {
  ApiCardRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<CardModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? q,
    CardStatus? status,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/cards',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        if (q != null && q.trim().isNotEmpty) 'q': q.trim(),
        if (status != null) 'filter[status]': status.name,
      },
    );
    return ApiEnvelope.page(response, CardModel.fromJson);
  });

  Future<Result<CardModel>> _post(String path, Map<String, dynamic> data) =>
      Result.guard(() async {
        final response = await _client.dio.post<dynamic>(path, data: data);
        return ApiEnvelope.object(response, CardModel.fromJson);
      });

  @override
  Future<Result<CardModel>> issue({
    required String uid,
    required String holderId,
    required String holderName,
    required CardHolderType holderType,
  }) => _post('/v1/cards', {
    'uid': uid,
    'holderId': holderId,
    'holderName': holderName,
    'holderType': holderType.name,
  });

  @override
  Future<Result<CardModel>> block(String id) =>
      _post('/v1/cards/$id/block', {});

  @override
  Future<Result<CardModel>> replace(String id, {required String uid}) =>
      _post('/v1/cards/$id/replace', {'uid': uid});

  @override
  Future<Result<CardModel>> associate(
    String id, {
    required String holderId,
    required String holderName,
    required CardHolderType holderType,
  }) => _post('/v1/cards/$id/associate', {
    'holderId': holderId,
    'holderName': holderName,
    'holderType': holderType.name,
  });
}
