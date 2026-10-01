import '../models/auth_profile.dart';
import '../models/scope_model.dart';
import '../models/user_model.dart';

/// Conta do seed de desenvolvimento (só carrega com `useMockApi = true`).
/// A password vive apenas aqui e no estado do mock; nunca no [UserModel].
class MockAccount {
  MockAccount({
    required this.user,
    required this.profile,
    required this.password,
    List<String>? roles,
    this.scope = const ScopeModel(),
  }) : roles = List.unmodifiable(roles ?? [authProfileCodes[profile]!]);

  final UserModel user;

  /// Perfil principal (o primeiro de [roles]).
  final AuthProfile profile;
  final String password;

  /// Códigos de todos os perfis atribuídos (`super_admin`, `professor`, …).
  final List<String> roles;

  /// Âmbito (campus/classe/…) a que os perfis ficam restritos.
  final ScopeModel scope;

  bool get isSuperAdmin => roles.contains('super_admin');

  /// Permissões efectivas: união das dos perfis atribuídos.
  List<String> get permissions => {
    for (final code in roles)
      ...authProfilePermissions[authProfileByCode[code]]!,
  }.toList();

  MockAccount copyWith({
    UserModel? user,
    String? password,
    List<String>? roles,
    ScopeModel? scope,
  }) {
    final newRoles = roles ?? this.roles;
    return MockAccount(
      user: user ?? this.user,
      profile: authProfileByCode[newRoles.first]!,
      password: password ?? this.password,
      roles: newRoles,
      scope: scope ?? this.scope,
    );
  }
}

const mockInstitutionId = '01JINSTITUTION000000000001';
const mockSuperAdminPassword = 'Admin@12345';
const mockDevPassword = 'Dev@12345';

/// Código de cada perfil no contrato JSON (docs/01-perfis-e-permissoes.md).
const authProfileCodes = <AuthProfile, String>{
  AuthProfile.superAdmin: 'super_admin',
  AuthProfile.management: 'direcao',
  AuthProfile.coordination: 'coordenacao',
  AuthProfile.academicOffice: 'secretaria',
  AuthProfile.teacher: 'professor',
  AuthProfile.homeroomTeacher: 'diretor_turma',
  AuthProfile.finance: 'financeiro',
  AuthProfile.accountant: 'contabilista',
  AuthProfile.humanResources: 'rh',
  AuthProfile.cafeteria: 'refeitorio',
  AuthProfile.security: 'seguranca',
  AuthProfile.librarian: 'bibliotecario',
  AuthProfile.guardian: 'encarregado',
  AuthProfile.student: 'aluno',
};

/// Perfil de cada código do contrato JSON.
final authProfileByCode = <String, AuthProfile>{
  for (final e in authProfileCodes.entries) e.value: e.key,
};

/// Permissões `modulo.recurso.acção` por perfil (resumo da matriz do doc 01).
/// `*` = acesso total (super_admin).
const authProfilePermissions = <AuthProfile, List<String>>{
  AuthProfile.superAdmin: ['*'],
  AuthProfile.management: ['reports.dashboard.read', 'students.record.read'],
  AuthProfile.coordination: ['academic.class.read', 'grades.entry.approve'],
  AuthProfile.academicOffice: [
    'students.record.read',
    'students.record.create',
    'students.record.update',
    'students.health.read',
    'students.health.update',
  ],
  AuthProfile.teacher: ['academic.class.read', 'grades.entry.write'],
  AuthProfile.homeroomTeacher: ['academic.class.read', 'grades.entry.write'],
  AuthProfile.finance: [
    'billing.invoice.read',
    'billing.invoice.create',
    'billing.invoice.void',
    'billing.payment.read',
    'billing.payment.create',
    'billing.cash.read',
    'billing.cash.create',
    'billing.debtor.read',
    'billing.debtor.manage',
    'billing.report.read',
    'billing.report.export',
  ],
  AuthProfile.accountant: ['accounting.ledger.read', 'accounting.entry.create'],
  AuthProfile.humanResources: ['hr.employee.read', 'hr.employee.update'],
  AuthProfile.cafeteria: [
    'cafeteria.pos.read',
    'cafeteria.pos.create',
    'cafeteria.wallet.read',
    'cafeteria.wallet.topup',
  ],
  AuthProfile.security: ['access.log.read', 'access.log.create'],
  AuthProfile.librarian: [
    'library.loan.read',
    'library.loan.create',
    'library.book.create',
    'library.book.update',
    'library.fine.pay',
  ],
  AuthProfile.guardian: ['portal.child.read'],
  AuthProfile.student: ['portal.self.read'],
};

/// `admin@erp-global.local` para o super_admin; `<perfil>@erp-global.local` nos restantes.
String mockIdentifierFor(AuthProfile profile) =>
    profile == AuthProfile.superAdmin
    ? 'admin@erp-global.local'
    : '${authProfileCodes[profile]}@erp-global.local';

/// Seed determinístico: 1 super_admin + 13 perfis (docs/07-mock-api.md).
List<MockAccount> buildAuthSeed() {
  final at = DateTime.utc(2026, 1, 1);
  return [
    for (final (i, profile) in AuthProfile.values.indexed)
      MockAccount(
        profile: profile,
        password: profile == AuthProfile.superAdmin
            ? mockSuperAdminPassword
            : mockDevPassword,
        user: UserModel(
          id: '01JAUTHUSER${(i + 1).toString().padLeft(13, '0')}',
          institutionId: mockInstitutionId,
          createdAt: at,
          updatedAt: at,
          name: profile == AuthProfile.superAdmin
              ? 'Super Administrador'
              : 'Utilizador ${authProfileCodes[profile]}',
          email: mockIdentifierFor(profile),
        ),
      ),
  ];
}
