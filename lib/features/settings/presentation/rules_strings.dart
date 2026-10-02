import '../data/models/setting_model.dart';

/// Textos das regras (pt-AO), por módulo e por chave.
abstract final class RulesStrings {
  static const title = 'Regras e parâmetros';
  static const save = 'Guardar';
  static const saved = 'Regras guardadas.';
  static const enabled = 'Activo';

  static const modules = {
    SettingModule.academic: 'Académicas',
    SettingModule.finance: 'Financeiras e moeda',
    SettingModule.tax: 'Impostos',
  };

  static const labels = {
    'minPassingGrade': 'Nota mínima de aprovação',
    'gradeScaleMax': 'Escala (nota máxima)',
    'termCount': 'Número de períodos lectivos',
    'maxAbsences': 'Limite de faltas',
    'maxFailsDeficiency': 'Negativas para transitar com deficiência (máx.)',
    'maxFailsRecourse': 'Negativas para recurso (máx.)',
    'currency': 'Moeda',
    'lateFeeBp': 'Multa por atraso (pontos base, 100 = 1 %)',
    'lateFeeFixed': 'Multa fixa (menor unidade da moeda)',
    'lateInterestMonthlyBp': 'Juros mensais (pontos base, 100 = 1 %)',
    'graceDays': 'Dias de tolerância',
    'vatRateBp': 'Taxa de IVA (pontos base, 1400 = 14 %)',
    'vatExemptionEnabled': 'Permitir isenções de IVA',
    'vatExemptionReason': 'Motivo de isenção por omissão',
  };

  static const currencyNames = {
    'AOA': 'Kwanza (Kz)',
    'USD': 'Dólar (USD)',
    'EUR': 'Euro (EUR)',
  };

  static const invalidNumber = 'Indique um número inteiro';
  static const required = 'Campo obrigatório';
}
