import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../widgets/attendance_leave_tabs.dart';
import '../widgets/contracts_positions_tabs.dart';
import '../widgets/employees_tab.dart';
import '../widgets/payroll_tab.dart';

/// RH: funcionários, contratos, cargos, assiduidade, férias e folha salarial.
class HrPage extends StatelessWidget {
  const HrPage({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 6,
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
                  Tab(text: 'Assiduidade'),
                  Tab(text: 'Férias'),
                  Tab(text: 'Folha salarial'),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    EmployeesTab(),
                    ContractsTab(),
                    PositionsTab(),
                    AttendanceTab(),
                    LeavesTab(),
                    PayrollTab(),
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
