import 'package:dio/dio.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/rules_repository.dart';
import '../models/setting_model.dart';

class ApiRulesRepository implements RulesRepository {
  ApiRulesRepository(this._client);

  final ApiClient _client;

  List<SettingModel> _parse(Response<dynamic> response) =>
      (ApiEnvelope.data(response)! as List)
          .cast<Map<String, dynamic>>()
          .map(SettingModel.fromJson)
          .toList(growable: false);

  @override
  Future<Result<List<SettingModel>>> settings(SettingModule module) =>
      Result.guard(
        () async => _parse(
          await _client.dio.get<dynamic>(
            '/v1/settings',
            queryParameters: {'module': module.name},
          ),
        ),
      );

  @override
  Future<Result<List<SettingModel>>> save(
    SettingModule module,
    Map<String, Object> values,
  ) => Result.guard(
    () async => _parse(
      await _client.dio.patch<dynamic>(
        '/v1/settings/${module.name}',
        data: {'values': values},
      ),
    ),
  );
}
