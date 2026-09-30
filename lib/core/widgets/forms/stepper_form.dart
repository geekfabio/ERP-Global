import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_tokens.dart';

/// Rascunho persistível de um formulário em passos.
abstract interface class DraftStore {
  Future<Map<String, Object?>?> load();
  Future<void> save(Map<String, Object?> values);
  Future<void> clear();
}

class InMemoryDraftStore implements DraftStore {
  Map<String, Object?>? _draft;

  @override
  Future<Map<String, Object?>?> load() async => _draft;

  @override
  Future<void> save(Map<String, Object?> values) async =>
      _draft = Map.of(values);

  @override
  Future<void> clear() async => _draft = null;
}

/// Estado do formulário: valores de todos os passos + passo actual.
/// Os valores vivem aqui (não nos widgets), por isso voltar atrás não perde dados.
class StepperFormController extends ChangeNotifier {
  StepperFormController({Map<String, Object?>? initial, this.onChanged})
    : _values = Map.of(initial ?? const {});

  final Map<String, Object?> _values;

  /// Chamado a cada alteração (usado para guardar rascunho).
  final void Function(Map<String, Object?> values)? onChanged;

  int _current = 0;
  int get current => _current;

  Map<String, Object?> get values => Map.unmodifiable(_values);

  T? get<T>(String key) => _values[key] as T?;

  void set(String key, Object? value) {
    _values[key] = value;
    onChanged?.call(values);
    notifyListeners();
  }

  void goTo(int step) {
    if (step == _current) return;
    _current = step;
    notifyListeners();
  }
}

/// Definição de um passo. [builder] lê/escreve em [StepperFormController]
/// (`controller.get('nome')` / `controller.set('nome', v)`) e usa `TextFormField`
/// com `validator` — a validação corre ao avançar.
class FormStepDef {
  const FormStepDef({required this.title, required this.builder});

  final String title;
  final Widget Function(BuildContext context, StepperFormController form)
  builder;
}

/// Formulário em passos com validação por passo, rascunho e resumo final.
/// Alt+→ / Alt+← avançam e recuam; os botões são focáveis por teclado.
class StepperForm extends StatefulWidget {
  const StepperForm({
    super.key,
    required this.steps,
    required this.onSubmit,
    this.controller,
    this.draftStore,
    this.summaryBuilder,
    this.summaryTitle = 'Resumo',
    this.submitLabel = 'Concluir',
  });

  final List<FormStepDef> steps;

  /// Recebe todos os valores quando o utilizador confirma o resumo.
  final Future<void> Function(Map<String, Object?> values) onSubmit;
  final StepperFormController? controller;
  final DraftStore? draftStore;

  /// Conteúdo do resumo; por omissão lista `chave: valor`.
  final Widget Function(BuildContext context, Map<String, Object?> values)?
  summaryBuilder;
  final String summaryTitle;
  final String submitLabel;

  @override
  State<StepperForm> createState() => _StepperFormState();
}

class _StepperFormState extends State<StepperForm> {
  late final StepperFormController _form;
  late final List<GlobalKey<FormState>> _keys;
  bool _ownsForm = false;
  bool _submitting = false;
  int _revision = 0;

  int get _summaryIndex => widget.steps.length;

  @override
  void initState() {
    super.initState();
    _keys = List.generate(widget.steps.length, (_) => GlobalKey<FormState>());
    final external = widget.controller;
    if (external != null) {
      _form = external;
    } else {
      _ownsForm = true;
      _form = StepperFormController(
        onChanged: (v) => widget.draftStore?.save(v),
      );
      widget.draftStore?.load().then((draft) {
        if (draft == null || !mounted) return;
        for (final e in draft.entries) {
          _form.set(e.key, e.value);
        }
        setState(() => _revision++);
      });
    }
    _form.addListener(_rebuild);
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    _form.removeListener(_rebuild);
    if (_ownsForm) _form.dispose();
    super.dispose();
  }

  /// Alt+→ / Alt+← a nível de teclado global: continua a funcionar quando o
  /// campo focado sai da árvore ao mudar de passo (o foco cai para a rota).
  bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent ||
        !HardwareKeyboard.instance.isAltPressed ||
        !(ModalRoute.of(context)?.isCurrent ?? true)) {
      return false;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (_form.current < _summaryIndex) _next();
      return true;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      _back();
      return true;
    }
    return false;
  }

  void _next() {
    final i = _form.current;
    if (i < widget.steps.length &&
        !(_keys[i].currentState?.validate() ?? true)) {
      return;
    }
    _form.goTo(i + 1);
  }

  void _back() {
    if (_form.current > 0) _form.goTo(_form.current - 1);
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      await widget.onSubmit(_form.values);
      await widget.draftStore?.clear();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = _form.current;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Horizontal só com largura e altura limitadas (o Stepper exige altura finita).
        final wide =
            constraints.maxWidth >= AppBreakpoints.medium &&
            constraints.hasBoundedHeight;
        return _buildStepper(context, current, wide);
      },
    );
  }

  Widget _buildStepper(BuildContext context, int current, bool wide) {
    return Stepper(
      type: wide ? StepperType.horizontal : StepperType.vertical,
      currentStep: current,
      onStepTapped: (i) {
        if (i < current) _form.goTo(i);
      },
      controlsBuilder: (context, details) => details.stepIndex != current
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(top: AppSpacing.lg),
              child: Row(
                children: [
                  if (current > 0)
                    TextButton(onPressed: _back, child: const Text('Anterior')),
                  const SizedBox(width: AppSpacing.sm),
                  if (current < _summaryIndex)
                    FilledButton(
                      onPressed: _next,
                      child: const Text('Seguinte'),
                    )
                  else
                    FilledButton(
                      onPressed: _submitting ? null : _submit,
                      child: Text(widget.submitLabel),
                    ),
                ],
              ),
            ),
      steps: [
        for (final (i, step) in widget.steps.indexed)
          Step(
            title: Text(step.title),
            isActive: current >= i,
            state: current > i ? StepState.complete : StepState.indexed,
            content: Form(
              key: _keys[i],
              // Nova chave após carregar o rascunho: refaz os `initialValue`.
              child: KeyedSubtree(
                key: ValueKey(_revision),
                child: step.builder(context, _form),
              ),
            ),
          ),
        Step(
          title: Text(widget.summaryTitle),
          isActive: current >= _summaryIndex,
          content: current == _summaryIndex
              ? (widget.summaryBuilder?.call(context, _form.values) ??
                    _DefaultSummary(_form.values))
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _DefaultSummary extends StatelessWidget {
  const _DefaultSummary(this.values);

  final Map<String, Object?> values;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (final e in values.entries)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Text('${e.key}: ${e.value ?? '—'}'),
        ),
    ],
  );
}
