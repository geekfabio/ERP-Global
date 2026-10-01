import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/widgets/feedback/toasts.dart';
import '../features/settings/presentation/providers/settings_providers.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_providers.dart';

class ErpGlobalApp extends ConsumerWidget {
  const ErpGlobalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // A cor da marca da instituição (Definições) sobrepõe-se à por omissão.
    final defaultBrand = ref.watch(brandColorProvider);
    final brand = ref.watch(institutionBrandColorProvider) ?? defaultBrand;
    return MaterialApp.router(
      title: 'ERP-Global',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(brand),
      darkTheme: AppTheme.dark(brand),
      themeMode: ref.watch(themeModeProvider),
      routerConfig: ref.watch(appRouterProvider),
      scaffoldMessengerKey: rootMessengerKey,
      builder: (context, child) =>
          ToastHost(child: child ?? const SizedBox.shrink()),
    );
  }
}
