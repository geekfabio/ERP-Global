import '../data/models/assessment_scheme_model.dart';

/// Resultado final de uma disciplina.
enum GradeOutcome { pending, approved, failed }

/// Nota fora de `[0, scaleMax]`, componente desconhecido ou nº de trimestres errado.
class InvalidGradeException implements Exception {
  const InvalidGradeException(this.message);

  final String message;

  @override
  String toString() => 'InvalidGradeException: $message';
}

/// Arredonda [value] a [decimals] casas. Erros binários (14.499999…) são
/// absorvidos antes de aplicar o [mode].
double roundGrade(double value, RoundingMode mode, int decimals) {
  final factor = _pow10(decimals);
  final x = double.parse((value * factor).toStringAsFixed(8));
  final rounded = switch (mode) {
    RoundingMode.nearest => x.roundToDouble(),
    RoundingMode.up => x.ceilToDouble(),
    RoundingMode.down => x.floorToDouble(),
  };
  return rounded / factor;
}

double _pow10(int n) => n <= 0 ? 1 : 10 * _pow10(n - 1);

/// Valida o esquema; devolve `campo → mensagem` (vazio = válido).
Map<String, String> validateScheme(AssessmentSchemeModel s) {
  final errors = <String, String>{};
  if (s.name.trim().isEmpty) errors['name'] = 'Campo obrigatório';
  if (s.scaleMax < 1 || s.scaleMax > 100) {
    errors['scaleMax'] = 'Indique um inteiro entre 1 e 100';
  }
  if (s.minPassing < 0 || s.minPassing > s.scaleMax) {
    errors['minPassing'] = 'A nota mínima tem de estar entre 0 e a escala';
  }
  if (s.decimals < 0 || s.decimals > 2) {
    errors['decimals'] = 'Indique entre 0 e 2 casas decimais';
  }
  if (s.components.isEmpty) {
    errors['components'] = 'Indique pelo menos um componente';
  } else if (s.components.any((c) => c.code.trim().isEmpty || c.weight < 1)) {
    errors['components'] = 'Cada componente precisa de código e peso positivo';
  } else if (s.components.map((c) => c.code).toSet().length !=
      s.components.length) {
    errors['components'] = 'Os códigos dos componentes têm de ser únicos';
  } else if (s.components.fold(0, (a, c) => a + c.weight) != 100) {
    errors['components'] = 'Os pesos dos componentes têm de somar 100';
  }
  if (s.termWeights.isNotEmpty &&
      (s.termWeights.any((w) => w < 0) ||
          s.termWeights.fold(0, (a, w) => a + w) != 100)) {
    errors['termWeights'] = 'Os pesos dos trimestres têm de somar 100';
  }
  return errors;
}

/// Motor de médias puro (sem UI nem I/O): `MAC/NPP/NPT → MT → MF`.
/// Componente em falta → resultado `null` (pendente), nunca zero implícito.
class AssessmentEngine {
  const AssessmentEngine(this.scheme);

  final AssessmentSchemeModel scheme;

  /// `MAC`: média simples das avaliações contínuas; `null` se não houver.
  double? mac(Iterable<double> assessments) {
    final list = assessments.toList();
    if (list.isEmpty) return null;
    for (final g in list) {
      _check(g, 'MAC');
    }
    return list.fold(0.0, (a, g) => a + g) / list.length;
  }

  /// `MT`: média ponderada dos componentes (`código → nota`). `null` se
  /// algum componente faltar; arredondada se `roundTerm`.
  double? termAverage(Map<String, double?> grades) {
    final known = {for (final c in scheme.components) c.code};
    for (final code in grades.keys) {
      if (!known.contains(code)) {
        throw InvalidGradeException('Componente desconhecido: $code');
      }
    }
    var sum = 0.0;
    var missing = false;
    for (final c in scheme.components) {
      final g = grades[c.code];
      if (g == null) {
        missing = true;
        continue;
      }
      _check(g, c.code);
      sum += g * c.weight;
    }
    if (missing) return null;
    final mt = sum / 100;
    return scheme.roundTerm ? _round(mt) : mt;
  }

  /// `MF`: média dos trimestres (ponderada se `termWeights`); `null` se
  /// algum estiver pendente. Sempre arredondada.
  double? finalAverage(List<double?> terms) {
    if (terms.isEmpty) return null;
    final weights = scheme.termWeights;
    if (weights.isNotEmpty && weights.length != terms.length) {
      throw InvalidGradeException(
        'Esperados ${weights.length} trimestres, recebidos ${terms.length}',
      );
    }
    var sum = 0.0;
    var missing = false;
    for (var i = 0; i < terms.length; i++) {
      final t = terms[i];
      if (t == null) {
        missing = true;
        continue;
      }
      _check(t, 'MT');
      sum += weights.isEmpty ? t : t * weights[i];
    }
    if (missing) return null;
    return _round(weights.isEmpty ? sum / terms.length : sum / 100);
  }

  GradeOutcome outcome(double? finalGrade) => switch (finalGrade) {
    null => GradeOutcome.pending,
    final g when g >= scheme.minPassing => GradeOutcome.approved,
    _ => GradeOutcome.failed,
  };

  double _round(double v) => roundGrade(v, scheme.rounding, scheme.decimals);

  void _check(double g, String what) {
    if (g.isNaN || g < 0 || g > scheme.scaleMax) {
      throw InvalidGradeException(
        '$what fora do intervalo 0–${scheme.scaleMax}: $g',
      );
    }
  }
}
