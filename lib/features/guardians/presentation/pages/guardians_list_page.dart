import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/layout/filter_panel.dart';
import '../../../../core/widgets/layout/page_header.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/table/app_paginator.dart';
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const PageHeader(
                title: 'Encarregados',
                subtitle:
                    'Contactos, responsabilidades e educandos associados.',
              ),
              const SizedBox(height: AppSpacing.xl),
              FilterPanel(
                search: TextField(
                  key: const Key('guardians_search'),
                  onChanged: _onSearch,
                  decoration: const InputDecoration(
                    labelText: 'Pesquisar por nome, telefone ou BI',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                filters: (_) => const [],
              ),
              const SizedBox(height: AppSpacing.lg),
              Card(
                clipBehavior: Clip.antiAlias,
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
                  data: (page) => _GuardiansResults(items: page.items),
                ),
              ),
              if (list.value case final p?)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.lg),
                  child: AppPaginator(
                    page: p.meta.page,
                    pageSize: query.pageSize,
                    total: p.meta.total,
                    itemLabel: 'encarregados',
                    onPage: notifier.setPage,
                    onPageSize: notifier.setPageSize,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuardiansResults extends StatelessWidget {
  const _GuardiansResults({required this.items});
  final List<GuardianModel> items;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Column(
      children: [
        for (final (index, guardian) in items.indexed) ...[
          if (index > 0) const Divider(height: 1),
          ListTile(
            key: Key('guardian_${guardian.id}'),
            minTileHeight: 76,
            leading: AppAvatar(name: guardian.fullName),
            title: Text(guardian.fullName),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  Text(guardian.phone, style: TextStyle(color: muted)),
                  if (guardian.idNumber != null)
                    Text(
                      'BI ${guardian.idNumber}',
                      style: TextStyle(color: muted),
                    ),
                  if (guardian.userId != null)
                    const Chip(
                      avatar: Icon(Icons.verified_user_outlined, size: 16),
                      label: Text('Portal activo'),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/guardians/${guardian.id}'),
          ),
        ],
      ],
    );
  }
}
