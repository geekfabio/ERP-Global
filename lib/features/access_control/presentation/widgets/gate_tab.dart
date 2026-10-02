import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/devices/mock_access_device_adapter.dart';
import '../../data/models/access_log_model.dart';
import '../../data/models/access_models.dart';
import '../../domain/access_device_adapter.dart';
import '../../domain/access_evaluator.dart';
import '../../domain/gate_service.dart';
import '../providers/access_providers.dart';
import 'access_labels.dart';

/// Ecrã do segurança: simula a leitura de um cartão num torniquete, mostra a
/// decisão e lista os últimos registos de entrada/saída.
class GateTab extends ConsumerStatefulWidget {
  const GateTab({super.key});

  @override
  ConsumerState<GateTab> createState() => _GateTabState();
}

class _GateTabState extends ConsumerState<GateTab> {
  final _uid = TextEditingController();
  StreamSubscription<DeviceCardRead>? _sub;
  String? _deviceId;
  GateDirection _direction = GateDirection.entry;
  bool _alertGuardian = true;
  bool _busy = false;
  GateOutcome? _outcome;
  String? _error;

  List<AccessDeviceModel> _devices = const [];
  List<ZoneModel> _zones = const [];
  List<AccessRuleModel> _rules = const [];

  @override
  void initState() {
    super.initState();
    _sub = ref.read(accessDeviceAdapterProvider).reads.listen(_onRead);
  }

  @override
  void dispose() {
    _sub?.cancel();
    _uid.dispose();
    super.dispose();
  }

  Future<void> _onRead(DeviceCardRead read) async {
    final device = _devices.where((d) => d.id == read.deviceId).firstOrNull;
    final zone = _zones.where((z) => z.id == device?.zoneId).firstOrNull;
    if (device == null || zone == null) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await ref
        .read(gateServiceProvider)
        .process(
          read,
          device: device,
          zone: zone,
          rules: _rules,
          direction: _direction,
          alertGuardian: _alertGuardian,
        );
    if (!mounted) return;
    ref.invalidate(accessLogListProvider);
    setState(() {
      _busy = false;
      result.when(
        ok: (o) => _outcome = o,
        err: (f) {
          _outcome = null;
          _error = f.message;
        },
      );
    });
  }

  void _simulate() {
    final adapter = ref.read(accessDeviceAdapterProvider);
    final uid = _uid.text.trim();
    if (adapter is! MockAccessDeviceAdapter ||
        _deviceId == null ||
        uid.isEmpty) {
      return;
    }
    adapter.simulateRead(_deviceId!, uid);
    _uid.clear();
  }

  @override
  Widget build(BuildContext context) {
    final devices = ref.watch(accessDeviceListProvider);
    final zones = ref.watch(zoneListProvider);
    final rules = ref.watch(accessRuleListProvider);
    return AsyncValueView<List<AccessDeviceModel>>(
      value: devices,
      onRetry: () => ref.invalidate(accessDeviceListProvider),
      data: (deviceList) => AsyncValueView<List<ZoneModel>>(
        value: zones,
        onRetry: () => ref.invalidate(zoneListProvider),
        data: (zoneList) => AsyncValueView<List<AccessRuleModel>>(
          value: rules,
          onRetry: () => ref.invalidate(accessRuleListProvider),
          data: (ruleList) {
            _devices = deviceList;
            _zones = zoneList;
            _rules = ruleList;
            return _body(deviceList, zoneList);
          },
        ),
      ),
    );
  }

  Widget _body(List<AccessDeviceModel> devices, List<ZoneModel> zones) {
    final usable = devices
        .where((d) => d.isActive && d.status == DeviceStatus.online)
        .toList();
    final zoneNames = {for (final z in zones) z.id: z.name};
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: _form(usable, zoneNames),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Registos recentes',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          _logList(zoneNames),
        ],
      ),
    );
  }

  Widget _form(List<AccessDeviceModel> usable, Map<String, String> zoneNames) {
    final outcome = _outcome;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSearchableSelect<String>(
          key: const Key('gate_device'),
          label: 'Dispositivo',
          options: {
            for (final d in usable)
              d.id: '${d.name} · ${zoneNames[d.zoneId] ?? d.zoneId}',
          },
          value: usable.any((d) => d.id == _deviceId) ? _deviceId : null,
          onSelected: (v) => setState(() => _deviceId = v),
        ),
        const SizedBox(height: AppSpacing.md),
        SegmentedButton<GateDirection>(
          key: const Key('gate_direction'),
          segments: const [
            ButtonSegment(value: GateDirection.entry, label: Text('Entrada')),
            ButtonSegment(value: GateDirection.exit, label: Text('Saída')),
          ],
          selected: {_direction},
          onSelectionChanged: (s) => setState(() => _direction = s.first),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          key: const Key('gate_uid'),
          label: 'UID do cartão',
          controller: _uid,
          hintText: 'RFID-1001',
        ),
        SwitchListTile(
          key: const Key('gate_alert'),
          contentPadding: EdgeInsets.zero,
          title: const Text('Avisar o encarregado'),
          value: _alertGuardian,
          onChanged: (v) => setState(() => _alertGuardian = v),
        ),
        const SizedBox(height: AppSpacing.sm),
        Can(
          permission: 'access.log.create',
          child: AppButton(
            label: 'Simular leitura',
            icon: Icons.nfc,
            onPressed: _busy || _deviceId == null ? null : _simulate,
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            _error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        if (outcome != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Row(
            key: const Key('gate_result'),
            children: [
              StatusBadge(
                label: outcome.allowed ? 'Permitido' : 'Negado',
                status: outcome.allowed
                    ? BadgeStatus.success
                    : BadgeStatus.danger,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  [
                    ?outcome.holder?.name,
                    reasonLabel(outcome.reason),
                    if (outcome.guardianAlerted) 'Encarregado avisado',
                  ].join(' · '),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _logList(Map<String, String> zoneNames) {
    final logs = ref.watch(accessLogListProvider);
    // Dentro de um scroll: sem AsyncValueView (o seu esqueleto é uma ListView).
    return logs.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => Align(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () => ref.invalidate(accessLogListProvider),
          child: const Text(
            'Não foi possível carregar os registos. Tentar de novo',
          ),
        ),
      ),
      data: (items) {
        if (items.isEmpty) return const Text('Sem registos de acesso');
        return Column(
          key: const Key('gate_logs'),
          children: [
            for (final l in items)
              ListTile(
                dense: true,
                leading: Icon(
                  l.direction == GateDirection.entry
                      ? Icons.login
                      : Icons.logout,
                ),
                title: Text(l.holderName ?? 'Cartão ${l.cardUid}'),
                subtitle: Text(
                  '${zoneNames[l.zoneId] ?? l.zoneId} · ${_reasonText(l.reason)}',
                ),
                trailing: StatusBadge(
                  label: l.allowed ? 'Permitido' : 'Negado',
                  status: l.allowed ? BadgeStatus.success : BadgeStatus.danger,
                ),
              ),
          ],
        );
      },
    );
  }

  String _reasonText(String reason) {
    final r = AccessReason.values.asNameMap()[reason];
    return r == null ? reason : reasonLabel(r);
  }
}
