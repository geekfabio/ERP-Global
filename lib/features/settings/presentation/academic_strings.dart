import '../data/models/academic_year_model.dart';

/// Textos do ano lectivo (pt-AO). Centralizados para migrar para o catálogo ARB.
abstract final class AcademicStrings {
  static const title = 'Ano lectivo';
  static const newYear = 'Novo ano lectivo';
  static const empty = 'Ainda não há anos lectivos.';
  static const code = 'Código (ex.: 2026/2027)';
  static const campus = 'Campus';
  static const startDate = 'Início';
  static const endDate = 'Fim';
  static const gradesDeadline = 'Prazo de lançamento de notas';
  static const termCount = 'Número de períodos';
  static const create = 'Criar';
  static const save = 'Guardar';
  static const cancel = 'Cancelar';
  static const edit = 'Editar datas';
  static const open = 'Abrir';
  static const close = 'Fechar';
  static const reopen = 'Reabrir';
  static const yearCreated = 'Ano lectivo criado.';
  static const saved = 'Alterações guardadas.';
  static const termOpened = 'Período aberto.';
  static const termClosed = 'Período fechado.';
  static const termReopened = 'Período reaberto.';
  static const frozen = 'Encerrado: só de leitura.';
  static const confirmClose =
      'Encerrar congela notas, matrículas e facturação deste ano. '
      'Não pode ser desfeito.';

  static String status(AcademicYearStatus s) => switch (s) {
    AcademicYearStatus.planned => 'Planeado',
    AcademicYearStatus.active => 'Activo',
    AcademicYearStatus.closing => 'Em fecho',
    AcademicYearStatus.closed => 'Encerrado',
  };

  /// Rótulo do botão que avança para o estado seguinte.
  static String advance(AcademicYearStatus next) => switch (next) {
    AcademicYearStatus.active => 'Activar',
    AcademicYearStatus.closing => 'Iniciar fecho',
    AcademicYearStatus.closed => 'Encerrar',
    AcademicYearStatus.planned => 'Planear',
  };

  static String termsOf(int n) => '$n períodos';
}
