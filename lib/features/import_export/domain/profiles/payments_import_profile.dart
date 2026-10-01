import '../import_profile.dart';
import 'import_parsers.dart';

/// Perfil de importação de pagamentos (histórico financeiro). O valor é
/// convertido para `amountMinor` (cêntimos, `int`), nunca para `double`.
class PaymentsImportProfile implements ImportProfile {
  const PaymentsImportProfile();

  @override
  String get id => 'payments';

  @override
  String get label => 'Financeiro';

  @override
  String get entity => 'payments';

  @override
  List<ImportColumn> get columns => [
    const ImportColumn(
      key: 'studentRef',
      label: 'Aluno (nº ou BI)',
      required: true,
      aliases: ['aluno', 'numero', 'bi'],
      example: '20260001',
    ),
    const ImportColumn(
      key: 'amountMinor',
      label: 'Valor (Kz)',
      required: true,
      aliases: ['valor', 'montante', 'quantia'],
      example: '25 000,00',
      parse: parseImportMoney,
    ),
    const ImportColumn(
      key: 'method',
      label: 'Método',
      required: true,
      aliases: ['forma de pagamento', 'metodo de pagamento'],
      example: 'Transferência',
      parse: parsePaymentMethod,
    ),
    ImportColumn(
      key: 'paidAt',
      label: 'Data de pagamento',
      required: true,
      aliases: ['data', 'pago em'],
      example: '05/02/2026',
      parse: (raw) => parseImportDate(raw).toIso8601String(),
    ),
    const ImportColumn(
      key: 'reference',
      label: 'Referência',
      aliases: ['talao', 'comprovativo'],
      example: 'TRF-0001',
    ),
    const ImportColumn(
      key: 'description',
      label: 'Descrição',
      aliases: ['observacoes', 'item'],
      example: 'Propina de Fevereiro',
    ),
  ];

  @override
  Map<String, String> validateRecord(Map<String, Object?> record) =>
      (record['amountMinor'] as int? ?? 1) <= 0
      ? {'amountMinor': 'O valor deve ser maior que zero'}
      : const {};
}
