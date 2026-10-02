/// Leitura de um cartão num dispositivo.
class DeviceCardRead {
  const DeviceCardRead({
    required this.deviceId,
    required this.cardUid,
    required this.readAt,
  });

  final String deviceId;
  final String cardUid;
  final DateTime readAt;
}

/// Contrato de um leitor/torniquete físico. O hardware real implementa esta
/// interface; até lá usa-se o `MockAccessDeviceAdapter` (sem cloud).
abstract interface class AccessDeviceAdapter {
  /// Leituras de cartões, por ordem de chegada.
  Stream<DeviceCardRead> get reads;

  /// Abre ([open] = `true`) ou mantém fechado o dispositivo.
  Future<void> signal(String deviceId, {required bool open});
}
