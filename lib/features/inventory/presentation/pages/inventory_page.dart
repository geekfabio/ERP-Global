import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../widgets/assets_tab.dart';
import '../widgets/stock_tab.dart';

/// Inventário e património: bens (localização, responsável, manutenção, abate)
/// e consumíveis (stock com alerta de mínimo).
class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
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
                  'Inventário e património',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(text: 'Bens'),
                  Tab(text: 'Consumíveis'),
                ],
              ),
              const Expanded(
                child: TabBarView(children: [AssetsTab(), StockTab()]),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
