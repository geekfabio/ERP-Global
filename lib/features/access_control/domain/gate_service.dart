import '../../../core/errors/result.dart';
import '../../../core/notifications/notification_service.dart';
import '../data/models/access_log_model.dart';
import '../data/models/access_models.dart';
import 'access_device_adapter.dart';
import 'access_evaluator.dart';
import 'access_log_repository.dart';

/// Resultado do processamento de uma leitura na portaria.
class GateOutcome {
  const GateOutcome({
    required this.reason,
    required this.log,
    this.holder,
    this.guardianAlerted = false,
  });

  final AccessReason reason;
  final AccessLogModel log;
  final AccessHolder? holder;
  final bool guardianAlerted;

  bool get allowed => reason == AccessReason.granted;
}

/// Orquestra uma leitura: titular → regras (locais) → comando ao dispositivo →
/// registo → alerta ao encarregado. Zonas e regras vêm já carregadas.
class GateService {
  GateService({
    required this.adapter,
    required this.holders,
    required this.logs,
    this.notifier,
  });

  final AccessDeviceAdapter adapter;
  final AccessHolderResolver holders;
  final AccessLogRepository logs;

  /// `null` quando o módulo `communication` não está activo.
  final NotificationService? notifier;

  Future<Result<GateOutcome>> process(
    DeviceCardRead read, {
    required AccessDeviceModel device,
    required ZoneModel zone,
    required Iterable<AccessRuleModel> rules,
    GateDirection direction = GateDirection.entry,
    bool alertGuardian = true,
  }) async {
    final lookup = await holders.byCardUid(read.cardUid);
    if (lookup case Err(:final failure)) return Err(failure);
    final holder = lookup.valueOrNull;

    final AccessReason reason;
    if (holder == null) {
      reason = AccessReason.unknownCard;
    } else if (holder.cardBlocked) {
      reason = AccessReason.cardBlocked;
    } else {
      reason = evaluateAccess(
        attempt: AccessAttempt(
          zoneId: zone.id,
          at: read.readAt.toLocal(),
          subject: holder.subject,
          studentActive: holder.studentActive,
          financialClear: holder.financialClear,
        ),
        zone: zone,
        rules: rules,
      ).reason;
    }
    final allowed = reason == AccessReason.granted;
    await adapter.signal(device.id, open: allowed);

    final alerted =
        allowed &&
        alertGuardian &&
        holder!.subject == AccessSubject.student &&
        await _alert(holder, zone, direction, read.readAt);

    final saved = await logs.record(
      AccessLogModel(
        id: '',
        zoneId: zone.id,
        deviceId: device.id,
        cardUid: read.cardUid,
        holderId: holder?.id,
        holderName: holder?.name,
        holderType: holder?.subject.name,
        direction: direction,
        allowed: allowed,
        reason: reason.name,
        guardianAlerted: alerted,
        occurredAt: read.readAt.toUtc(),
      ),
    );
    return switch (saved) {
      Ok(:final value) => Ok(
        GateOutcome(
          reason: reason,
          log: value,
          holder: holder,
          guardianAlerted: alerted,
        ),
      ),
      Err(:final failure) => Err(failure),
    };
  }

  /// Avisa os encarregados; falhas aqui não impedem o registo da passagem.
  Future<bool> _alert(
    AccessHolder student,
    ZoneModel zone,
    GateDirection direction,
    DateTime at,
  ) async {
    final service = notifier;
    if (service == null) return false;
    final ids = (await holders.guardianUserIds(student.id)).valueOrNull;
    if (ids == null || ids.isEmpty) return false;
    final local = at.toLocal();
    final time =
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
    final verb = direction == GateDirection.entry ? 'entrou em' : 'saiu de';
    final result = await service.send(
      NotificationRequest(
        sourceModule: 'access_control',
        recipientIds: ids,
        title: direction == GateDirection.entry
            ? 'Entrada na escola'
            : 'Saída da escola',
        body: '${student.name} $verb ${zone.name} às $time.',
        data: {'studentId': student.id, 'zoneId': zone.id},
      ),
    );
    return result.isOk;
  }
}
