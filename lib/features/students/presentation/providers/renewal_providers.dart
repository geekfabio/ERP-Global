import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/repositories/api_renewal_repository.dart';
import '../../domain/renewal_repository.dart';
import '../../domain/renewal_rules.dart';

final renewalRepositoryProvider = Provider<RenewalRepository>(
  (ref) => ApiRenewalRepository(ref.watch(apiClientProvider)),
);

/// Anos lectivos para escolher origem e destino.
final renewalYearsProvider = FutureProvider.autoDispose<List<RenewalYear>>(
  (ref) async =>
      (await ref.watch(renewalRepositoryProvider).years()).getOrThrow(),
  retry: (_, _) => null,
);
