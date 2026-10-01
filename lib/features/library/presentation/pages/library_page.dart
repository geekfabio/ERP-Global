import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../widgets/books_tab.dart';
import '../widgets/fines_tab.dart';
import '../widgets/loans_tab.dart';
import '../widgets/reservations_tab.dart';

/// Biblioteca: acervo e exemplares, empréstimos por cartão, multas e reservas.
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 4,
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
                  'Biblioteca',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [
                  Tab(text: 'Acervo'),
                  Tab(text: 'Empréstimos'),
                  Tab(text: 'Multas'),
                  Tab(text: 'Reservas'),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    BooksTab(),
                    LoansTab(),
                    FinesTab(),
                    ReservationsTab(),
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
