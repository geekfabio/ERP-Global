import 'package:go_router/go_router.dart';

import '../../core/audit/audit_routes.dart';
import '../../features/communication/communication_routes.dart';
import '../../features/guardians/guardians_routes.dart';
import '../../features/import_export/import_export_routes.dart';
import '../../features/students/students_routes.dart';

/// Rotas reais de cada módulo, por código (ver `ModuleDescriptor.code`). Os
/// módulos ainda sem entrada aqui mostram o placeholder "em construção".
final Map<String, List<RouteBase> Function()> featureModuleRoutes = {
  'core': coreRoutes,
  'communication': communicationRoutes,
  'guardians': guardiansRoutes,
  'students': studentsRoutes,
  'import_export': importExportRoutes,
};
