import '../data/models/academic_year_model.dart';
import '../data/models/term_model.dart';

/// Permissões do ano lectivo (a UI esconde, o router bloqueia, o handler valida).
const academicUpdatePermission = 'core.academic.update';

/// Reabrir um período fechado.
const academicApprovePermission = 'core.academic.approve';

/// Formato do código: `2026/2027` (o 2.º ano é o 1.º + 1).
final academicYearCodePattern = RegExp(r'^(\d{4})/(\d{4})$');

bool isValidAcademicYearCode(String code) {
  final m = academicYearCodePattern.firstMatch(code);
  return m != null && int.parse(m[2]!) == int.parse(m[1]!) + 1;
}

/// Nomes por omissão consoante o número de períodos.
String defaultTermName(int index, int count) => switch (count) {
  2 => '${index + 1}.º Semestre',
  4 => '${index + 1}.º Bimestre',
  _ => '${index + 1}.º Trimestre',
};

const minTermCount = 2;
const maxTermCount = 4;

/// Transições permitidas — só para a frente, um passo de cada vez.
const _next = {
  AcademicYearStatus.planned: AcademicYearStatus.active,
  AcademicYearStatus.active: AcademicYearStatus.closing,
  AcademicYearStatus.closing: AcademicYearStatus.closed,
};

AcademicYearStatus? nextStatus(AcademicYearStatus from) => _next[from];

bool canTransition(AcademicYearStatus from, AcademicYearStatus to) =>
    _next[from] == to;

/// Encerrado = dados congelados (só leitura): notas, matrículas e facturação.
bool isFrozen(AcademicYearStatus status) => status == AcademicYearStatus.closed;

/// Só se abrem períodos de um ano em curso (activo ou em fecho).
bool canOpenTerms(AcademicYearStatus status) =>
    status == AcademicYearStatus.active || status == AcademicYearStatus.closing;

/// Reabrir (período já fechado antes) em vez de abrir pela primeira vez.
bool isReopen(TermModel term) => term.closedAt != null;

/// Divide `[start, end]` em [count] períodos contíguos e sem sobreposição;
/// o prazo de notas é o último dia do período.
List<({DateTime start, DateTime end})> splitYear(
  DateTime start,
  DateTime end,
  int count,
) {
  final days = end.difference(start).inDays + 1;
  final ranges = <({DateTime start, DateTime end})>[];
  var from = start;
  for (var i = 0; i < count; i++) {
    final length = days ~/ count + (i < days % count ? 1 : 0);
    final to = from.add(Duration(days: length - 1));
    ranges.add((start: from, end: to));
    from = to.add(const Duration(days: 1));
  }
  return ranges;
}
