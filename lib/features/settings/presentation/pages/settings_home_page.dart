import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_tokens.dart';

/// Ponto de entrada das Definições. Agrupa as áreas administrativas sem
/// misturar as configurações de cada módulo funcional.
class SettingsHomePage extends StatelessWidget {
  const SettingsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const areas = [
      _SettingsArea(
        title: 'Geral',
        subtitle: 'Ano lectivo, períodos, regras e sincronização.',
        icon: Icons.tune_outlined,
        path: '/settings/general',
      ),
      _SettingsArea(
        title: 'Empresa',
        subtitle: 'Dados da instituição, campus, contactos e identidade.',
        icon: Icons.business_outlined,
        path: '/settings/company',
      ),
      _SettingsArea(
        title: 'Perfil',
        subtitle: 'Dados da sessão, perfis atribuídos e acesso à conta.',
        icon: Icons.person_outline,
        path: '/settings/profile',
      ),
      _SettingsArea(
        title: 'Documentos impressos',
        subtitle: 'Modelos PDF institucionais e verificação por QR.',
        icon: Icons.picture_as_pdf_outlined,
        path: '/settings/documents',
      ),
    ];
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1120),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Definições',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Configure a instituição e a sua experiência de trabalho.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 360,
                    mainAxisExtent: 168,
                    crossAxisSpacing: AppSpacing.lg,
                    mainAxisSpacing: AppSpacing.lg,
                  ),
                  itemCount: areas.length,
                  itemBuilder: (context, index) {
                    final area = areas[index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => context.go(area.path),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(area.icon, size: 28),
                              const Spacer(),
                              Text(
                                area.title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                area.subtitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsArea {
  const _SettingsArea({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.path,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final String path;
}
