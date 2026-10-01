import '../../../core/errors/result.dart';
import 'renewal_rules.dart';

/// Renovação de matrícula em massa e transição de classe, por turma.
abstract interface class RenewalRepository {
  /// Anos lectivos (origem/destino).
  Future<Result<List<RenewalYear>>> years();

  /// Pré-visualização: alunos da turma no ano de origem com o resultado final
  /// e a decisão proposta. Não altera nada.
  Future<Result<RenewalPreview>> preview({
    required String sourceYearId,
    required String targetYearId,
    required String classroomId,
  });

  /// Aplica: cria as matrículas de renovação (aprovadas, sem turma) e conclui
  /// as de origem. Matrículas que já existam no destino ficam de fora.
  Future<Result<RenewalOutcome>> apply({
    required String sourceYearId,
    required String targetYearId,
    required List<RenewalItem> items,
  });
}
