import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/license_repository.dart';
import '../models/license_usage.dart';

class ApiLicenseRepository implements LicenseRepository {
  ApiLicenseRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<LicenseUsage>> usage() => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.get<dynamic>('/v1/license/usage'),
      LicenseUsage.fromJson,
    ),
  );
}
