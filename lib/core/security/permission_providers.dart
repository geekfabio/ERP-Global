import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'permission_service.dart';

/// Códigos de permissão da sessão actual (`null` = sem sessão). O `core` não
/// depende de `features/`: a app liga isto ao módulo de auth em `main.dart`.
final sessionPermissionsProvider = Provider<List<String>?>((ref) => null);

/// Serviço de permissões da sessão; sem sessão nada é permitido.
final permissionServiceProvider = Provider<PermissionService>((ref) {
  final codes = ref.watch(sessionPermissionsProvider);
  return codes == null
      ? const PermissionService.none()
      : PermissionService.fromCodes(codes);
});
