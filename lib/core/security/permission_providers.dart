import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../modules/license_gate.dart';
import 'permission_service.dart';

/// Códigos de permissão da sessão actual (`null` = sem sessão). O `core` não
/// depende de `features/`: a app liga isto ao módulo de auth em `main.dart`.
final sessionPermissionsProvider = Provider<List<String>?>((ref) => null);

/// Serviço de permissões da sessão; sem sessão nada é permitido. Com a licença
/// em só leitura, as acções que alteram dados ficam negadas.
final permissionServiceProvider = Provider<PermissionService>((ref) {
  final codes = ref.watch(sessionPermissionsProvider);
  if (codes == null) return const PermissionService.none();
  return PermissionService.fromCodes(
    codes,
    readOnly: ref.watch(licenseReadOnlyProvider),
  );
});
