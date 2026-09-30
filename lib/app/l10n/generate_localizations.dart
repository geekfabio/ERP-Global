import 'dart:io';

/// Usa o gerador oficial sem exigir configuração fora desta pasta.
Future<void> main() async {
  final directory = File.fromUri(Platform.script).parent.absolute.path;
  final temporary = await Directory.systemTemp.createTemp('erp_global_l10n_');
  try {
    final input = await Directory('${temporary.path}/arb').create();
    await for (final file in Directory(directory).list()) {
      if (file is File && file.path.endsWith('.arb')) {
        await file.copy('${input.path}/${file.uri.pathSegments.last}');
      }
    }
    await File('${temporary.path}/pubspec.yaml').writeAsString(
      'name: erp_global_l10n\nenvironment:\n  sdk: ">=3.12.0 <4.0.0"\n'
      'flutter:\n  generate: true\n',
    );
    await File('${temporary.path}/l10n.yaml').writeAsString(
      'arb-dir: arb\noutput-dir: generated\n'
      'template-arb-file: app_pt.arb\n'
      'preferred-supported-locales: [pt_AO]\n'
      'nullable-getter: false\nformat: true\n',
    );
    final result = await Process.run(
      Platform.isWindows ? 'flutter.bat' : 'flutter',
      ['gen-l10n'],
      workingDirectory: temporary.path,
    );
    stdout.write(result.stdout);
    stderr.write(result.stderr);
    exitCode = result.exitCode;
    if (result.exitCode == 0) {
      await for (final file in Directory(
        '${temporary.path}/generated',
      ).list()) {
        if (file is File && file.path.endsWith('.dart')) {
          await file.copy('$directory/${file.uri.pathSegments.last}');
        }
      }
    }
  } finally {
    final root = await Directory.systemTemp.resolveSymbolicLinks();
    final target = await temporary.resolveSymbolicLinks();
    if (target.startsWith('$root${Platform.pathSeparator}')) {
      await temporary.delete(recursive: true);
    }
  }
}
