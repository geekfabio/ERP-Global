import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/security/permission_providers.dart';
import '../../data/mock_api/rules_mock_handlers.dart';
import '../../data/models/setting_model.dart';
import '../../data/repositories/api_rules_repository.dart';
import '../../domain/rules_repository.dart';

final rulesRepositoryProvider = Provider<RulesRepository>(
  (ref) => ApiRulesRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock do módulo, registados em `main.dart` (só com mock activo).
final rulesMockHandlersProvider = Provider<RulesMockHandlers>(
  (ref) =>
      RulesMockHandlers(permissions: () => ref.read(permissionServiceProvider)),
);

/// Regras de um módulo; refaz-se quando a sessão muda.
final rulesProvider = FutureProvider.family<List<SettingModel>, SettingModule>((
  ref,
  module,
) async {
  ref.watch(permissionServiceProvider);
  return (await ref.watch(rulesRepositoryProvider).settings(module))
      .getOrThrow();
}, retry: (_, _) => null);
