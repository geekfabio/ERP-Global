import 'package:go_router/go_router.dart';

import '../../core/audit/audit_routes.dart';
import '../../features/accounting/accounting_routes.dart';
import '../../features/auth/auth_routes.dart';
import '../../features/cards/cards_routes.dart';
import '../../features/communication/communication_routes.dart';
import '../../features/license/license_routes.dart';
import '../../features/guardians/guardians_routes.dart';
import '../../features/import_export/import_export_routes.dart';
import '../../features/inventory/inventory_routes.dart';
import '../../features/portal/portal_routes.dart';
import '../../features/settings/settings_routes.dart';
import '../../features/students/students_routes.dart';

/// Rotas reais de cada módulo, por código (ver `ModuleDescriptor.code`). Os
/// módulos ainda sem entrada aqui mostram o placeholder "em construção".
final Map<String, List<RouteBase> Function()> featureModuleRoutes = {
  'core': () => [
    ...coreRoutes(),
    ...usersRoutes(),
    ...licenseRoutes(),
    ...settingsRoutes(),
  ],
  'accounting': accountingRoutes,
  'cards': cardsRoutes,
  'communication': communicationRoutes,
  'guardians': guardiansRoutes,
  'guardian_portal': portalRoutes,
  'inventory': inventoryRoutes,
  'students': studentsRoutes,
  'import_export': importExportRoutes,
};
