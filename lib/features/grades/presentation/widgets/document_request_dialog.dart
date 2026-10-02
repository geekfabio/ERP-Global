import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../academic/presentation/providers/academic_structure_providers.dart';
import '../../../settings/presentation/providers/academic_providers.dart';
import '../../data/models/academic_document_models.dart';
import '../../domain/academic_document.dart';
import '../providers/academic_document_providers.dart';
import '../providers/grades_providers.dart';

/// Pedido de certificado/declaração: tipo, turma, aluno e finalidade.
class DocumentRequestDialog extends ConsumerStatefulWidget {
  const DocumentRequestDialog({super.key});

  @override
  ConsumerState<DocumentRequestDialog> createState() =>
      _DocumentRequestDialogState();
}

class _DocumentRequestDialogState extends ConsumerState<DocumentRequestDialog> {
  DocumentKind _kind = DocumentKind.enrollmentDeclaration;
  String? _classroomId;
  String? _studentId;
  final _purpose = TextEditingController();
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _purpose.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final classrooms = ref.read(classroomListProvider).value ?? const [];
    final classroom = classrooms.where((c) => c.id == _classroomId).firstOrNull;
    final student =
        (ref.read(classroomRosterProvider(_classroomId ?? '')).value ??
                const [])
            .where((s) => s.id == _studentId)
            .firstOrNull;
    if (classroom == null || student == null) {
      setState(() => _error = 'Escolha a turma e o aluno');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final grades = ref.read(gradeListProvider).value ?? const [];
    final years = ref.read(academicYearsProvider).value ?? const [];
    final gradeName =
        grades.where((g) => g.id == classroom.gradeId).firstOrNull?.name ?? '';
    final yearName =
        years
            .where((y) => y.id == classroom.academicYearId)
            .firstOrNull
            ?.code ??
        '';
    final result = await ref
        .read(academicDocumentActionsProvider)
        .request(
          kind: _kind,
          student: student,
          classroomLabel: '$gradeName · ${classroom.name}',
          yearName: yearName,
          purpose: _purpose.text,
        );
    if (!mounted) return;
    switch (result) {
      case Ok():
        ref.read(toastProvider.notifier).success('Pedido registado.');
        Navigator.of(context).pop();
      case Err(:final failure):
        setState(() {
          _saving = false;
          _error = failure is ValidationFailure && failure.fields.isNotEmpty
              ? failure.fields.values.first
              : failure.message;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final classrooms = ref.watch(classroomListProvider).value ?? const [];
    final grades = ref.watch(gradeListProvider).value ?? const [];
    final gradeNames = {for (final g in grades) g.id: g.name};
    final students = _classroomId == null
        ? const []
        : ref.watch(classroomRosterProvider(_classroomId!)).value ?? const [];
    final studentId = students.any((s) => s.id == _studentId)
        ? _studentId
        : null;
    return AlertDialog(
      title: const Text('Novo pedido de documento'),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<DocumentKind>(
                key: const Key('request_kind'),
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Tipo'),
                initialValue: _kind,
                items: [
                  for (final k in DocumentKind.values)
                    DropdownMenuItem(value: k, child: Text(k.label)),
                ],
                onChanged: (v) => setState(() => _kind = v ?? _kind),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                key: const Key('request_classroom'),
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Turma'),
                initialValue: _classroomId,
                items: [
                  for (final c in classrooms)
                    DropdownMenuItem(
                      value: c.id,
                      child: Text('${gradeNames[c.gradeId] ?? ''} · ${c.name}'),
                    ),
                ],
                onChanged: (v) => setState(() {
                  _classroomId = v;
                  _studentId = null;
                }),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                key: const Key('request_student'),
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Aluno'),
                initialValue: studentId,
                items: [
                  for (final s in students)
                    DropdownMenuItem<String>(
                      value: s.id as String,
                      child: Text(
                        s.fullName as String,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: _classroomId == null
                    ? null
                    : (v) => setState(() => _studentId = v),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                key: const Key('request_purpose'),
                controller: _purpose,
                maxLength: 200,
                decoration: const InputDecoration(labelText: 'Finalidade'),
              ),
              if (_error != null)
                Text(
                  _error!,
                  key: const Key('request_error'),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          key: const Key('request_submit'),
          onPressed: _saving ? null : _submit,
          child: const Text('Pedir'),
        ),
      ],
    );
  }
}
