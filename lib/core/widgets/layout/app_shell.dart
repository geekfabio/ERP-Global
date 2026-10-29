import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_tokens.dart';
import '../license/license_widgets.dart';
import 'app_sidebar.dart';
import 'app_topbar.dart';
import 'breadcrumbs.dart';
import 'nav_item.dart';

/// Shell administrativo responsivo: sidebar em acordeão a toda a altura
/// (expanded), a mesma sidebar mais estreita sob a topbar (medium) e drawer
/// (compact). A topbar fica fixa; só o conteúdo faz scroll. Breakpoints em
/// [AppBreakpoints].
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
        const LicenseBannerBar(),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.sm,
            AppSpacing.xl,
            0,
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

    if (width > AppBreakpoints.expanded) {
      return Scaffold(
        body: Row(
          children: [
            AppSidebar(items: items, selectedIndex: selected, onSelected: go),
            const VerticalDivider(width: 1),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: const AppTopbar().preferredSize.height,
                    child: const AppTopbar(),
                  ),
                  Expanded(child: content),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Tablet: a mesma sidebar em acordeão, mais estreita, sob a topbar.
    return Scaffold(
      appBar: const AppTopbar(),
      body: Row(
        children: [
          AppSidebar(
            items: items,
            selectedIndex: selected,
            onSelected: go,
            width: appSidebarWidthMedium,
          ),
          const VerticalDivider(width: 1),
          Expanded(child: content),
        ],
      ),
    );
  }
}
