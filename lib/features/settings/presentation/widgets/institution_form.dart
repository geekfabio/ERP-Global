import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../../data/models/institution_model.dart';
import '../../domain/settings_repository.dart';
import '../providers/settings_providers.dart';
import '../settings_strings.dart';

/// Escolhe o logótipo; devolve os bytes (substituível em testes).
typedef LogoPicker = Future<Uint8List?> Function();

Future<Uint8List?> pickLogoFile() async {
  final files = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: const ['png', 'jpg', 'jpeg'],
  );
  final file = files.firstOrNull;
  return file?.xFile.readAsBytes();
}

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Formulário dos dados da instituição, logótipo e cor da marca. Só é mostrado
/// a quem tem `core.settings.update`; os outros vêem [InstitutionSummary].
class InstitutionForm extends ConsumerStatefulWidget {
  const InstitutionForm({
    super.key,
    required this.institution,
    this.pickLogo = pickLogoFile,
  });

  final InstitutionModel institution;
  final LogoPicker pickLogo;

  @override
  ConsumerState<InstitutionForm> createState() => _InstitutionFormState();
}

class _InstitutionFormState extends ConsumerState<InstitutionForm> {
  static const _keys = [
    'name',
    'nif',
    'address',
    'phone',
    'email',
    'brandColor',
  ];

  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _c = {
    for (final entry in widget.institution.toJson().entries)
      if (_keys.contains(entry.key))
        entry.key: TextEditingController(text: entry.value as String? ?? ''),
  };
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    // A pré-visualização da cor acompanha o texto.
    _c['brandColor']!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? SettingsStrings.required : null;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    final result = await ref.read(settingsRepositoryProvider).updateInstitution(
      {for (final k in _keys) k: _c[k]!.text.trim()},
    );
    if (!mounted) return;
    setState(() => _busy = false);
    result.when(
      ok: (_) {
        ref.invalidate(institutionProvider);
        ref.read(toastProvider.notifier).success(SettingsStrings.saved);
      },
      err: (f) => ref.read(toastProvider.notifier).error(f.message),
    );
  }

  Future<void> _upload() async {
    final bytes = await widget.pickLogo();
    if (bytes == null || !mounted) return;
    final toasts = ref.read(toastProvider.notifier);
    if (bytes.length > maxLogoBytes) {
      toasts.error(SettingsStrings.logoTooBig);
      return;
    }
    setState(() => _busy = true);
    final result = await ref.read(settingsRepositoryProvider).uploadLogo(bytes);
    if (!mounted) return;
    setState(() => _busy = false);
    result.when(
      ok: (_) {
        ref.invalidate(institutionProvider);
        toasts.success(SettingsStrings.logoSaved);
      },
      err: (f) => toasts.error(f.message),
    );
  }

  Widget _field(
    String key,
    String label, {
    FormFieldValidator<String>? validator,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
    child: AppTextField(
      label: label,
      controller: _c[key],
      enabled: !_busy,
      validator: validator ?? _required,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = parseBrandColor(_c['brandColor']!.text.trim());
    final logo = widget.institution.logoUrl;
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(SettingsStrings.logo, style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              if (logo != null && logo.startsWith('data:')) ...[
                Image.memory(
                  UriData.parse(logo).contentAsBytes(),
                  height: AppSpacing.xxxl + AppSpacing.lg,
                  semanticLabel:
                      '${SettingsStrings.logo} ${widget.institution.name}',
                ),
                const SizedBox(width: AppSpacing.md),
              ],
              AppButton(
                label: SettingsStrings.logoUpload,
                icon: Icons.upload_outlined,
                variant: AppButtonVariant.secondary,
                onPressed: _busy ? null : _upload,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.xs,
              bottom: AppSpacing.lg,
            ),
            child: Text(
              SettingsStrings.logoHint,
              style: theme.textTheme.bodySmall,
            ),
          ),
          _field('name', SettingsStrings.name),
          _field('nif', SettingsStrings.nif),
          _field('address', SettingsStrings.address),
          _field('phone', SettingsStrings.phone),
          _field(
            'email',
            SettingsStrings.email,
            validator: (v) =>
                _required(v) ??
                (_emailPattern.hasMatch(v!.trim())
                    ? null
                    : SettingsStrings.invalidEmail),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _field(
                  'brandColor',
                  SettingsStrings.brandColor,
                  validator: (v) => brandColorPattern.hasMatch(v?.trim() ?? '')
                      ? null
                      : SettingsStrings.invalidColor,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Semantics(
                  label: SettingsStrings.brandColor,
                  child: Container(
                    width: AppSpacing.xxl + AppSpacing.sm,
                    height: AppSpacing.xxl + AppSpacing.sm,
                    decoration: BoxDecoration(
                      color: color ?? Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.colorScheme.outline),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: AppButton(
              label: SettingsStrings.save,
              loading: _busy,
              onPressed: _busy ? null : _save,
            ),
          ),
        ],
      ),
    );
  }
}

/// Vista só de leitura (sem `core.settings.update`).
class InstitutionSummary extends StatelessWidget {
  const InstitutionSummary({super.key, required this.institution});

  final InstitutionModel institution;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppSpacing.lg),
    children: [
      for (final (label, value) in [
        (SettingsStrings.name, institution.name),
        (SettingsStrings.nif, institution.nif),
        (SettingsStrings.address, institution.address),
        (SettingsStrings.phone, institution.phone),
        (SettingsStrings.email, institution.email),
        (SettingsStrings.brandColor, institution.brandColor),
      ])
        ListTile(title: Text(label), subtitle: Text(value)),
    ],
  );
}
