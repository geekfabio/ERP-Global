import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/mock_api/auth_mock_handlers.dart';
import '../../data/repositories/api_auth_repository.dart';
import '../../data/repositories/session_storage.dart';
import '../../domain/auth_repository.dart';

final sessionStorageProvider = Provider<SessionStorage>(
  (ref) => SecureSessionStorage(),
);

/// Substitui o `tokenStoreProvider` do core por um que persiste o refresh token.
final persistentTokenStoreProvider = Provider<TokenStore>(
  (ref) => PersistentTokenStore(ref.watch(sessionStorageProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => ApiAuthRepository(
    ref.watch(apiClientProvider),
    ref.watch(sessionStorageProvider),
  ),
);

/// Handlers mock de auth, registados em `mockApiModulesProvider` (só com mock activo).
final authMockHandlersProvider = Provider<AuthMockHandlers>(
  (ref) => AuthMockHandlers(),
);
