import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/modules/module_catalog.dart';
import '../../domain/license_service.dart';

final licenseStoreProvider = Provider<LicenseStore>(
  (ref) => SecureLicenseStore(),
);

/// Serviço de licenciamento (offline). Chamar `load()` ao arrancar.
final licenseServiceProvider = Provider<LicenseService>(
  (ref) => LicenseService(
    store: ref.watch(licenseStoreProvider),
    registry: ref.watch(moduleRegistryProvider),
  ),
);
