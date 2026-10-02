import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/library_models.dart';
import '../providers/library_providers.dart';
import 'library_form_dialog.dart';
import 'library_table.dart';

/// Exemplares de uma obra, com estado e acrescento de novos exemplares.
Future<void> showCopiesDialog(BuildContext context, BookModel book) =>
    showDialog<void>(
      context: context,
      builder: (_) => _CopiesDialog(book: book),
    );

class _CopiesDialog extends ConsumerWidget {
  const _CopiesDialog({required this.book});

  final BookModel book;

  void _refresh(WidgetRef ref) => ref
    ..invalidate(bookCopiesProvider(book.id))
    ..invalidate(bookListProvider);

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final v = await showLibraryForm(
      context,
      title: 'Novo exemplar',
      subtitle: book.title,
      fields: const [LibraryField('barcode', 'Código de barras')],
    );
    if (v == null) return;
    final result = await ref
        .read(bookRepositoryProvider)
        .addCopy(book.id, barcode: v['barcode']! as String);
    if (reportResult(ref, result, done: 'Exemplar registado')) _refresh(ref);
  }

  Future<void> _setStatus(
    WidgetRef ref,
    CopyModel copy,
    CopyStatus status,
  ) async {
    final result = await ref
        .read(bookRepositoryProvider)
        .setCopyStatus(copy.id, status);
    if (reportResult(ref, result, done: 'Exemplar actualizado')) _refresh(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copies = ref.watch(bookCopiesProvider(book.id));
    return AlertDialog(
      title: Text('Exemplares · ${book.title}'),
      content: SizedBox(
        width: 520,
        height: 320,
        child: AsyncValueView<List<CopyModel>>(
          value: copies,
          onRetry: () => ref.invalidate(bookCopiesProvider(book.id)),
          isEmpty: (d) => d.isEmpty,
          empty: const EmptyState(
            icon: Icons.layers_outlined,
            title: 'Sem exemplares',
          ),
          data: (items) => ListView(
            children: [
              for (final c in items)
                ListTile(
                  title: Text(c.barcode),
                  leading: StatusBadge(
                    label: copyStatusLabel(c.status),
                    status: copyStatusBadge(c.status),
                  ),
                  trailing: Can(
                    permission: 'library.book.update',
                    child: switch (c.status) {
                      CopyStatus.loaned ||
                      CopyStatus.reserved => const SizedBox.shrink(),
                      CopyStatus.available => PopupMenuButton<CopyStatus>(
                        tooltip: 'Marcar exemplar',
                        onSelected: (s) => _setStatus(ref, c, s),
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: CopyStatus.lost,
                            child: Text('Marcar como perdido'),
                          ),
                          PopupMenuItem(
                            value: CopyStatus.damaged,
                            child: Text('Marcar como danificado'),
                          ),
                        ],
                      ),
                      CopyStatus.lost || CopyStatus.damaged => TextButton(
                        onPressed: () =>
                            _setStatus(ref, c, CopyStatus.available),
                        child: const Text('Repor'),
                      ),
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.all(AppSpacing.md),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
        Can(
          permission: 'library.book.create',
          child: FilledButton(
            onPressed: () => _add(context, ref),
            child: const Text('Novo exemplar'),
          ),
        ),
      ],
    );
  }
}
