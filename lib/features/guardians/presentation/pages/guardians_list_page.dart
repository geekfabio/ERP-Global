import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../students/data/models/guardian_model.dart';
import '../providers/guardian_providers.dart';

/// Lista de encarregados com pesquisa e paginação no servidor.
class GuardiansListPage extends ConsumerStatefulWidget {
  const GuardiansListPage({super.key});

  @override
  ConsumerState<GuardiansListPage> createState() => _GuardiansListPageState();
}

class _GuardiansListPageState extends ConsumerState<GuardiansListPage> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearch(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(guardianListQueryProvider.notifier).setSearch(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = ref.watch(guardianListProvider);
    final query = ref.watch(guardianListQueryProvider);
    final notifier = ref.read(guardianListQueryProvider.notifier);
    return Align(
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
                  'Encarregados',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 360,
                  child: TextField(
                    key: const Key('guardians_search'),
                    onChanged: _onSearch,
                    decoration: const InputDecoration(
                      labelText: 'Pesquisar (nome, telefone ou BI)',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: AsyncValueView<PagedList<GuardianModel>>(
                  value: list,
                  onRetry: () => ref.invalidate(guardianListProvider),
                  isEmpty: (d) => d.items.isEmpty,
                  empty: EmptyState(
                    icon: Icons.family_restroom_outlined,
                    title: 'Nenhum encarregado encontrado',
                    message: query.q != null
                        ? 'Experimente alterar a pesquisa.'
                        : 'Ainda não há encarregados registados.',
                  ),
                  data: (page) => ListView.builder(
                    itemCount: page.items.length,
                    itemBuilder: (context, i) {
                      final g = page.items[i];
                      return Card(
                        child: ListTile(
                          key: Key('guardian_${g.id}'),
                          leading: const Icon(Icons.family_restroom_outlined),
                          title: Text(g.fullName),
                          subtitle: Text(
                            [
                              g.phone,
                              if (g.idNumber != null) g.idNumber!,
                            ].join(' · '),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.go('/guardians/${g.id}'),
                        ),
                      );
                    },
                  ),
                ),
              ),
              list.when(
                data: (p) => _Paginator(
                  meta: p.meta,
                  pageSize: query.pageSize,
                  onPage: notifier.setPage,
                  onPageSize: notifier.setPageSize,
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Paginator extends StatelessWidget {
  const _Paginator({
    required this.meta,
    required this.pageSize,
    required this.onPage,
    required this.onPageSize,
  });

  final PageMeta meta;
  final int pageSize;
  final ValueChanged<int> onPage;
  final ValueChanged<int> onPageSize;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSpacing.sm),
    child: Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.md,
      children: [
        Text('${meta.total} encarregados'),
        DropdownButton<int>(
          value: const [10, 20, 50, 100].contains(pageSize) ? pageSize : null,
          items: [
            for (final s in const [10, 20, 50, 100])
              DropdownMenuItem(value: s, child: Text('$s / página')),
          ],
          onChanged: (v) => v == null ? null : onPageSize(v),
        ),
        IconButton(
          tooltip: 'Página anterior',
          icon: const Icon(Icons.chevron_left),
          onPressed: meta.page > 1 ? () => onPage(meta.page - 1) : null,
        ),
        Text('${meta.page} / ${meta.totalPages == 0 ? 1 : meta.totalPages}'),
        IconButton(
          tooltip: 'Página seguinte',
          icon: const Icon(Icons.chevron_right),
          onPressed: meta.hasNext ? () => onPage(meta.page + 1) : null,
        ),
      ],
    ),
  );
}
