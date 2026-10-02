import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/library_models.dart';
import '../providers/library_providers.dart';
import 'copies_dialog.dart';
import 'library_form_dialog.dart';
import 'library_table.dart';

/// Acervo: obras, exemplares disponíveis e reserva de obras sem exemplar livre.
class BooksTab extends ConsumerStatefulWidget {
  const BooksTab({super.key});

  @override
  ConsumerState<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends ConsumerState<BooksTab> {
  void _refresh() => ref.invalidate(bookListProvider);

  Future<void> _create() async {
    final v = await showLibraryForm(
      context,
      title: 'Nova obra',
      fields: const [
        LibraryField('isbn', 'ISBN'),
        LibraryField('title', 'Título'),
        LibraryField('author', 'Autor'),
        LibraryField('category', 'Categoria'),
        LibraryField('publisher', 'Editora', required: false),
        LibraryField('year', 'Ano', integer: true, required: false),
        LibraryField('copies', 'N.º de exemplares', integer: true),
      ],
    );
    if (v == null) return;
    final publisher = v['publisher']! as String;
    final result = await ref
        .read(bookRepositoryProvider)
        .create(
          BookModel(
            id: '',
            isbn: v['isbn']! as String,
            title: v['title']! as String,
            author: v['author']! as String,
            category: v['category']! as String,
            publisher: publisher.isEmpty ? null : publisher,
            year: v['year'] as int?,
          ),
          copies: (v['copies'] as int?) ?? 0,
        );
    if (reportResult(ref, result, done: 'Obra registada')) _refresh();
  }

  Future<void> _reserve(BookModel book) async {
    final v = await showLibraryForm(
      context,
      title: 'Reservar obra',
      subtitle: book.title,
      submitLabel: 'Reservar',
      fields: const [LibraryField('cardUid', 'Cartão do leitor')],
    );
    if (v == null) return;
    final result = await ref
        .read(circulationRepositoryProvider)
        .reserve(bookId: book.id, cardUid: v['cardUid']! as String);
    if (reportResult(ref, result, done: 'Reserva registada')) {
      ref.invalidate(reservationListProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final books = ref.watch(bookListProvider);
    final can = ref.watch(permissionServiceProvider).canAny;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Align(
            alignment: Alignment.centerRight,
            child: Can(
              permission: 'library.book.create',
              child: AppButton(
                label: 'Nova obra',
                icon: Icons.add,
                onPressed: _create,
              ),
            ),
          ),
        ),
        Expanded(
          child: AsyncValueView<List<BookModel>>(
            value: books,
            onRetry: _refresh,
            isEmpty: (d) => d.isEmpty,
            empty: const EmptyState(
              icon: Icons.local_library_outlined,
              title: 'Acervo vazio',
            ),
            data: (items) => LibraryTable<BookModel>(
              items: items,
              rowId: (b) => b.id,
              emptyText: 'Sem obras',
              columns: [
                AppColumn(
                  label: 'Título',
                  text: (b) => b.title,
                  sortValue: (b) => b.title,
                ),
                AppColumn(
                  label: 'Autor',
                  text: (b) => b.author,
                  sortValue: (b) => b.author,
                ),
                AppColumn(label: 'Categoria', text: (b) => b.category),
                AppColumn(label: 'ISBN', text: (b) => b.isbn),
                AppColumn(
                  label: 'Disponíveis',
                  text: (b) => '${b.availableCopies}/${b.totalCopies}',
                  sortValue: (b) => b.availableCopies,
                  numeric: true,
                ),
              ],
              rowActions: [
                RowAction(
                  label: 'Exemplares',
                  icon: Icons.layers_outlined,
                  onTap: (b) => showCopiesDialog(context, b),
                ),
                if (can('library.loan.create'))
                  RowAction(
                    label: 'Reservar',
                    icon: Icons.bookmark_add_outlined,
                    onTap: _reserve,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
