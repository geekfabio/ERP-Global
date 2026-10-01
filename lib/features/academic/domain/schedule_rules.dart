import '../data/models/schedule_models.dart';

/// Tipo de falha de validação: 422 (campo inválido) ou 409 (conflito).
enum ScheduleIssueKind { validation, conflict }

/// Recurso em conflito de horário.
enum ScheduleConflictResource { teacher, room, classroom }

class ScheduleIssue {
  const ScheduleIssue(this.kind, this.field, this.message, {this.resource});

  final ScheduleIssueKind kind;
  final String field;
  final String message;
  final ScheduleConflictResource? resource;
}

/// Dias mostrados na grelha (segunda a sábado).
const kScheduleWeekdays = [1, 2, 3, 4, 5, 6];

const kWeekdayNames = {
  1: 'Segunda',
  2: 'Terça',
  3: 'Quarta',
  4: 'Quinta',
  5: 'Sexta',
  6: 'Sábado',
};

final _timePattern = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');

/// `HH:mm` para minutos desde as 00:00, ou `null` se inválido.
int? parseScheduleTime(String? value) {
  if (value == null || !_timePattern.hasMatch(value)) return null;
  return int.parse(value.substring(0, 2)) * 60 +
      int.parse(value.substring(3, 5));
}

/// Dois intervalos sobrepõem-se; intervalos encostados não conflituam.
bool schedulesOverlap(ScheduleSlotModel a, ScheduleSlotModel b) {
  if (a.weekday != b.weekday) return false;
  final as = parseScheduleTime(a.startTime);
  final ae = parseScheduleTime(a.endTime);
  final bs = parseScheduleTime(b.startTime);
  final be = parseScheduleTime(b.endTime);
  if (as == null || ae == null || bs == null || be == null) return false;
  return as < be && bs < ae;
}

/// Conflitos de [candidate] com [others] (o próprio registo deve estar
/// excluído): professor, sala e turma no mesmo intervalo.
List<ScheduleIssue> findScheduleConflicts(
  ScheduleSlotModel candidate,
  Iterable<ScheduleSlotModel> others,
) {
  ScheduleIssue conflict(
    ScheduleConflictResource r,
    String field,
    String message,
    ScheduleSlotModel o,
  ) => ScheduleIssue(
    ScheduleIssueKind.conflict,
    field,
    '$message (${o.startTime}–${o.endTime})',
    resource: r,
  );

  final issues = <ScheduleIssue>[];
  for (final o in others) {
    if (!schedulesOverlap(candidate, o)) continue;
    if (o.teacherId == candidate.teacherId) {
      issues.add(
        conflict(
          ScheduleConflictResource.teacher,
          'teacherId',
          'O professor já tem aula neste horário',
          o,
        ),
      );
    }
    if (o.roomId == candidate.roomId) {
      issues.add(
        conflict(
          ScheduleConflictResource.room,
          'roomId',
          'A sala já está ocupada neste horário',
          o,
        ),
      );
    }
    if (o.classroomId == candidate.classroomId) {
      issues.add(
        conflict(
          ScheduleConflictResource.classroom,
          'startTime',
          'A turma já tem aula neste horário',
          o,
        ),
      );
    }
  }
  return issues;
}

/// Valida [candidate] contra as outras aulas do mesmo ano ([others], sem o
/// próprio registo) e, se indicado, a janela do turno (`HH:mm`).
/// Devolve `null` se for válida.
ScheduleIssue? validateScheduleSlot(
  ScheduleSlotModel candidate,
  Iterable<ScheduleSlotModel> others, {
  String? shiftStart,
  String? shiftEnd,
}) {
  ScheduleIssue invalid(String field, String message) =>
      ScheduleIssue(ScheduleIssueKind.validation, field, message);

  if (!kScheduleWeekdays.contains(candidate.weekday)) {
    return invalid('weekday', 'Dia da semana inválido');
  }
  final start = parseScheduleTime(candidate.startTime);
  final end = parseScheduleTime(candidate.endTime);
  if (start == null) return invalid('startTime', 'Hora inválida (HH:mm)');
  if (end == null) return invalid('endTime', 'Hora inválida (HH:mm)');
  if (end <= start) {
    return invalid('endTime', 'O fim deve ser posterior ao início');
  }
  final shiftFrom = parseScheduleTime(shiftStart);
  final shiftTo = parseScheduleTime(shiftEnd);
  if (shiftFrom != null && shiftTo != null) {
    if (start < shiftFrom || end > shiftTo) {
      return invalid(
        'startTime',
        'Fora do turno da turma ($shiftStart–$shiftEnd)',
      );
    }
  }
  return findScheduleConflicts(candidate, others).firstOrNull;
}

String _hhmm(int minutes) =>
    '${(minutes ~/ 60).toString().padLeft(2, '0')}:'
    '${(minutes % 60).toString().padLeft(2, '0')}';

/// Linhas (início, fim) da grelha: janelas de 1 h do turno (se conhecido)
/// mais os intervalos já ocupados em [slots], por ordem de início.
List<(String, String)> scheduleRows(
  Iterable<ScheduleSlotModel> slots, {
  String? shiftStart,
  String? shiftEnd,
}) {
  final rows = <String, String>{};
  final from = parseScheduleTime(shiftStart);
  final to = parseScheduleTime(shiftEnd);
  if (from != null && to != null) {
    for (var t = from; t + 60 <= to; t += 60) {
      rows[_hhmm(t)] = _hhmm(t + 60);
    }
  }
  for (final s in slots) {
    rows.putIfAbsent(s.startTime, () => s.endTime);
  }
  return [for (final e in rows.entries) (e.key, e.value)]
    ..sort((a, b) => a.$1.compareTo(b.$1));
}
