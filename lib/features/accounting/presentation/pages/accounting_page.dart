import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../widgets/accounts_tab.dart';
import '../widgets/cost_centers_tab.dart';
import '../widgets/fiscal_years_tab.dart';
import '../widgets/journal_tab.dart';
import '../widgets/ledger_tab.dart';
import '../widgets/open_items_tab.dart';
import '../widgets/trial_balance_tab.dart';

/// Contabilidade: plano de contas, exercícios, centros de custo, diário,
/// razão, balancete e contas a pagar/receber.
class AccountingPage extends StatelessWidget {
  const AccountingPage({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 7,
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
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [
                  Tab(text: 'Plano de contas'),
                  Tab(text: 'Exercícios'),
                  Tab(text: 'Centros de custo'),
                  Tab(text: 'Diário'),
                  Tab(text: 'Razão'),
                  Tab(text: 'Balancete'),
                  Tab(text: 'Pagar/receber'),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    AccountsTab(),
                    FiscalYearsTab(),
                    CostCentersTab(),
                    JournalTab(),
                    LedgerTab(),
                    TrialBalanceTab(),
                    OpenItemsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
