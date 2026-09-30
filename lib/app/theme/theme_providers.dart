import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_theme.dart';

/// Modo de tema (claro/escuro/sistema), alterável em runtime.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void set(ThemeMode mode) => state = mode;
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

/// Cor da marca da instituição.
class BrandColorNotifier extends Notifier<Color> {
  @override
  Color build() => defaultBrandColor;

  void set(Color color) => state = color;
}

final brandColorProvider = NotifierProvider<BrandColorNotifier, Color>(
  BrandColorNotifier.new,
);
