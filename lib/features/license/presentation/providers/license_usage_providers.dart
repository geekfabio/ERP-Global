import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/security/permission_service.dart';
import '../../data/mock_api/license_mock_handlers.dart';
import '../../data/models/license_usage.dart';
import '../../data/repositories/api_license_repository.dart';
import '../../domain/license_repository.dart';

final licenseRepositoryProvider = Provider<LicenseRepository>(
  (ref) => ApiLicenseRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock da licença; `main.dart` liga o consumo aos outros módulos.
final licenseMockHandlersProvider = Provider<LicenseMockHandlers>(
  (ref) => LicenseMockHandlers(),
);

/// Consumo (alunos/campus/utilizadores/dispositivos) lido pela API.
final licenseUsageProvider = FutureProvider.autoDispose<LicenseUsage>(
  (ref) async =>
      (await ref.watch(licenseRepositoryProvider).usage()).getOrThrow(),
);

/// Só `super_admin` (`*`) ou quem tem `license.activate` instala licenças.
/// Não depende do modo só leitura: é precisamente aí que é preciso renovar.
final canActivateLicenseProvider = Provider<bool>((ref) {
  final codes = ref.watch(sessionPermissionsProvider);
  return codes != null &&
      PermissionService.fromCodes(codes).canAny('license.activate');
});
