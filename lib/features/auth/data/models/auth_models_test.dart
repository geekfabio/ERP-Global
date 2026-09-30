// Testes nesta pasta para respeitar o âmbito autorizado da pista.
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

import 'auth_profile.dart';
import 'permission_model.dart';
import 'role_model.dart';
import 'scope_model.dart';
import 'user_model.dart';
import 'user_role.dart';

void main() {
  const userId = '01J000000000000000000000001';
  const roleId = '01J000000000000000000000002';
  final metadata = <String, dynamic>{
    'id': userId,
    'institutionId': '01J000000000000000000000003',
    'createdAt': '2026-01-01T01:00:00+01:00',
    'updatedAt': '2026-01-02T00:00:00Z',
  };

  test('utilizador preserva contactos, estado e datas UTC no JSON', () {
    final user = UserModel.fromJson({
      ...metadata,
      'name': 'Ana',
      'email': 'ana@example.test',
      'phone': '+244900000000',
      'isActive': false,
      'mustChangePassword': true,
      'deletedAt': '2026-01-03T01:00:00+01:00',
    });
    expect(user.createdAt, DateTime.utc(2026));
    expect(user.toJson()['deletedAt'], '2026-01-03T00:00:00.000Z');
    expect(UserModel.fromJson(user.toJson()), user);
    expect(user.copyWith(name: 'Maria').name, 'Maria');
    expect(user.name, 'Ana');
    expect(user.isActive, isFalse);
    expect(user.mustChangePassword, isTrue);
  });

  test('utilizador aplica valores opcionais e rejeita datas sem fuso', () {
    final json = {...metadata, 'name': 'Ana'};
    final user = UserModel.fromJson(json);
    expect(user.email, isNull);
    expect(user.isActive, isTrue);
    expect(user.mustChangePassword, isFalse);
    expect(user.syncState, 'synced');
    expect(
      () => UserModel.fromJson({...json, 'createdAt': '2026-01-01'}),
      throwsFormatException,
    );
  });

  test('os 14 perfis usam os códigos do contrato e rejeitam desconhecidos', () {
    const codes = [
      'super_admin',
      'direcao',
      'coordenacao',
      'secretaria',
      'professor',
      'diretor_turma',
      'financeiro',
      'contabilista',
      'rh',
      'refeitorio',
      'seguranca',
      'bibliotecario',
      'encarregado',
      'aluno',
    ];
    expect(AuthProfile.values, hasLength(codes.length));
    for (var index = 0; index < codes.length; index++) {
      final role = RoleModel.fromJson({...metadata, 'code': codes[index]});
      expect(role.code, AuthProfile.values[index]);
      expect(role.toJson()['code'], codes[index]);
      expect(role.permissions, isEmpty);
    }
    expect(
      () => RoleModel.fromJson({...metadata, 'code': 'unknown'}),
      throwsArgumentError,
    );
  });

  test('permissões aninhadas serializam como mapas e são imutáveis', () {
    final permission = PermissionModel.fromJson({
      ...metadata,
      'code': 'grades.entry.write',
    });
    final role = RoleModel.fromJson({
      ...metadata,
      'id': roleId,
      'code': 'professor',
      'permissions': [permission.toJson()],
    });
    expect((role.toJson()['permissions'] as List).single, isA<Map>());
    expect(RoleModel.fromJson(role.toJson()), role);
    expect(role.permissions.single, permission);
    expect(() => role.permissions.clear(), throwsUnsupportedError);
  });

  test('atribuições preservam o âmbito e permitem vários perfis', () {
    final scope = ScopeModel.fromJson({
      'campusId': userId,
      'courseId': userId,
      'gradeId': userId,
      'classroomId': userId,
      'subjectId': userId,
    });
    final assignment = UserRole.fromJson({
      ...metadata,
      'userId': userId,
      'roleId': roleId,
      'scope': scope.toJson(),
    });
    expect(UserRole.fromJson(assignment.toJson()), assignment);
    expect(assignment.scope, scope);
    expect(assignment.toJson()['scope'], scope.toJson());
    expect(assignment.copyWith(roleId: userId).userId, userId);
    expect(assignment.copyWith(scope: null).scope, isNull);
    expect(const ScopeModel().classroomId, isNull);
  });
}
