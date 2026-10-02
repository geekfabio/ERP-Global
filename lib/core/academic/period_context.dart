import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Trimestre (ou bimestre/semestre) escolhível no selector global.
class PeriodTerm {
  const PeriodTerm({
    required this.id,
    required this.label,
    this.isOpen = false,
  });

  final String id;
  final String label;
  final bool isOpen;
}

/// Ano lectivo escolhível no selector global, com os seus períodos.
class PeriodYear {
  const PeriodYear({
    required this.id,
    required this.label,
    this.isActive = false,
    this.terms = const [],
  });

  final String id;
  final String label;
  final bool isActive;
  final List<PeriodTerm> terms;
}

/// Opções do selector. O `core` não conhece `features/`: o módulo de
/// definições preenche-as via [periodChoicesProvider] (override em `main.dart`).
class PeriodChoices {
  const PeriodChoices(this.years);

  const PeriodChoices.empty() : years = const [];

  final List<PeriodYear> years;
}

final periodChoicesProvider = FutureProvider<PeriodChoices>(
  (ref) async => const PeriodChoices.empty(),
);

/// Escolha explícita do utilizador; `null` = usar o activo por omissão.
class PeriodSelection {
  const PeriodSelection({this.yearId, this.termId});

  final String? yearId;
  final String? termId;
}

class PeriodNotifier extends Notifier<PeriodSelection> {
  @override
  PeriodSelection build() => const PeriodSelection();

  /// Mudar de ano repõe o período (o do ano anterior deixa de existir).
  void setYear(String yearId) => state = PeriodSelection(yearId: yearId);

  void setTerm(String termId) =>
      state = PeriodSelection(yearId: state.yearId, termId: termId);
}

final periodProvider = NotifierProvider<PeriodNotifier, PeriodSelection>(
  PeriodNotifier.new,
);

/// Ano e período em vigor, já resolvidos (ambos `null` sem dados).
class EffectivePeriod {
  const EffectivePeriod({this.year, this.term});

  final PeriodYear? year;
  final PeriodTerm? term;
}

/// Resolve a escolha contra as opções: ano escolhido (se existir) ou o activo;
/// período escolhido (se existir nesse ano) ou o primeiro aberto, senão o 1.º.
/// É o que os restantes módulos devem ler para filtrar por ano/trimestre.
EffectivePeriod resolvePeriod(PeriodChoices choices, PeriodSelection chosen) {
  final years = choices.years;
  if (years.isEmpty) return const EffectivePeriod();
  final year =
      years.where((y) => y.id == chosen.yearId).firstOrNull ??
      years.where((y) => y.isActive).firstOrNull ??
      years.first;
  final terms = year.terms;
  final term = terms.isEmpty
      ? null
      : terms.where((t) => t.id == chosen.termId).firstOrNull ??
            terms.where((t) => t.isOpen).firstOrNull ??
            terms.first;
  return EffectivePeriod(year: year, term: term);
}

final effectivePeriodProvider = Provider<EffectivePeriod>(
  (ref) => resolvePeriod(
    ref.watch(periodChoicesProvider).value ?? const PeriodChoices.empty(),
    ref.watch(periodProvider),
  ),
);
