import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../widgets/accounts_tab.dart';
import '../widgets/cost_centers_tab.dart';
import '../widgets/fiscal_years_tab.dart';

/// Contabilidade: plano de contas, exercícios e centros de custo.
class AccountingPage extends StatelessWidget {
  const AccountingPage({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 3,
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: Text(
                  'Contabilidade',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(text: 'Plano de contas'),
                  Tab(text: 'Exercícios'),
                  Tab(text: 'Centros de custo'),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [AccountsTab(), FiscalYearsTab(), CostCentersTab()],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
