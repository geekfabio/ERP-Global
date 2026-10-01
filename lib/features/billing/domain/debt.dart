import '../data/models/billing_enums.dart';
import '../data/models/charge.dart';
import '../data/models/debtor.dart';
import '../data/models/payment_agreement.dart';
import 'payments.dart';

/// Rótulos (pt-AO) dos tipos de aviso e estados de acordo.
const noticeKindLabelsPt = <NoticeKind, String>{
  NoticeKind.preDue: 'Antes do vencimento',
  NoticeKind.postDue: 'Em atraso',
};

const agreementStatusLabelsPt = <AgreementStatus, String>{
  AgreementStatus.active: 'Em curso',
  AgreementStatus.completed: 'Cumprido',
  AgreementStatus.broken: 'Incumprido',
  AgreementStatus.cancelled: 'Cancelado',
};

const monthNamesPt = [
  'Janeiro',
  'Fevereiro',
  'Março',
  'Abril',
  'Maio',
  'Junho',
  'Julho',
  'Agosto',
  'Setembro',
  'Outubro',
  'Novembro',
  'Dezembro',
];

/// Dia de calendário (meia-noite UTC) de [d].
DateTime dayOf(DateTime d) {
  final u = d.toUtc();
  return DateTime.utc(u.year, u.month, u.day);
}

/// `yyyy-MM` do mês da data.
String monthKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}';

/// Cobrança em atraso: aberta, com valor em dívida e vencimento anterior a
/// [asOf] (comparação por dia).
bool isChargeOverdue(Charge c, int allocatedMinor, DateTime asOf) =>
    isChargeOpen(c) &&
    outstandingOf(c, allocatedMinor) > 0 &&
    dayOf(c.dueDate).isBefore(dayOf(asOf));

/// Lista de devedores: alunos com cobranças vencidas. Com [month]
/// (`yyyy-MM`) só contam as cobranças que vencem nesse mês; com [classroomId]
/// só alunos dessa turma. Ordenada do maior para o menor valor em atraso.
List<Debtor> buildDebtors({
  required Iterable<Charge> charges,
  required Map<String, int> allocated,
  required DateTime asOf,
  required String? Function(String studentId) classroomOf,
  Set<String> studentsWithAgreement = const {},
  String? classroomId,
  String? month,
}) {
  final today = dayOf(asOf);
  final byStudent = <String, List<Charge>>{};
  for (final c in charges) {
    if (!isChargeOverdue(c, allocated[c.id] ?? 0, today)) continue;
    if (month != null && monthKey(c.dueDate) != month) continue;
    byStudent.putIfAbsent(c.studentId, () => []).add(c);
  }
  final out = <Debtor>[];
  for (final e in byStudent.entries) {
    final room = classroomOf(e.key);
    if (classroomId != null && room != classroomId) continue;
    final oldest = e.value
        .map((c) => dayOf(c.dueDate))
        .reduce((a, b) => a.isBefore(b) ? a : b);
    out.add(
      Debtor(
        studentId: e.key,
        classroomId: room,
        overdueMinor: e.value.fold<int>(
          0,
          (a, c) => a + outstandingOf(c, allocated[c.id] ?? 0),
        ),
        overdueCount: e.value.length,
        oldestDueDate: oldest,
        daysOverdue: today.difference(oldest).inDays,
        hasAgreement: studentsWithAgreement.contains(e.key),
      ),
    );
  }
  out.sort((a, b) {
    final d = b.overdueMinor.compareTo(a.overdueMinor);
    return d != 0 ? d : a.studentId.compareTo(b.studentId);
  });
  return out;
}

/// Aviso a emitir para uma cobrança.
class PlannedNotice {
  const PlannedNotice({
    required this.charge,
    required this.kind,
    required this.amountMinor,
  });

  final Charge charge;
  final NoticeKind kind;
  final int amountMinor;
}

String noticeKey(String chargeId, NoticeKind kind) => '$chargeId|${kind.name}';

/// Avisos a emitir: lembrete para o que vence nos próximos [preDueDays] dias
/// (inclui hoje) e aviso de atraso para o que já venceu. Cada cobrança recebe
/// no máximo um aviso de cada tipo ([sent] = `chargeId|kind` já enviados) e
/// cobranças cobertas por um acordo em curso ([exempt]) não são avisadas.
List<PlannedNotice> planNotices({
  required Iterable<Charge> charges,
  required Map<String, int> allocated,
  required DateTime asOf,
  required int preDueDays,
  Set<String> sent = const {},
  Set<String> exempt = const {},
}) {
  final today = dayOf(asOf);
  final out = <PlannedNotice>[];
  for (final c in charges) {
    if (exempt.contains(c.id) || !isChargeOpen(c)) continue;
    final due = outstandingOf(c, allocated[c.id] ?? 0);
    if (due == 0) continue;
    final days = dayOf(c.dueDate).difference(today).inDays;
    final NoticeKind kind;
    if (days < 0) {
      kind = NoticeKind.postDue;
    } else if (days <= preDueDays) {
      kind = NoticeKind.preDue;
    } else {
      continue;
    }
    if (sent.contains(noticeKey(c.id, kind))) continue;
    out.add(PlannedNotice(charge: c, kind: kind, amountMinor: due));
  }
  out.sort((a, b) => a.charge.id.compareTo(b.charge.id));
  return out;
}

/// Soma [months] meses a [from], limitando o dia ao fim do mês.
DateTime addMonths(DateTime from, int months) {
  final total = from.year * 12 + (from.month - 1) + months;
  final y = total ~/ 12, m = total % 12 + 1;
  final last = DateTime.utc(y, m + 1, 0).day;
  return DateTime.utc(y, m, from.day < last ? from.day : last);
}

/// Reparte [totalMinor] em [count] prestações mensais a partir de [firstDue];
/// o resto da divisão distribui-se (1 unidade) pelas primeiras prestações.
List<AgreementInstallment> splitInstallments({
  required int totalMinor,
  required int count,
  required DateTime firstDue,
}) {
  final base = totalMinor ~/ count, rest = totalMinor % count;
  return [
    for (var i = 0; i < count; i++)
      AgreementInstallment(
        number: i + 1,
        dueDate: addMonths(dayOf(firstDue), i),
        amountMinor: base + (i < rest ? 1 : 0),
      ),
  ];
}

/// Recalcula o progresso do acordo: o pago é o que baixou da dívida das
/// cobranças abrangidas ([outstandingMinor] actual). Uma prestação está paga
/// quando o pago cobre as prestações até ela; o acordo fica incumprido se
/// houver prestação por pagar já vencida.
PaymentAgreement evaluateAgreement(
  PaymentAgreement a, {
  required int outstandingMinor,
  required DateTime asOf,
}) {
  if (a.status == AgreementStatus.cancelled) return a;
  final paid = (a.totalMinor - outstandingMinor).clamp(0, a.totalMinor);
  final today = dayOf(asOf);
  var cumulative = 0;
  var broken = false;
  final installments = <AgreementInstallment>[];
  for (final i in a.installments) {
    cumulative += i.amountMinor;
    final isPaid = paid >= cumulative;
    if (!isPaid && dayOf(i.dueDate).isBefore(today)) broken = true;
    installments.add(i.copyWith(paid: isPaid));
  }
  return a.copyWith(
    paidMinor: paid,
    installments: installments,
    status: paid >= a.totalMinor
        ? AgreementStatus.completed
        : broken
        ? AgreementStatus.broken
        : AgreementStatus.active,
  );
}
