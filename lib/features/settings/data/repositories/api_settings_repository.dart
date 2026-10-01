import 'dart:convert';
import 'dart:typed_data';

import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/settings_repository.dart';
import '../models/campus_model.dart';
import '../models/institution_model.dart';

class ApiSettingsRepository implements SettingsRepository {
  ApiSettingsRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<InstitutionModel>> institution() => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.get<dynamic>('/v1/institutions/current'),
      InstitutionModel.fromJson,
    ),
  );

  @override
  Future<Result<InstitutionModel>> updateInstitution(
    Map<String, dynamic> values,
  ) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.patch<dynamic>(
        '/v1/institutions/current',
        data: values,
      ),
      InstitutionModel.fromJson,
    ),
  );

  @override
  Future<Result<InstitutionModel>> uploadLogo(Uint8List bytes) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.post<dynamic>(
        '/v1/institutions/current/logo',
        data: {'content': base64Encode(bytes)},
      ),
      InstitutionModel.fromJson,
    ),
  );

  @override
  Future<Result<PagedList<CampusModel>>> campuses({
    int page = 1,
    int pageSize = 100,
  }) => Result.guard(
    () async => ApiEnvelope.page(
      await _client.dio.get<dynamic>(
        '/v1/campuses',
        queryParameters: {'page': page, 'pageSize': pageSize, 'sort': 'name'},
      ),
      CampusModel.fromJson,
    ),
  );

  @override
  Future<Result<CampusModel>> saveCampus(
    Map<String, dynamic> values, {
    String? id,
  }) => Result.guard(() async {
    final response = id == null
        ? await _client.dio.post<dynamic>('/v1/campuses', data: values)
        : await _client.dio.patch<dynamic>('/v1/campuses/$id', data: values);
    return ApiEnvelope.object(response, CampusModel.fromJson);
  });

  @override
  Future<Result<void>> deleteCampus(String id) => Result.guard(() async {
    await _client.dio.delete<dynamic>('/v1/campuses/$id');
  });
}
