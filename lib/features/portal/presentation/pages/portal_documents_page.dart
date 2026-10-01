import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/portal_academic_models.dart';
import '../providers/portal_providers.dart';
import '../widgets/portal_pupil_page.dart';

/// Pedido de documentos à secretaria + estado dos pedidos.
class PortalDocumentsPage extends StatelessWidget {
  const PortalDocumentsPage({super.key});

  @override
  Widget build(BuildContext context) => PortalPupilPage(
    title: 'Pedir documentos',
    builder: (context, pupil) => _Documents(
      key: ValueKey(pupil.student.id),
      studentId: pupil.student.id,
    ),
  );
}

BadgeStatus _badge(PortalRequestStatus s) => switch (s) {
  PortalRequestStatus.pending => BadgeStatus.warning,
  PortalRequestStatus.approved => BadgeStatus.success,
  PortalRequestStatus.rejected => BadgeStatus.danger,
};

class _Documents extends ConsumerStatefulWidget {
  const _Documents({super.key, required this.studentId});

  final String studentId;

  @override
  ConsumerState<_Documents> createState() => _DocumentsState();
}

class _DocumentsState extends ConsumerState<_Documents> {
  final _notes = TextEditingController();
  PortalDocumentKind? _kind;
  bool _saving = false;
  Map<String, String> _errors = const {};

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final kind = _kind;
    if (kind == null) {
      setState(() => _errors = {'kind': 'Escolha o documento'});
      return;
    }
    setState(() {
      _saving = true;
      _errors = const {};
    });
    final result = await ref
        .read(portalRepositoryProvider)
        .requestDocument(widget.studentId, kind: kind, notes: _notes.text);
    if (!mounted) return;
    setState(() => _saving = false);
    final failure = result.failureOrNull;
    if (failure != null) {
      if (failure is ValidationFailure) {
        setState(() => _errors = failure.fields);
      }
      ref.read(toastProvider.notifier).error(failure.message);
      return;
    }
    ref.read(toastProvider.notifier).success('Pedido enviado à secretaria');
    ref.invalidate(portalDocumentRequestsProvider(widget.studentId));
    setState(() {
      _kind = null;
      _notes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final requests = ref.watch(
      portalDocumentRequestsProvider(widget.studentId),
    );
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<PortalDocumentKind>(
          key: ValueKey(_kind),
          initialValue: _kind,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Documento',
            errorText: _errors['kind'],
          ),
          items: [
            for (final k in PortalDocumentKind.values)
              DropdownMenuItem(value: k, child: Text(k.label)),
          ],
          onChanged: _saving ? null : (k) => setState(() => _kind = k),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _notes,
          enabled: !_saving,
          maxLines: 2,
          maxLength: 300,
          decoration: InputDecoration(
            labelText: 'Observações (opcional)',
            errorText: _errors['notes'],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: const Text('Enviar pedido'),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Pedidos enviados', style: text.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        AsyncValueView<List<PortalDocumentRequest>>(
          value: requests,
          onRetry: () =>
              ref.invalidate(portalDocumentRequestsProvider(widget.studentId)),
          loading: const SkeletonCard(),
          data: (list) => Card(
            child: Column(
              children: [
                for (final d in list)
                  ListTile(
                    title: Text(d.kind.label),
                    subtitle: Text(PtAoFormatters.date(d.createdAt)),
                    trailing: StatusBadge(
                      label: d.status.label,
                      status: _badge(d.status),
                    ),
                  ),
                if (list.isEmpty)
                  const ListTile(title: Text('Ainda sem pedidos')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
