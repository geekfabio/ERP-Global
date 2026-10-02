import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/mock_api/portal_finance_mock_handlers.dart';
import '../../data/models/portal_finance_models.dart';
import '../../data/repositories/api_portal_finance_repository.dart';
import '../../domain/portal_finance_repository.dart';

final portalFinanceRepositoryProvider = Provider<PortalFinanceRepository>(
  (ref) => ApiPortalFinanceRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock da leitura financeira; ligados em `main.dart`.
final portalFinanceMockHandlersProvider = Provider<PortalFinanceMockHandlers>(
  (ref) => throw UnimplementedError(
    'portalFinanceMockHandlersProvider tem de ser sobreposto em main.dart',
  ),
);

/// Cobranças e recibos do educando (o âmbito é decidido pela API).
final portalFinanceProvider = FutureProvider.autoDispose
    .family<PortalFinance, String>((ref, studentId) async {
      final result = await ref
          .watch(portalFinanceRepositoryProvider)
          .finance(studentId);
      return result.getOrThrow();
    }, retry: (_, _) => null);

/// Saldo, extracto e entradas/saídas do cartão do educando.
final portalCardProvider = FutureProvider.autoDispose
    .family<PortalCard, String>((ref, studentId) async {
      final result = await ref
          .watch(portalFinanceRepositoryProvider)
          .card(studentId);
      return result.getOrThrow();
    }, retry: (_, _) => null);
