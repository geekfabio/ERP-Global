import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/security/permission_providers.dart';
import '../../data/mock_api/settings_mock_handlers.dart';
import '../../data/models/campus_model.dart';
import '../../data/models/institution_model.dart';
import '../../data/repositories/api_settings_repository.dart';
import '../../domain/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => ApiSettingsRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock do módulo, registados em `main.dart` (só com mock activo).
final settingsMockHandlersProvider = Provider<SettingsMockHandlers>(
  (ref) => SettingsMockHandlers(
    permissions: () => ref.read(permissionServiceProvider),
  ),
);

/// Instituição actual; só é pedida a quem pode ler as definições. Refaz-se
/// quando a sessão muda (login/logout).
final institutionProvider = FutureProvider<InstitutionModel?>((ref) async {
  if (!ref.watch(permissionServiceProvider).canAny(settingsReadPermission)) {
    return null;
  }
  return (await ref.watch(settingsRepositoryProvider).institution())
      .getOrThrow();
}, retry: (_, _) => null);

/// Campus/filiais (todas as páginas, ordenadas por nome).
final campusesProvider = FutureProvider.autoDispose<List<CampusModel>>((
  ref,
) async {
  final repository = ref.watch(settingsRepositoryProvider);
  final rows = <CampusModel>[];
  var page = 1;
  while (true) {
    final result = (await repository.campuses(page: page++)).getOrThrow();
    rows.addAll(result.items);
    if (!result.meta.hasNext) return rows;
  }
}, retry: (_, _) => null);

/// Cor `#RRGGBB` → [Color]; `null` se inválida.
Color? parseBrandColor(String? hex) {
  if (hex == null || !brandColorPattern.hasMatch(hex)) return null;
  return Color(0xFF000000 | int.parse(hex.substring(1), radix: 16));
}

/// Cor da marca da instituição, que `app.dart` aplica ao tema (`null` = usar a
/// cor por omissão).
final institutionBrandColorProvider = Provider<Color?>(
  (ref) => parseBrandColor(ref.watch(institutionProvider).value?.brandColor),
);
