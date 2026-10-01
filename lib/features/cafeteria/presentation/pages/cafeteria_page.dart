import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../widgets/meal_catalog_tabs.dart';
import '../widgets/weekly_menu_tab.dart';
import 'pos_page.dart';
import 'wallets_page.dart';

/// Refeitório: carteiras, menu semanal, tipos de refeição e pratos.
class CafeteriaPage extends StatelessWidget {
  const CafeteriaPage({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 5,
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [
                  Tab(text: 'Carteiras'),
                  Tab(text: 'Menu semanal'),
                  Tab(text: 'Refeições'),
                  Tab(text: 'Pratos'),
                  Tab(text: 'POS'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    WalletsPage(),
                    WeeklyMenuTab(),
                    MealTypesTab(),
                    MealItemsTab(),
                    PosPage(),
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
