import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_tokens.dart';
import '../../modules/license_gate.dart';
import '../../modules/module_catalog.dart';

/// Faixa com o aviso de licença (a expirar, em graça, só leitura). Não mostra
/// nada se a licença está normal.
class LicenseBannerBar extends ConsumerWidget {
  const LicenseBannerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banner = ref.watch(licenseGateProvider).banner;
    if (banner == null) return const SizedBox.shrink();
    final colors = context.appColors;
    final (bg, fg, icon) = switch (banner.level) {
      LicenseBannerLevel.info => (
        colors.info,
        colors.onInfo,
        Icons.info_outline,
      ),
      LicenseBannerLevel.warning => (
        colors.warning,
        colors.onWarning,
        Icons.warning_amber_outlined,
      ),
      LicenseBannerLevel.danger => (
        colors.danger,
        colors.onDanger,
        Icons.lock_outline,
      ),
    };
    return Semantics(
      liveRegion: true,
      child: Material(
        color: bg,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(icon, color: fg, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(banner.message, style: TextStyle(color: fg)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Contacto comercial apresentado no ecrã "módulo não licenciado".
const commercialContactEmail = 'comercial@erp-global.ao';

/// Ecrã mostrado ao abrir um módulo que a licença não inclui.
class NotLicensedPage extends ConsumerWidget {
  const NotLicensedPage({super.key, this.moduleCode});

  final String? moduleCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final module = moduleCode == null
        ? null
        : ref.watch(moduleRegistryProvider).byCode(moduleCode!);
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.workspace_premium_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Módulo não licenciado',
                style: text.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                module == null
                    ? 'A licença da sua instituição não inclui este módulo.'
                    : 'O módulo "${module.name}" não está incluído na licença da sua instituição.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                icon: const Icon(Icons.mail_outline),
                label: const Text('Contactar equipa comercial'),
                onPressed: () async {
                  await Clipboard.setData(
                    const ClipboardData(text: commercialContactEmail),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Contacto copiado: $commercialContactEmail',
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(commercialContactEmail, style: text.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
