import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/security/permission_providers.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../data/models/setting_model.dart';
import '../../domain/settings_repository.dart';
import '../providers/rules_providers.dart';
import '../rules_strings.dart';
import '../widgets/rules_form.dart';

/// Regras académicas, financeiras, moeda e impostos (`/settings/rules`).
class RulesPage extends ConsumerWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editable = ref
        .watch(permissionServiceProvider)
        .can(settingsUpdatePermission);
    return DefaultTabController(
      length: SettingModule.values.length,
      child: Column(
        children: [
          TabBar(
            tabs: [
              for (final m in SettingModule.values)
                Tab(text: RulesStrings.modules[m]),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                for (final m in SettingModule.values)
                  AsyncValueView(
                    value: ref.watch(rulesProvider(m)),
                    onRetry: () => ref.invalidate(rulesProvider(m)),
                    data: (settings) => RulesForm(
                      module: m,
                      settings: settings,
                      editable: editable,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
