import 'dart:async';

import 'package:erp_global/core/utils/pt_ao_formatters.dart';

/// Corre antes de cada ficheiro de teste: carrega os dados de locale pt-AO,
/// como o `main.dart` faz no arranque. Testes que montam a app inteira (o
/// painel mostra a data por extenso) não precisam de o repetir.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await PtAoFormatters.initialize();
  await testMain();
}
