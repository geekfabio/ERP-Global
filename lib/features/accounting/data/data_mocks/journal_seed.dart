import '../../../../core/utils/seed_generator.dart';
import '../models/journal_models.dart';
import 'accounting_seed.dart';

/// Lançamentos e títulos de desenvolvimento, coerentes com o plano de contas.
class JournalSeed {
  const JournalSeed({required this.entries, required this.openItems});

  final List<JournalEntryModel> entries;
  final List<OpenItemModel> openItems;
}

JournalSeed buildJournalSeed({int seed = 61}) {
  final gen = SeedGenerator(seed);
  final at = DateTime.utc(2026, 1, 1);
  final byCode = {for (final a in buildAccountingSeed().accounts) a.code: a.id};

  JournalLineModel d(String code, int v) =>
      JournalLineModel(accountId: byCode[code]!, debitMinor: v);
  JournalLineModel c(String code, int v) =>
      JournalLineModel(accountId: byCode[code]!, creditMinor: v);

  var n = 0;
  JournalEntryModel entry(
    DateTime date,
    String description,
    List<JournalLineModel> lines, {
    JournalSource source = JournalSource.manual,
    String? sourceRef,
  }) => JournalEntryModel(
    id: gen.ulid(at.add(Duration(minutes: n))),
    number: ++n,
    date: date,
    description: description,
    lines: lines,
    source: source,
    sourceRef: sourceRef,
  );

  final capital = entry(DateTime.utc(2026, 1, 2), 'Realização de capital', [
    d('43', 500000000),
    c('51', 500000000),
  ]);
  final tuition = entry(
    DateTime.utc(2026, 2, 5),
    'Propinas de Fevereiro',
    [d('311', 120000000), c('721', 120000000)],
    source: JournalSource.openItem,
    sourceRef: 'open-item:seed-receivable',
  );
  final supplies = entry(
    DateTime.utc(2026, 2, 10),
    'Material didáctico',
    [d('62', 35000000), c('321', 35000000)],
    source: JournalSource.openItem,
    sourceRef: 'open-item:seed-payable',
  );
  final received = entry(DateTime.utc(2026, 2, 20), 'Recebimento de propinas', [
    d('45', 80000000),
    c('311', 80000000),
  ]);

  return JournalSeed(
    entries: [capital, tuition, supplies, received],
    openItems: [
      OpenItemModel(
        id: gen.ulid(at.add(const Duration(days: 40))),
        kind: OpenItemKind.receivable,
        party: 'Encarregados — 7.ª classe',
        description: 'Propinas de Fevereiro',
        amountMinor: 120000000,
        paidMinor: 80000000,
        issueDate: DateTime.utc(2026, 2, 5),
        dueDate: DateTime.utc(2026, 2, 28),
        status: OpenItemStatus.partiallyPaid,
        counterAccountId: byCode['721']!,
        entryId: tuition.id,
      ),
      OpenItemModel(
        id: gen.ulid(at.add(const Duration(days: 41))),
        kind: OpenItemKind.payable,
        party: 'Papelaria Central, Lda.',
        description: 'Material didáctico',
        amountMinor: 35000000,
        issueDate: DateTime.utc(2026, 2, 10),
        dueDate: DateTime.utc(2026, 3, 10),
        counterAccountId: byCode['62']!,
        entryId: supplies.id,
      ),
    ],
  );
}
