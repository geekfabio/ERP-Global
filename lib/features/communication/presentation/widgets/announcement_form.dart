import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/network/mock/mock_reference_data.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../data/models/announcement_model.dart';
import '../../data/models/communication_enums.dart';
import '../pages/communication_page.dart';

/// Formulário de novo comunicado; devolve o rascunho (com ULID gerado no
/// cliente) ou `null` se cancelado.
Future<AnnouncementModel?> showAnnouncementForm(BuildContext context) =>
    showDialog<AnnouncementModel>(
      context: context,
      builder: (_) => const _AnnouncementDialog(),
    );

class _AnnouncementDialog extends StatefulWidget {
  const _AnnouncementDialog();

  @override
  State<_AnnouncementDialog> createState() => _AnnouncementDialogState();
}

class _AnnouncementDialogState extends State<_AnnouncementDialog> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _body = TextEditingController();
  var _audience = AnnouncementAudience.school;
  String? _classroomId;
  var _receipt = false;
  final _channels = <String>{'in_app'};

  static const _allChannels = ['in_app', 'push', 'sms', 'email'];

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now().toUtc();
    final id = SeedGenerator(now.microsecondsSinceEpoch & 0x7fffffff).ulid(now);
    Navigator.pop(
      context,
      AnnouncementModel(
        id: id,
        institutionId: MockRef.institutionId,
        createdAt: now,
        updatedAt: now,
        title: _title.text.trim(),
        body: _body.text.trim(),
        audience: _audience,
        classroomId: _audience == AnnouncementAudience.classroom
            ? _classroomId
            : null,
        requiresReadReceipt: _receipt,
        channels: _channels.toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Novo comunicado'),
    content: SizedBox(
      width: 480,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                key: const Key('announcement_title'),
                controller: _title,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? 'Indique o título' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                key: const Key('announcement_body'),
                controller: _body,
                minLines: 3,
                maxLines: 6,
                decoration: const InputDecoration(labelText: 'Mensagem'),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? 'Indique a mensagem' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<AnnouncementAudience>(
                key: const Key('announcement_audience'),
                initialValue: _audience,
                decoration: const InputDecoration(labelText: 'Público'),
                items: [
                  for (final a in AnnouncementAudience.values)
                    DropdownMenuItem(value: a, child: Text(audienceLabel(a))),
                ],
                onChanged: (v) => setState(() => _audience = v!),
              ),
              if (_audience == AnnouncementAudience.classroom) ...[
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  key: const Key('announcement_classroom'),
                  initialValue: _classroomId,
                  decoration: const InputDecoration(labelText: 'Turma'),
                  items: [
                    for (var g = 0; g < MockRef.gradeCount; g++)
                      for (var l = 0; l < MockRef.classroomLetters.length; l++)
                        DropdownMenuItem(
                          value: MockRef.classroomId(g, l),
                          child: Text(
                            '${MockRef.gradeLabel(g)} — '
                            '${MockRef.classroomLetters[l]}',
                          ),
                        ),
                  ],
                  validator: (v) => v == null ? 'Indique a turma' : null,
                  onChanged: (v) => setState(() => _classroomId = v),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  for (final c in _allChannels)
                    FilterChip(
                      label: Text(channelLabel(c)),
                      selected: _channels.contains(c),
                      onSelected: (on) => setState(
                        () => on ? _channels.add(c) : _channels.remove(c),
                      ),
                    ),
                ],
              ),
              SwitchListTile(
                key: const Key('announcement_receipt'),
                contentPadding: EdgeInsets.zero,
                title: const Text('Pedir confirmação de leitura'),
                value: _receipt,
                onChanged: (v) => setState(() => _receipt = v),
              ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        key: const Key('announcement_send'),
        onPressed: _channels.isEmpty ? null : _submit,
        child: const Text('Enviar'),
      ),
    ],
  );
}
