import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/mock_api/discount_mock_handlers.dart';
import '../../data/models/discount.dart';
import '../../data/repositories/api_discount_repository.dart';
import '../../domain/discount_repository.dart';
import 'billing_providers.dart';

/// Permissões das acções de descontos e bolsas.
const discountReadPermission = 'billing.discount.read';
const discountRequestPermission = 'billing.discount.request';
const discountApprovePermission = 'billing.discount.approve';

final discountRepositoryProvider = Provider<DiscountRepository>(
  (ref) => ApiDiscountRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock dos descontos; cada decisão recalcula as cobranças do aluno
/// e as cobranças novas passam a usar os descontos aprovados.
final discountMockHandlersProvider = Provider<DiscountMockHandlers>((ref) {
  final billing = ref.watch(billingMockHandlersProvider);
  final handlers = DiscountMockHandlers(onChanged: billing.reapplyDiscounts);
  billing.discountPolicy = handlers.discountFor;
  return handlers;
});

/// Todos os descontos (mais recentes primeiro).
final discountListProvider = FutureProvider.autoDispose<List<Discount>>((
  ref,
) async {
  final repo = ref.watch(discountRepositoryProvider);
  final all = <Discount>[];
  var page = 1;
  while (true) {
    final r = (await repo.list(page: page, pageSize: 100)).getOrThrow();
    all.addAll(r.items);
    if (!r.meta.hasNext) return all;
    page++;
  }
}, retry: (_, _) => null);
