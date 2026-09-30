import 'package:go_router/go_router.dart';

import '../../core/audit/audit_routes.dart';
import '../../features/communication/communication_routes.dart';
import '../../features/students/students_routes.dart';

/// Rotas reais de cada módulo, por código (ver `ModuleDescriptor.code`). Os
/// módulos ainda sem entrada aqui mostram o placeholder "em construção".
final Map<String, List<RouteBase> Function()> featureModuleRoutes = {
  'core': coreRoutes,
  'communication': communicationRoutes,
  'students': studentsRoutes,
};
