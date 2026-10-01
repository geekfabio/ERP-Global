import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'core/utils/pt_ao_formatters.dart';
import 'features/billing/presentation/providers/billing_providers.dart';
import 'app/provider_overrides.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Datas e números em pt-AO têm de estar carregados antes de qualquer ecrã.
  await PtAoFormatters.initialize();
  runApp(
    ProviderScope(
      overrides: buildAppOverrides(),
      child: const _BillingEvents(child: ErpGlobalApp()),
    ),
  );
}

/// Mantém activo o consumidor de `EnrollmentConfirmed` do módulo billing.
class _BillingEvents extends ConsumerWidget {
  const _BillingEvents({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(enrollmentBillingListenerProvider);
    return child;
  }
}
