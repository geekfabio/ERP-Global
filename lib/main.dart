import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/network/api_client.dart';
import 'features/auth/presentation/providers/auth_providers.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        tokenStoreProvider.overrideWith(
          (ref) => ref.watch(persistentTokenStoreProvider),
        ),
        // Módulos com API mock; só têm efeito com `AppConfig.useMockApi`.
        mockApiModulesProvider.overrideWith(
          (ref) => [ref.watch(authMockHandlersProvider)],
        ),
      ],
      child: const ErpGlobalApp(),
    ),
  );
}
