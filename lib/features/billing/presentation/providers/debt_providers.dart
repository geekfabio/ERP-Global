import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/modules/license_gate.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/notifications/notification_service.dart';
import '../../data/mock_api/debt_mock_handlers.dart';
import '../../data/models/billing_enums.dart';
import '../../data/models/debtor.dart';
import '../../data/models/payment_agreement.dart';
import '../../data/models/payment_notice.dart';
import '../../data/repositories/api_debt_repository.dart';
import '../../domain/debt_repository.dart';
import 'billing_providers.dart';
import 'payment_providers.dart';

/// Permissões das acções de cobrança.
const debtorReadPermission = 'billing.debtor.read';
const debtorManagePermission = 'billing.debtor.manage';

final debtRepositoryProvider = Provider<DebtRepository>(
  (ref) => ApiDebtRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock da cobrança; partilham cobranças e pagamentos do billing.
final debtMockHandlersProvider = Provider<DebtMockHandlers>((ref) {
  final billing = ref.watch(billingMockHandlersProvider);
  final payments = ref.watch(paymentMockHandlersProvider);
  return DebtMockHandlers(
    allCharges: billing.allCharges,
    allPayments: payments.allPayments,
    classroomOf: billing.classroomOf,
  );
});

/// Filtros da lista de devedores (turma e mês de vencimento `yyyy-MM`).
class DebtorFilter {
  const DebtorFilter({this.classroomId, this.month});

  final String? classroomId;
  final String? month;

  DebtorFilter copyWith({
    String? Function()? classroomId,
    String? Function()? month,
  }) => DebtorFilter(
    classroomId: classroomId == null ? this.classroomId : classroomId(),
    month: month == null ? this.month : month(),
  );
}

class DebtorFilterNotifier extends Notifier<DebtorFilter> {
  @override
  DebtorFilter build() => const DebtorFilter();

  void setClassroom(String? id) =>
      state = state.copyWith(classroomId: () => id);

  void setMonth(String? month) => state = state.copyWith(month: () => month);
}

final debtorFilterProvider =
    NotifierProvider<DebtorFilterNotifier, DebtorFilter>(
      DebtorFilterNotifier.new,
    );

/// Devedores segundo os filtros activos (maior dívida primeiro).
final debtorListProvider = FutureProvider.autoDispose<List<Debtor>>((
  ref,
) async {
  final filter = ref.watch(debtorFilterProvider);
  final repo = ref.watch(debtRepositoryProvider);
  final all = <Debtor>[];
  var page = 1;
  while (true) {
    final r = (await repo.debtors(
      page: page,
      pageSize: 100,
      classroomId: filter.classroomId,
      month: filter.month,
    )).getOrThrow();
    all.addAll(r.items);
    if (!r.meta.hasNext) return all;
    page++;
  }
}, retry: (_, _) => null);

Future<List<T>> _all<T>(
  Future<Result<PagedList<T>>> Function(int page) fetch,
) async {
  final all = <T>[];
  var page = 1;
  while (true) {
    final r = (await fetch(page)).getOrThrow();
    all.addAll(r.items);
    if (!r.meta.hasNext) return all;
    page++;
  }
}

final agreementListProvider =
    FutureProvider.autoDispose<List<PaymentAgreement>>(
      (ref) => _all(
        (page) => ref
            .watch(debtRepositoryProvider)
            .agreements(page: page, pageSize: 100),
      ),
      retry: (_, _) => null,
    );

final noticeListProvider = FutureProvider.autoDispose<List<PaymentNotice>>(
  (ref) => _all(
    (page) =>
        ref.watch(debtRepositoryProvider).notices(page: page, pageSize: 100),
  ),
  retry: (_, _) => null,
);

/// Resultado de um envio de avisos.
class NoticeRunResult {
  const NoticeRunResult({
    required this.notices,
    required this.viaCommunication,
  });

  final List<PaymentNotice> notices;

  /// `true` se o módulo de comunicação (activo) fez a entrega.
  final bool viaCommunication;
}

/// Emite os avisos em falta. Com o módulo `communication` licenciado, cada
/// aviso é também entregue pelo serviço de notificações (contrato do `core`);
/// sem ele, o aviso fica só registado na cobrança.
class NoticeService {
  NoticeService(this._ref);

  final Ref _ref;

  Future<Result<NoticeRunResult>> run({int preDueDays = 3}) async {
    final result = await _ref
        .read(debtRepositoryProvider)
        .runNotices(preDueDays: preDueDays);
    final notices = result.valueOrNull;
    if (notices == null) return Err(result.failureOrNull!);
    final active = _ref.read(enabledModulesProvider).contains('communication');
    if (!active || notices.isEmpty) {
      return Ok(NoticeRunResult(notices: notices, viaCommunication: false));
    }
    final service = _ref.read(notificationServiceProvider);
    for (final n in notices) {
      await service.send(
        NotificationRequest(
          sourceModule: 'billing',
          recipientIds: [n.studentId],
          title: n.kind == NoticeKind.preDue
              ? 'Lembrete de pagamento'
              : 'Pagamento em atraso',
          body: n.message,
          data: {'chargeId': n.chargeId},
        ),
      );
    }
    return Ok(NoticeRunResult(notices: notices, viaCommunication: true));
  }
}

final noticeServiceProvider = Provider<NoticeService>(NoticeService.new);
