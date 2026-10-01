import 'package:flutter_test/flutter_test.dart';

import 'api_contract_suite.dart';
import 'real_contract_target.dart';

/// Saltado sem `--dart-define=CONTRACT_BASE_URL`; ver [RealContractTarget].
void main() {
  final target = RealContractTarget();
  if (target.skipReason != null) {
    test('contrato API — ${target.name}', () {}, skip: target.skipReason);
    return;
  }
  runApiContractSuite(target);
}
