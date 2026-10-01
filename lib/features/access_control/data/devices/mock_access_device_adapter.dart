import 'dart:async';

import '../../domain/access_device_adapter.dart';

/// Simula um torniquete: [simulateRead] emite uma leitura e [signals] guarda
/// os comandos de abrir/negar enviados ao dispositivo.
class MockAccessDeviceAdapter implements AccessDeviceAdapter {
  final _controller = StreamController<DeviceCardRead>.broadcast();

  /// Comandos enviados (`deviceId → abriu?`), do mais antigo para o mais novo.
  final List<({String deviceId, bool open})> signals = [];

  @override
  Stream<DeviceCardRead> get reads => _controller.stream;

  void simulateRead(String deviceId, String cardUid, {DateTime? at}) {
    _controller.add(
      DeviceCardRead(
        deviceId: deviceId,
        cardUid: cardUid,
        readAt: at ?? DateTime.now(),
      ),
    );
  }

  @override
  Future<void> signal(String deviceId, {required bool open}) async {
    signals.add((deviceId: deviceId, open: open));
  }

  Future<void> dispose() => _controller.close();
}
