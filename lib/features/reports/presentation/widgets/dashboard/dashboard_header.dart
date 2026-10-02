import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/academic/period_context.dart';
import '../../../../../core/security/session_actions.dart';
import '../../../../../core/utils/pt_ao_formatters.dart';
import '../../../../../core/widgets/layout/page_header.dart';
import '../../../domain/dashboard_widget.dart';
import 'dashboard_actions.dart';

/// Saudação pela hora local.
String greetingFor(DateTime now) => switch (now.hour) {
  < 12 => 'Bom dia',
  < 19 => 'Boa tarde',
  _ => 'Boa noite',
};

/// Cabeçalho do painel: data por extenso, saudação ao utilizador, perfil e
/// período em vigor, e as acções rápidas.
class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key, required this.profile, this.now});

  /// Perfil do dashboard (`direcao`, `financeiro`…); `null` = sem dashboard.
  final String? profile;

  /// Momento a mostrar; `null` = agora (parâmetro para testes).
  final DateTime? now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionUserProvider);
    final period = ref.watch(effectivePeriodProvider);
    final at = now ?? DateTime.now();
    final periodText = [
      period.term?.label,
      period.year?.label,
    ].whereType<String>().join(' · ');
    final profileName = profile == null ? null : dashboardProfiles[profile];
    return PageHeader(
      overline: PtAoFormatters.longDate(at),
      title: user == null ? 'Painel' : '${greetingFor(at)}, ${user.firstName}',
      subtitle: [
        if (profileName != null) 'Dashboard · $profileName',
        if (periodText.isNotEmpty) 'resumo de $periodText',
      ].join(' — '),
      actions: const [DashboardActions()],
    );
  }
}
