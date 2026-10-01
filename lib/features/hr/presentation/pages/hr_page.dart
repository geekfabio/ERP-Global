import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../widgets/contracts_positions_tabs.dart';
import '../widgets/employees_tab.dart';

/// RH: funcionários, contratos e cargos.
class HrPage extends StatelessWidget {
  const HrPage({super.key});

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
                  'Recursos Humanos',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [
                  Tab(text: 'Funcionários'),
                  Tab(text: 'Contratos'),
                  Tab(text: 'Cargos'),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [EmployeesTab(), ContractsTab(), PositionsTab()],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
