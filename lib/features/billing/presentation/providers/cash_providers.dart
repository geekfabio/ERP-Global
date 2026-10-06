import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/pdf/pdf_file_saver.dart';
import '../../../../core/pdf/pdf_template_engine.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../auth/presentation/providers/auth_state.dart';
import '../../../settings/presentation/providers/pdf_letterhead_provider.dart';
import '../../data/mock_api/cash_mock_handlers.dart';
import '../../data/models/cash_register.dart';
import '../../data/models/cash_session.dart';
import '../../data/repositories/api_cash_repository.dart';
import '../../domain/cash_repository.dart';
import '../pdf/cash_closing_pdf_template.dart';

/// Permissões das acções de caixa.
const cashReadPermission = 'billing.cash.read';
const cashWritePermission = 'billing.cash.create';

final cashRepositoryProvider = Provider<CashRepository>(
  (ref) => ApiCashRepository(ref.watch(apiClientProvider)),
);

final cashMockHandlersProvider = Provider<CashMockHandlers>(
  (ref) => CashMockHandlers(),
);

final cashPdfEngineProvider = Provider<PdfTemplateEngine>(
  (ref) => const PdfTemplateEngine(),
);

final cashPdfSaverProvider = Provider<PdfFileSaver>(
  (ref) => const PickerPdfFileSaver(),
);

/// Identificador do operador autenticado (ou um valor neutro sem sessão).
final cashOperatorIdProvider = Provider<String>(
  (ref) => ref.watch(currentSessionProvider)?.user.id ?? 'operator',
);

final cashRegistersProvider = FutureProvider.autoDispose<List<CashRegister>>(
  (ref) async =>
      (await ref.watch(cashRepositoryProvider).registers()).getOrThrow(),
  retry: (_, _) => null,
);

/// Sessões de caixa (mais recentes primeiro).
final cashSessionsProvider = FutureProvider.autoDispose<List<CashSession>>((
  ref,
) async {
  final repo = ref.watch(cashRepositoryProvider);
  final all = <CashSession>[];
  var page = 1;
  while (true) {
    final r = (await repo.sessions(page: page, pageSize: 100)).getOrThrow();
    all.addAll(r.items);
    if (!r.meta.hasNext) return all;
    page++;
  }
}, retry: (_, _) => null);

/// Movimentos de uma sessão.
final cashMovementsProvider = FutureProvider.autoDispose
    .family<List<CashMovement>, String>(
      (ref, sessionId) async =>
          (await ref.watch(cashRepositoryProvider).movements(sessionId))
              .getOrThrow(),
      retry: (_, _) => null,
    );

/// Gera e guarda o PDF do relatório de fecho de caixa.
class CashReportPdfService {
  CashReportPdfService(this._ref);

  final Ref _ref;

  Future<void> exportClosing(CashSession session) async {
    final toast = _ref.read(toastProvider.notifier);
    try {
      final repo = _ref.read(cashRepositoryProvider);
      final movements = (await repo.movements(session.id)).getOrThrow();
      final registers = (await repo.registers()).getOrThrow();
      final name = registers
          .where((r) => r.id == session.cashRegisterId)
          .map((r) => r.name)
          .firstOrNull;
      final template = CashClosingPdfTemplate(
        session: session,
        movements: movements,
        registerName: name ?? 'Caixa',
      );
      final bytes = await _ref
          .read(cashPdfEngineProvider)
          .render(
            letterhead: await _ref
                .read(institutionPdfLetterheadProvider)
                .load(),
            template: template,
            generatedAt: DateTime.now(),
          );
      final saved = await _ref
          .read(cashPdfSaverProvider)
          .save(fileName: template.fileName, bytes: bytes);
      if (saved) toast.success('Relatório de fecho guardado em PDF.');
    } on Object {
      toast.error('Não foi possível gerar o documento.');
    }
  }
}

final cashReportPdfServiceProvider = Provider<CashReportPdfService>(
  CashReportPdfService.new,
);
