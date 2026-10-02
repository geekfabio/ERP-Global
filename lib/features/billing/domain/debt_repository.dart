import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/billing_enums.dart';
import '../data/models/debtor.dart';
import '../data/models/payment_agreement.dart';
import '../data/models/payment_notice.dart';

/// Cobrança: devedores, avisos pré/pós-vencimento e acordos de pagamento.
abstract interface class DebtRepository {
  /// Alunos com cobranças vencidas. [month] = `yyyy-MM` (vencimento);
  /// [classroomId] filtra pela turma do aluno.
  Future<Result<PagedList<Debtor>>> debtors({
    int page = 1,
    int pageSize = 20,
    String? classroomId,
    String? month,
    DateTime? asOf,
  });

  Future<Result<PagedList<PaymentNotice>>> notices({
    int page = 1,
    int pageSize = 20,
    String? studentId,
    NoticeKind? kind,
  });

  /// Emite os avisos em falta: lembretes para o que vence nos próximos
  /// [preDueDays] dias e avisos de atraso (uma vez por cobrança e tipo;
  /// cobranças com acordo em curso não são avisadas). 422 se [preDueDays]
  /// estiver fora de 0..30.
  Future<Result<List<PaymentNotice>>> runNotices({
    DateTime? asOf,
    int preDueDays = 3,
  });

  Future<Result<PagedList<PaymentAgreement>>> agreements({
    int page = 1,
    int pageSize = 20,
    String? studentId,
    AgreementStatus? status,
  });

  /// Cria um acordo sobre cobranças em atraso do aluno, em prestações
  /// mensais. Sem [chargeIds] abrange todas as cobranças em atraso. 422 em dados inválidos; 409 se alguma cobrança já está num
  /// acordo em curso.
  Future<Result<PaymentAgreement>> createAgreement({
    required String studentId,
    List<String>? chargeIds,
    required int installmentCount,
    required DateTime firstDueDate,
  });

  Future<Result<PaymentAgreement>> cancelAgreement(String id);
}
