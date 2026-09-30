import 'package:json_annotation/json_annotation.dart';

/// Público de um comunicado.
@JsonEnum(fieldRename: FieldRename.snake)
enum AnnouncementAudience {
  /// Toda a escola (funcionários, alunos, encarregados).
  school,

  /// Alunos e encarregados de uma turma.
  classroom,

  /// Só encarregados de educação (de toda a escola ou de uma turma).
  guardians,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum AnnouncementStatus { draft, published }

@JsonEnum(fieldRename: FieldRename.snake)
enum AgendaEventType { holiday, exam, meeting, deadline, event }
