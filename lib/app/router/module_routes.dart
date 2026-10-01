import 'package:go_router/go_router.dart';

import '../../core/audit/audit_routes.dart';
import '../../features/academic/academic_routes.dart';
import '../../features/accounting/accounting_routes.dart';
import '../../features/access_control/access_control_routes.dart';
import '../../features/auth/auth_routes.dart';
import '../../features/billing/billing_routes.dart';
import '../../features/cards/cards_routes.dart';
import '../../features/communication/communication_routes.dart';
import '../../features/library/library_routes.dart';
import '../../features/license/license_routes.dart';
import '../../features/grades/grades_routes.dart';
import '../../features/guardians/guardians_routes.dart';
import '../../features/hr/hr_routes.dart';
import '../../features/import_export/import_export_routes.dart';
import '../../features/inventory/inventory_routes.dart';
import '../../features/portal/portal_routes.dart';
import '../../features/reports/reports_routes.dart';
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
  'academic': academicRoutes,
  'billing': billingRoutes,
  'accounting': accountingRoutes,
  'access_control': accessControlRoutes,
  'cards': cardsRoutes,
  'communication': communicationRoutes,
  'grades': gradesRoutes,
  'guardians': guardiansRoutes,
  'hr': hrRoutes,
  'guardian_portal': portalRoutes,
  'inventory': inventoryRoutes,
  'library': libraryRoutes,
  'reports': reportsRoutes,
  'students': studentsRoutes,
  'import_export': importExportRoutes,
};
