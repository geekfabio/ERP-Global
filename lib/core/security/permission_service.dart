/// Âmbito de uma permissão (campus/curso/classe/turma/disciplina).
class PermissionScope {
  const PermissionScope({
    this.campusId,
    this.courseId,
    this.gradeId,
    this.classroomId,
    this.subjectId,
  });

  final String? campusId;
  final String? courseId;
  final String? gradeId;
  final String? classroomId;
  final String? subjectId;

  Map<String, String?> get _fields => {
    'campusId': campusId,
    'courseId': courseId,
    'gradeId': gradeId,
    'classroomId': classroomId,
    'subjectId': subjectId,
  };

  /// `true` se não restringe nada (vale para tudo).
  bool get isUnrestricted => _fields.values.every((v) => v == null);

  /// Este âmbito (de uma concessão) cobre o [requested]: cada dimensão restrita
  /// aqui tem de coincidir com a pedida. Um pedido sem essa dimensão é negado.
  bool covers(PermissionScope? requested) {
    for (final e in _fields.entries) {
      final granted = e.value;
      if (granted == null) continue;
      if (requested?._fields[e.key] != granted) return false;
    }
    return true;
  }
}

/// Permissão concedida: `modulo.recurso.acção`, com `*` como curinga
/// (`*` total, `students.*`, `grades.entry.*`), opcionalmente restrita por âmbito.
class PermissionGrant {
  const PermissionGrant(this.code, [this.scope]);

  final String code;
  final PermissionScope? scope;

  /// O padrão [code] cobre a permissão concreta [permission].
  bool matches(String permission) {
    if (code == '*') return true;
    if (code == permission) return true;
    if (code.endsWith('.*')) {
      final prefix = code.substring(0, code.length - 1); // mantém o ponto
      return permission.startsWith(prefix);
    }
    return false;
  }

  /// Esta concessão dá acesso (de qualquer forma) ao namespace [ns] (ex.: `students`).
  bool touchesNamespace(String ns) =>
      code == '*' || code == ns || code == '$ns.*' || code.startsWith('$ns.');
}

/// Verificação de permissões. Regra de ouro: a UI esconde, o router bloqueia e o
/// repository valida — este serviço é a fonte única para as três camadas.
class PermissionService {
  const PermissionService(this.grants, {this.readOnly = false});

  const PermissionService.none() : grants = const [], readOnly = false;

  /// A partir dos códigos da sessão (sem âmbito).
  factory PermissionService.fromCodes(
    Iterable<String> codes, {
    bool readOnly = false,
  }) => PermissionService([
    for (final c in codes) PermissionGrant(c),
  ], readOnly: readOnly);

  final List<PermissionGrant> grants;

  /// Licença em modo só leitura: acções que alteram dados são negadas
  /// (só `read` e `export` passam), mesmo com a permissão concedida.
  final bool readOnly;

  static bool _isReadAction(String permission) {
    final action = permission.split('.').last;
    return action == 'read' || action == 'export';
  }

  bool _blockedByReadOnly(String permission) =>
      readOnly && !_isReadAction(permission);

  /// Tem [permission] para o [scope] pedido? Uma concessão restrita só vale
  /// se o pedido indicar o âmbito correspondente.
  bool can(String permission, {PermissionScope? scope}) =>
      !_blockedByReadOnly(permission) &&
      grants.any(
        (g) =>
            g.matches(permission) &&
            (g.scope == null ||
                g.scope!.isUnrestricted ||
                g.scope!.covers(scope)),
      );

  /// Tem [permission] em algum âmbito? (Para mostrar/esconder menus e botões.)
  bool canAny(String permission) =>
      !_blockedByReadOnly(permission) &&
      grants.any((g) => g.matches(permission));

  /// Alguma permissão do módulo/namespace [ns]? (Acesso à rota do módulo.)
  bool canAccessNamespace(String ns) =>
      grants.any((g) => g.touchesNamespace(ns));
}
