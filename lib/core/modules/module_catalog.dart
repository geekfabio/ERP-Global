import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/states/app_states.dart';
import 'module_descriptor.dart';
import 'module_registry.dart';

/// Os 20 módulos do catálogo (docs/02-modulos-e-licenciamento.md). Cada feature
/// substitui `routes` pelas suas rotas reais; até lá há uma página placeholder.
const moduleCatalog = <ModuleDescriptor>[
  ModuleDescriptor(
    code: 'core',
    name: 'Definições',
    icon: Icons.settings_outlined,
    path: '/settings',
    required: true,
  ),
  ModuleDescriptor(
    code: 'students',
    name: 'Alunos',
    icon: Icons.school_outlined,
    path: '/students',
    dependencies: ['core'],
  ),
  ModuleDescriptor(
    code: 'guardians',
    name: 'Encarregados',
    icon: Icons.family_restroom_outlined,
    path: '/guardians',
    dependencies: ['students'],
  ),
  ModuleDescriptor(
    code: 'academic',
    name: 'Académico',
    icon: Icons.menu_book_outlined,
    path: '/academic',
    dependencies: ['students'],
  ),
  ModuleDescriptor(
    code: 'grades',
    name: 'Notas',
    icon: Icons.grading_outlined,
    path: '/grades',
    dependencies: ['academic'],
  ),
  ModuleDescriptor(
    code: 'attendance',
    name: 'Presenças',
    icon: Icons.fact_check_outlined,
    path: '/attendance',
    dependencies: ['academic'],
  ),
  ModuleDescriptor(
    code: 'billing',
    name: 'Financeiro',
    icon: Icons.payments_outlined,
    path: '/billing',
    dependencies: ['students'],
  ),
  ModuleDescriptor(
    code: 'accounting',
    name: 'Contabilidade',
    icon: Icons.account_balance_outlined,
    path: '/accounting',
    dependencies: ['billing'],
  ),
  ModuleDescriptor(
    code: 'hr',
    name: 'RH',
    icon: Icons.badge_outlined,
    path: '/hr',
    dependencies: ['core'],
  ),
  ModuleDescriptor(
    code: 'cafeteria',
    name: 'Refeitório',
    icon: Icons.restaurant_outlined,
    path: '/cafeteria',
    dependencies: ['students', 'cards'],
  ),
  ModuleDescriptor(
    code: 'cards',
    name: 'Cartões',
    icon: Icons.contactless_outlined,
    path: '/cards',
    dependencies: ['students'],
  ),
  ModuleDescriptor(
    code: 'access_control',
    name: 'Acessos',
    icon: Icons.door_sliding_outlined,
    path: '/access',
    permissionNamespace: 'access',
    dependencies: ['cards'],
  ),
  ModuleDescriptor(
    code: 'library',
    name: 'Biblioteca',
    icon: Icons.local_library_outlined,
    path: '/library',
    dependencies: ['students'],
  ),
  ModuleDescriptor(
    code: 'inventory',
    name: 'Inventário',
    icon: Icons.inventory_2_outlined,
    path: '/inventory',
    dependencies: ['core'],
  ),
  ModuleDescriptor(
    code: 'transport',
    name: 'Transporte',
    icon: Icons.directions_bus_outlined,
    path: '/transport',
    dependencies: ['students'],
  ),
  ModuleDescriptor(
    code: 'communication',
    name: 'Comunicação',
    icon: Icons.campaign_outlined,
    path: '/communication',
    dependencies: ['core'],
  ),
  ModuleDescriptor(
    code: 'guardian_portal',
    name: 'Portal',
    icon: Icons.groups_outlined,
    path: '/portal',
    permissionNamespace: 'portal',
    dependencies: ['guardians'],
  ),
  ModuleDescriptor(
    code: 'reports',
    name: 'Relatórios',
    icon: Icons.insights_outlined,
    path: '/reports',
  ),
  ModuleDescriptor(
    code: 'import_export',
    name: 'Importação',
    icon: Icons.import_export,
    path: '/import-export',
  ),
  ModuleDescriptor(
    code: 'cloud_sync',
    name: 'Sincronização',
    icon: Icons.cloud_sync_outlined,
    path: '/sync',
    permissionNamespace: 'sync',
    dependencies: ['core'],
  ),
];

/// Registry da aplicação. Substituível em testes (`overrideWithValue`).
final moduleRegistryProvider = Provider<ModuleRegistry>(
  (ref) => ModuleRegistry(moduleCatalog),
);

/// Rotas de todos os módulos registados: as do descritor ou um placeholder.
List<RouteBase> buildModuleRoutes(ModuleRegistry registry) => [
  for (final m in registry.all)
    ...(m.routes?.call() ??
        [
          GoRoute(
            path: m.path,
            builder: (context, state) => EmptyState(
              icon: m.icon,
              title: m.name,
              message: 'Módulo em construção.',
            ),
          ),
        ]),
];
