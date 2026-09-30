import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_tokens.dart';
import 'app_topbar.dart';
import 'breadcrumbs.dart';
import 'nav_item.dart';

/// Shell administrativo responsivo: sidebar (expanded), rail (medium) e
/// drawer (compact). Breakpoints em [AppBreakpoints].
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(navItemsProvider);
    final selected = navIndexFor(items, location);
    final width = MediaQuery.sizeOf(context).width;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Breadcrumbs(location: location, items: items),
        ),
        Expanded(child: child),
      ],
    );

    void go(int i) => context.go(items[i].path);

    if (width < AppBreakpoints.medium) {
      return Scaffold(
        appBar: AppTopbar(
          compact: true,
          leading: Builder(
            builder: (ctx) => IconButton(
              tooltip: 'Abrir menu',
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
        ),
        drawer: NavigationDrawer(
          selectedIndex: selected < 0 ? null : selected,
          onDestinationSelected: (i) {
            Navigator.of(context).pop();
            go(i);
          },
          children: [
            for (final i in items)
              NavigationDrawerDestination(
                icon: Icon(i.icon),
                label: Text(i.label),
              ),
          ],
        ),
        body: content,
      );
    }

    final extended = width > AppBreakpoints.expanded;
    return Scaffold(
      appBar: const AppTopbar(),
      body: Row(
        children: [
          NavigationRail(
            extended: extended,
            selectedIndex: selected < 0 ? null : selected,
            onDestinationSelected: go,
            labelType: extended
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.all,
            destinations: [
              for (final i in items)
                NavigationRailDestination(
                  icon: Icon(i.icon),
                  label: Text(i.label),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: content),
        ],
      ),
    );
  }
}
