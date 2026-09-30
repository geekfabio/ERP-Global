import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/modules/license_gate.dart';
import 'core/network/api_client.dart';
import 'core/security/permission_providers.dart';
import 'features/auth/presentation/providers/auth_providers.dart';
import 'features/auth/presentation/providers/auth_state.dart';
import 'features/license/presentation/providers/license_providers.dart';
import 'features/students/presentation/providers/student_providers.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        tokenStoreProvider.overrideWith(
          (ref) => ref.watch(persistentTokenStoreProvider),
        ),
        // O `core` não conhece `features/`: liga as permissões à sessão de auth.
        sessionPermissionsProvider.overrideWith(
          (ref) => ref.watch(currentSessionProvider)?.permissions,
        ),
        // Liga o gate de licença do core ao serviço de licenciamento.
        licenseGateProvider.overrideWith(
          (ref) => ref.watch(licenseGateFromServiceProvider),
        ),
        // Módulos com API mock; só têm efeito com `AppConfig.useMockApi`.
        mockApiModulesProvider.overrideWith(
          (ref) => [
            ref.watch(authMockHandlersProvider),
            ref.watch(studentsMockHandlersProvider),
          ],
        ),
      ],
      child: const ErpGlobalApp(),
    ),
  );
}
