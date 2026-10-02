import '../../../core/errors/result.dart';
import '../data/models/portal_teacher_models.dart';

/// Vista do professor no portal. Só devolve as turmas onde o professor
/// lecciona ou é director (atribuições, módulo `academic`); as turmas de
/// outros professores nunca chegam à UI.
abstract interface class PortalTeacherRepository {
  /// Turmas do professor com o [email] da conta; vazio se a conta não tem
  /// ficha de professor.
  Future<Result<List<TeacherClass>>> myClasses({required String email});
}
