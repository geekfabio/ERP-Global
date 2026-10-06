import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/pdf/pdf_file_saver.dart';
import '../../../../core/pdf/pdf_template_engine.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../settings/presentation/providers/pdf_letterhead_provider.dart';
import '../../data/mock_api/cards_mock_handlers.dart';
import '../../data/models/card_model.dart';
import '../../data/repositories/api_card_repository.dart';
import '../../domain/card_repository.dart';
import '../pdf/school_card_pdf_template.dart';

final cardRepositoryProvider = Provider<CardRepository>(
  (ref) => ApiCardRepository(ref.watch(apiClientProvider)),
);

final schoolCardPdfEngineProvider = Provider<PdfTemplateEngine>(
  (ref) => const PdfTemplateEngine(),
);

final schoolCardPdfSaverProvider = Provider<PdfFileSaver>(
  (ref) => const PickerPdfFileSaver(),
);

class SchoolCardPdfService {
  SchoolCardPdfService(this._ref);
  final Ref _ref;

  Future<void> export(CardModel card) async {
    final toast = _ref.read(toastProvider.notifier);
    try {
      final template = SchoolCardPdfTemplate(card);
      final bytes = await _ref
          .read(schoolCardPdfEngineProvider)
          .render(
            letterhead: await _ref
                .read(institutionPdfLetterheadProvider)
                .load(),
            template: template,
            generatedAt: DateTime.now(),
          );
      final saved = await _ref
          .read(schoolCardPdfSaverProvider)
          .save(fileName: template.fileName, bytes: bytes);
      if (saved) toast.success('Cartão guardado em PDF.');
    } on Object {
      toast.error('Não foi possível gerar o cartão.');
    }
  }
}

final schoolCardPdfServiceProvider = Provider<SchoolCardPdfService>(
  SchoolCardPdfService.new,
);

/// Handlers mock do módulo, registados em `main.dart` (só com mock activo).
final cardsMockHandlersProvider = Provider<CardsMockHandlers>(
  (ref) => CardsMockHandlers(),
);

/// Todos os cartões (percorre as páginas do servidor); a tabela pesquisa e
/// ordena localmente. Falhas chegam à UI como `AsyncError`.
final cardListProvider = FutureProvider.autoDispose<List<CardModel>>((
  ref,
) async {
  final repository = ref.watch(cardRepositoryProvider);
  final items = <CardModel>[];
  var page = 1;
  while (true) {
    final result = (await repository.list(
      page: page,
      pageSize: 100,
    )).getOrThrow();
    items.addAll(result.items);
    if (!result.meta.hasNext) return items;
    page++;
  }
}, retry: (_, _) => null);
