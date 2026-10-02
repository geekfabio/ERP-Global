import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/security/permission_providers.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../domain/settings_repository.dart';
import '../providers/settings_providers.dart';
import '../settings_strings.dart';
import '../widgets/campus_section.dart';
import '../widgets/institution_form.dart';

/// Dados da instituição e campus/filiais (`/settings/institution`).
class InstitutionPage extends ConsumerWidget {
  const InstitutionPage({super.key, this.pickLogo = pickLogoFile});

  final LogoPicker pickLogo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editable = ref
        .watch(permissionServiceProvider)
        .can(settingsUpdatePermission);
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: SettingsStrings.institutionTab),
              Tab(text: SettingsStrings.campusesTab),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                AsyncValueView(
                  value: ref.watch(institutionProvider),
                  onRetry: () => ref.invalidate(institutionProvider),
                  data: (institution) => institution == null
                      ? const SizedBox.shrink()
                      : editable
                      ? InstitutionForm(
                          institution: institution,
                          pickLogo: pickLogo,
                        )
                      : InstitutionSummary(institution: institution),
                ),
                CampusSection(editable: editable),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
