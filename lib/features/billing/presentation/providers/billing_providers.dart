import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/events/domain_event.dart';
import '../../../../core/modules/license_gate.dart';
import '../../../../core/network/api_client.dart';
import '../../data/mock_api/billing_mock_handlers.dart';
import '../../data/models/fee_item.dart';
import '../../data/repositories/api_billing_repositories.dart';
import '../../domain/billing_repositories.dart';

final feeItemRepositoryProvider = Provider<FeeItemRepository>(
  (ref) => ApiFeeItemRepository(ref.watch(apiClientProvider)),
);

final billingPlanRepositoryProvider = Provider<BillingPlanRepository>(
  (ref) => ApiBillingPlanRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock do módulo, registados em `main.dart` (só com mock activo).
final billingMockHandlersProvider = Provider<BillingMockHandlers>(
  (ref) => BillingMockHandlers(),
);

/// Gera as cobranças ao confirmar matrícula; deve ser observado pela app
/// (ver `main.dart`). Sem licença `billing` o evento é ignorado.
final enrollmentBillingListenerProvider = Provider<EnrollmentBillingListener>((
  ref,
) {
  final listener = EnrollmentBillingListener(
    bus: ref.watch(domainEventBusProvider),
    repository: ref.watch(billingPlanRepositoryProvider),
    isLicensed: () => ref.read(enabledModulesProvider).contains('billing'),
  );
  ref.onDispose(listener.dispose);
  return listener;
});

/// Tabela de preços completa.
final feeItemListProvider = FutureProvider.autoDispose<List<FeeItem>>((
  ref,
) async {
  final repo = ref.watch(feeItemRepositoryProvider);
  final items = <FeeItem>[];
  var page = 1;
  while (true) {
    final result = (await repo.list(page: page, pageSize: 100)).getOrThrow();
    items.addAll(result.items);
    if (!result.meta.hasNext) return items;
    page++;
  }
}, retry: (_, _) => null);
