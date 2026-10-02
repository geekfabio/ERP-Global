import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_tokens.dart';
import 'nav_item.dart';

/// Trilho de navegação derivado do caminho actual (`/students/123` → Alunos › 123).
class Breadcrumbs extends StatelessWidget {
  const Breadcrumbs({super.key, required this.location, required this.items});

  final String location;
  final List<NavItem> items;

  @override
  Widget build(BuildContext context) {
    final segments = Uri.parse(location).pathSegments;
    final text = Theme.of(context).textTheme.bodySmall;
    final crumbs = <Widget>[];
    var path = '';
    for (var i = 0; i < segments.length; i++) {
      path += '/${segments[i]}';
      final known = items.where((n) => n.path == path);
      final label = known.isEmpty ? segments[i] : known.first.label;
      final target = path;
      final isLast = i == segments.length - 1;
      if (crumbs.isNotEmpty) {
        crumbs.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Icon(Icons.chevron_right, size: 16),
          ),
        );
      }
      crumbs.add(
        isLast
            ? Semantics(
                label: 'Página actual: $label',
                child: Text(label, style: text),
              )
            : InkWell(
                onTap: () => context.go(target),
                child: Text(
                  label,
                  style: text?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
      );
    }
    return Row(mainAxisSize: MainAxisSize.min, children: crumbs);
  }
}
