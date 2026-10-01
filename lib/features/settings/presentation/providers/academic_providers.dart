import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/academic/period_context.dart';
import '../../../../core/audit/audit_log_model.dart';
import '../../../../core/audit/audit_providers.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/security/permission_providers.dart';
import '../../data/mock_api/academic_mock_handlers.dart';
import '../../data/models/academic_year_model.dart';
import '../../data/models/term_model.dart';
import '../../data/repositories/api_academic_repository.dart';
import '../../domain/academic_repository.dart';

final academicRepositoryProvider = Provider<AcademicRepository>(
  (ref) => ApiAcademicRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock do módulo, registados em `main.dart` (só com mock activo).
final academicMockHandlersProvider = Provider<AcademicMockHandlers>(
  (ref) => AcademicMockHandlers(
    permissions: () => ref.read(permissionServiceProvider),
  ),
);

/// Anos lectivos (todas as páginas). Refaz-se quando a sessão muda.
final academicYearsProvider = FutureProvider<List<AcademicYearModel>>((
  ref,
) async {
  ref.watch(permissionServiceProvider);
  final repository = ref.watch(academicRepositoryProvider);
  final rows = <AcademicYearModel>[];
  var page = 1;
  while (true) {
    final result = (await repository.years(page: page++)).getOrThrow();
    rows.addAll(result.items);
    if (!result.meta.hasNext) return rows;
  }
}, retry: (_, _) => null);

final termsProvider = FutureProvider.family<List<TermModel>, String>(
  (ref, yearId) async =>
      (await ref.watch(academicRepositoryProvider).terms(yearId)).getOrThrow(),
  retry: (_, _) => null,
);

/// Opções do selector global da topbar (ligadas ao `core` em `main.dart`).
/// Sem sessão ou com falha de rede o selector fica vazio, sem partir a shell.
final academicPeriodChoicesProvider = FutureProvider<PeriodChoices>((
  ref,
) async {
  final List<AcademicYearModel> years;
  try {
    years = await ref.watch(academicYearsProvider.future);
  } on Object {
    return const PeriodChoices.empty();
  }
  final repository = ref.watch(academicRepositoryProvider);
  final out = <PeriodYear>[];
  for (final year in years) {
    final terms =
        (await repository.terms(year.id)).valueOrNull ?? const <TermModel>[];
    out.add(
      PeriodYear(
        id: year.id,
        label: year.code,
        isActive: year.status == AcademicYearStatus.active,
        terms: [
          for (final t in terms)
            PeriodTerm(
              id: t.id,
              label: t.name,
              isOpen: t.status == TermStatus.open,
            ),
        ],
      ),
    );
  }
  return PeriodChoices(out);
}, retry: (_, _) => null);

/// Acções sobre anos e períodos: chamam o repository e auditam o que é
/// sensível (a auditoria nunca anula a acção de negócio).
class AcademicActions {
  AcademicActions(this._ref);

  final Ref _ref;

  AcademicRepository get _repo => _ref.read(academicRepositoryProvider);

  void _refresh([String? yearId]) {
    _ref.invalidate(academicYearsProvider);
    _ref.invalidate(academicPeriodChoicesProvider);
    if (yearId != null) _ref.invalidate(termsProvider(yearId));
  }

  Future<void> _audit(
    String entity,
    AuditAction action,
    String id, {
    Map<String, dynamic>? before,
    Map<String, dynamic>? after,
  }) => _ref
      .read(auditServiceProvider)
      .record(
        entity: entity,
        action: action,
        entityId: id,
        before: before,
        after: after,
      );

  Future<Result<AcademicYearModel>> createYear(
    Map<String, dynamic> values,
  ) async {
    final result = await _repo.createYear(values);
    if (result case Ok(:final value)) {
      await _audit(
        'academic_year',
        AuditAction.create,
        value.id,
        after: value.toJson(),
      );
      _refresh();
    }
    return result;
  }

  Future<Result<AcademicYearModel>> transition(
    AcademicYearModel year,
    AcademicYearStatus to,
  ) async {
    final result = await _repo.transitionYear(year.id, to);
    if (result case Ok()) {
      await _audit(
        'academic_year',
        AuditAction.update,
        year.id,
        before: {'status': year.status.name},
        after: {'status': to.name},
      );
      _refresh(year.id);
    }
    return result;
  }

  Future<Result<TermModel>> updateTerm(
    TermModel term,
    Map<String, dynamic> values,
  ) async {
    final result = await _repo.updateTerm(term.id, values);
    if (result case Ok(:final value)) {
      await _audit(
        'term',
        AuditAction.update,
        term.id,
        before: term.toJson(),
        after: value.toJson(),
      );
      _refresh(term.academicYearId);
    }
    return result;
  }

  /// Abre o período; se já tinha sido fechado, é uma reabertura (auditada como tal).
  Future<Result<TermModel>> openTerm(TermModel term) async {
    final reopen = term.closedAt != null;
    final result = await _repo.openTerm(term.id);
    if (result case Ok()) {
      await _audit(
        'term',
        reopen ? AuditAction.reopen : AuditAction.update,
        term.id,
        before: {'status': term.status.name},
        after: {'status': TermStatus.open.name},
      );
      _refresh(term.academicYearId);
    }
    return result;
  }

  Future<Result<TermModel>> closeTerm(TermModel term) async {
    final result = await _repo.closeTerm(term.id);
    if (result case Ok()) {
      await _audit(
        'term',
        AuditAction.update,
        term.id,
        before: {'status': term.status.name},
        after: {'status': TermStatus.closed.name},
      );
      _refresh(term.academicYearId);
    }
    return result;
  }
}

final academicActionsProvider = Provider<AcademicActions>(AcademicActions.new);
