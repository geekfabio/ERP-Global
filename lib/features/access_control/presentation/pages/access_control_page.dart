import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../widgets/devices_tab.dart';
import '../widgets/gate_tab.dart';
import '../widgets/rules_tab.dart';
import '../widgets/simulator_tab.dart';
import '../widgets/zones_tab.dart';

/// Controlo de acessos: zonas, regras por horário, dispositivos e teste local.
class AccessControlPage extends StatelessWidget {
  const AccessControlPage({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 5,
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
                  'Controlo de acessos',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [
                  Tab(text: 'Zonas'),
                  Tab(text: 'Regras'),
                  Tab(text: 'Dispositivos'),
                  Tab(text: 'Testar acesso'),
                  Tab(text: 'Portaria'),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    ZonesTab(),
                    RulesTab(),
                    DevicesTab(),
                    SimulatorTab(),
                    GateTab(),
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
