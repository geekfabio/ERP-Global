import 'package:erp_global/core/security/permission_service.dart';
import 'package:erp_global/features/auth/data/data_mocks/auth_mock_data.dart';
import 'package:erp_global/features/auth/data/models/auth_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('curingas e correspondência', () {
    test('* dá tudo; prefixo só o seu ramo', () {
      expect(
        const PermissionService([PermissionGrant('*')]).can('a.b.c'),
        isTrue,
      );
      const students = PermissionService([PermissionGrant('students.*')]);
      expect(students.can('students.record.read'), isTrue);
      expect(students.can('students'), isFalse);
      expect(students.can('studentsX.record.read'), isFalse);
      expect(students.can('billing.invoice.read'), isFalse);
      const entry = PermissionService([PermissionGrant('grades.entry.*')]);
      expect(entry.can('grades.entry.write'), isTrue);
      expect(entry.can('grades.report.read'), isFalse);
    });

    test('sem concessões nada é permitido', () {
      const none = PermissionService.none();
      expect(none.can('students.record.read'), isFalse);
      expect(none.canAny('students.record.read'), isFalse);
      expect(none.canAccessNamespace('students'), isFalse);
    });

    test('acesso ao namespace por qualquer permissão do módulo', () {
      final s = PermissionService.fromCodes(['students.record.read']);
      expect(s.canAccessNamespace('students'), isTrue);
      expect(s.canAccessNamespace('student'), isFalse);
      expect(s.canAccessNamespace('billing'), isFalse);
    });
  });

  group('âmbito', () {
    const grant = PermissionGrant(
      'grades.entry.write',
      PermissionScope(classroomId: 'T1', subjectId: 'MAT'),
    );
    const service = PermissionService([grant]);

    test('só vale no âmbito concedido', () {
      expect(
        service.can(
          'grades.entry.write',
          scope: const PermissionScope(classroomId: 'T1', subjectId: 'MAT'),
        ),
        isTrue,
      );
      expect(
        service.can(
          'grades.entry.write',
          scope: const PermissionScope(classroomId: 'T2', subjectId: 'MAT'),
        ),
        isFalse,
      );
      expect(
        service.can(
          'grades.entry.write',
          scope: const PermissionScope(classroomId: 'T1'),
        ),
        isFalse,
      );
    });

    test('pedido sem âmbito é negado; canAny mostra a acção', () {
      expect(service.can('grades.entry.write'), isFalse);
      expect(service.canAny('grades.entry.write'), isTrue);
    });

    test('concessão sem âmbito vale em qualquer âmbito', () {
      const all = PermissionService([PermissionGrant('grades.entry.write')]);
      expect(
        all.can(
          'grades.entry.write',
          scope: const PermissionScope(classroomId: 'X'),
        ),
        isTrue,
      );
    });
  });

  group('matriz por perfil (seed de auth)', () {
    PermissionService of(AuthProfile p) =>
        PermissionService.fromCodes(authProfilePermissions[p]!);

    test('super_admin acede a tudo', () {
      final s = of(AuthProfile.superAdmin);
      for (final p in [
        'core.settings.update',
        'students.record.read',
        'billing.invoice.void',
        'license.manage',
      ]) {
        expect(s.can(p), isTrue, reason: p);
      }
      for (final ns in ['core', 'students', 'billing', 'portal', 'access']) {
        expect(s.canAccessNamespace(ns), isTrue, reason: ns);
      }
    });

    test('encarregado não acede a rotas de admin', () {
      final s = of(AuthProfile.guardian);
      expect(s.canAccessNamespace('portal'), isTrue);
      for (final ns in ['core', 'students', 'billing', 'hr', 'accounting']) {
        expect(s.canAccessNamespace(ns), isFalse, reason: ns);
      }
      expect(s.can('core.settings.update'), isFalse);
      expect(s.can('users.account.create'), isFalse);
    });

    test('só o super_admin acede ao núcleo (definições)', () {
      for (final p in AuthProfile.values) {
        expect(
          of(p).canAccessNamespace('core'),
          p == AuthProfile.superAdmin,
          reason: p.name,
        );
      }
    });

    test('perfis operacionais ficam no seu domínio', () {
      expect(of(AuthProfile.finance).canAccessNamespace('billing'), isTrue);
      expect(of(AuthProfile.finance).canAccessNamespace('hr'), isFalse);
      expect(of(AuthProfile.teacher).can('grades.entry.write'), isTrue);
      expect(of(AuthProfile.teacher).can('billing.invoice.read'), isFalse);
      expect(of(AuthProfile.cafeteria).canAccessNamespace('cafeteria'), isTrue);
      expect(of(AuthProfile.cafeteria).canAccessNamespace('students'), isFalse);
      expect(of(AuthProfile.security).canAccessNamespace('access'), isTrue);
    });
  });
}
