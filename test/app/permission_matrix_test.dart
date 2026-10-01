import 'package:erp_global/app/router/app_router.dart';
import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/modules/module_catalog.dart';
import 'package:erp_global/features/auth/data/data_mocks/auth_mock_data.dart';
import 'package:erp_global/features/auth/data/models/auth_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/auth_test_helpers.dart';

/// Matriz esperada (escrita à mão, independente do código de produção):
/// módulos cuja rota cada perfil do seed pode abrir. Todos os outros → /forbidden.
const _allowed = <AuthProfile, Set<String>>{
  AuthProfile.superAdmin: {
    'core', 'students', 'guardians', 'academic', 'grades', 'attendance', //
    'billing', 'accounting', 'hr', 'cafeteria', 'cards', 'access_control',
    'library', 'inventory', 'transport', 'communication', 'guardian_portal',
    'reports', 'import_export', 'cloud_sync',
  },
  AuthProfile.management: {'reports', 'students'},
  AuthProfile.coordination: {'academic', 'grades'},
  AuthProfile.academicOffice: {'students'},
  AuthProfile.teacher: {'academic', 'grades'},
  AuthProfile.homeroomTeacher: {'academic', 'grades'},
  AuthProfile.finance: {'billing'},
  AuthProfile.accountant: {'accounting'},
  AuthProfile.humanResources: {'hr'},
  AuthProfile.cafeteria: {'cafeteria'},
  AuthProfile.security: {'access_control'},
  AuthProfile.librarian: {'library'},
  AuthProfile.guardian: {'guardian_portal'},
  AuthProfile.student: {'guardian_portal'},
};

Future<GoRouter> _boot(WidgetTester tester, AuthProfile profile) async {
  tester.view.physicalSize = const Size(1280, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer(
    overrides: signedInOverrides(
      roles: [authProfileCodes[profile]!],
      permissions: authProfilePermissions[profile]!,
    ),
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: Consumer(
        builder: (context, ref, _) => MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: ref.watch(appRouterProvider),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container.read(appRouterProvider);
}

void main() {
  test('a matriz cobre os 14 perfis do seed', () {
    expect(_allowed.keys.toSet(), AuthProfile.values.toSet());
    expect(authProfilePermissions.keys.toSet(), AuthProfile.values.toSet());
  });

  for (final profile in AuthProfile.values) {
    testWidgets('perfil ${authProfileCodes[profile]} × rota de cada módulo', (
      tester,
    ) async {
      final router = await _boot(tester, profile);
      for (final m in moduleCatalog) {
        router.go(m.path);
        await tester.pumpAndSettle();
        final expected = _allowed[profile]!.contains(m.code)
            ? m.path
            : '/forbidden';
        expect(
          router.state.uri.path,
          expected,
          reason: '${authProfileCodes[profile]} → ${m.path}',
        );
      }
    });
  }
}
