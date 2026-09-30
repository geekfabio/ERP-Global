import 'module_descriptor.dart';

/// Erro de configuração do catálogo (dependência inexistente ou ciclo).
class ModuleConfigError implements Exception {
  ModuleConfigError(this.message);
  final String message;

  @override
  String toString() => 'ModuleConfigError: $message';
}

/// Registo de módulos e resolução das suas dependências.
class ModuleRegistry {
  ModuleRegistry(Iterable<ModuleDescriptor> modules) {
    for (final m in modules) {
      if (_byCode.containsKey(m.code)) {
        throw ModuleConfigError('Módulo duplicado: ${m.code}');
      }
      _byCode[m.code] = m;
    }
    for (final m in _byCode.values) {
      for (final d in m.dependencies) {
        if (!_byCode.containsKey(d)) {
          throw ModuleConfigError('${m.code} depende de "$d", não registado');
        }
      }
    }
    _assertAcyclic();
  }

  final Map<String, ModuleDescriptor> _byCode = {};

  List<ModuleDescriptor> get all => List.unmodifiable(_byCode.values);
  List<String> get codes => List.unmodifiable(_byCode.keys);
  ModuleDescriptor? byCode(String code) => _byCode[code];
  bool isRegistered(String code) => _byCode.containsKey(code);

  /// Módulos obrigatórios (sempre activos, ex.: `core`).
  Set<String> get requiredCodes => {
    for (final m in _byCode.values)
      if (m.required) m.code,
  };

  /// [codes] mais todas as suas dependências transitivas (e os obrigatórios).
  /// Códigos desconhecidos são ignorados.
  Set<String> closure(Iterable<String> codes) {
    final result = <String>{};
    void visit(String code) {
      final m = _byCode[code];
      if (m == null || !result.add(code)) return;
      m.dependencies.forEach(visit);
    }

    requiredCodes.forEach(visit);
    codes.forEach(visit);
    return result;
  }

  /// Dependências em falta de cada módulo de [enabled]
  /// (ex.: `cafeteria` sem `cards` → `{cafeteria: [cards]}`). Vazio = válido.
  Map<String, List<String>> missingDependencies(Iterable<String> enabled) {
    final set = enabled.toSet();
    final missing = <String, List<String>>{};
    for (final code in set) {
      final m = _byCode[code];
      if (m == null) continue;
      final lacking = closure([code]).difference(set).toList()..sort();
      lacking.remove(code);
      // `core` obrigatório conta como em falta se não vier na lista.
      if (lacking.isNotEmpty) missing[code] = lacking;
    }
    return missing;
  }

  /// Módulos por ordem topológica (dependências primeiro).
  List<ModuleDescriptor> topologicalOrder([Iterable<String>? only]) {
    final wanted = only == null ? _byCode.keys.toSet() : closure(only);
    final out = <ModuleDescriptor>[];
    final seen = <String>{};
    void visit(String code) {
      if (!wanted.contains(code) || !seen.add(code)) return;
      final m = _byCode[code]!;
      m.dependencies.forEach(visit);
      out.add(m);
    }

    _byCode.keys.forEach(visit);
    return out;
  }

  void _assertAcyclic() {
    final state = <String, int>{}; // 1 = a visitar, 2 = feito
    void visit(String code, List<String> stack) {
      if (state[code] == 2) return;
      if (state[code] == 1) {
        throw ModuleConfigError(
          'Ciclo de dependências: ${[...stack, code].join(' → ')}',
        );
      }
      state[code] = 1;
      for (final d in _byCode[code]!.dependencies) {
        visit(d, [...stack, code]);
      }
      state[code] = 2;
    }

    for (final code in _byCode.keys) {
      visit(code, const []);
    }
  }
}
