import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/widgets/feedback/toasts.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_providers.dart';

class ErpGlobalApp extends ConsumerWidget {
  const ErpGlobalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brand = ref.watch(brandColorProvider);
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
