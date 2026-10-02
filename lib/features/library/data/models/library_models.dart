import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'library_models.freezed.dart';
part 'library_models.g.dart';

/// Estado do exemplar: `loaned`/`reserved` são geridos pelos empréstimos e
/// reservas; `lost`/`damaged` retiram-no da circulação.
enum CopyStatus { available, loaned, reserved, lost, damaged }

enum LoanStatus { active, overdue, returned }

enum FineStatus { pending, paid }

/// `ready`: um exemplar devolvido foi guardado para o leitor.
enum ReservationStatus { pending, ready, fulfilled, cancelled }

/// Valor no formato da API (`filter[status]`).
extension LibraryStatusWire on Enum {
  String get wire => name;
}

/// Obra do acervo (título); os exemplares físicos são [CopyModel].
@freezed
abstract class BookModel with _$BookModel {
  const factory BookModel({
    required String id,

    /// ISBN normalizado (único).
    required String isbn,
    required String title,
    required String author,
    required String category,
    String? publisher,
    int? year,

    /// Calculados pelo servidor.
    @Default(0) int totalCopies,
    @Default(0) int availableCopies,
  }) = _BookModel;

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);
}

/// Exemplar físico de uma obra, identificado por código de barras.
@freezed
abstract class CopyModel with _$CopyModel {
  const factory CopyModel({
    required String id,
    required String bookId,
    required String barcode,
    @Default(CopyStatus.available) CopyStatus status,
  }) = _CopyModel;

  factory CopyModel.fromJson(Map<String, dynamic> json) =>
      _$CopyModelFromJson(json);
}

/// Empréstimo de um exemplar a um leitor (identificado pelo cartão).
@freezed
abstract class LoanModel with _$LoanModel {
  const factory LoanModel({
    required String id,
    required String copyId,
    required String bookTitle,
    required String barcode,
    required String borrowerId,
    required String borrowerName,
    @UtcDateTimeConverter() required DateTime loanedAt,
    @UtcDateTimeConverter() required DateTime dueAt,
    @UtcDateTimeConverter() DateTime? returnedAt,

    /// `overdue` é calculado pelo servidor (activo e fora de prazo).
    @Default(LoanStatus.active) LoanStatus status,

    /// Multa gerada na devolução, se houve atraso.
    @Default(0) int fineCents,
  }) = _LoanModel;

  factory LoanModel.fromJson(Map<String, dynamic> json) =>
      _$LoanModelFromJson(json);
}

/// Multa por atraso na devolução; bloqueia novos empréstimos até ser paga.
@freezed
abstract class FineModel with _$FineModel {
  const factory FineModel({
    required String id,
    required String loanId,
    required String borrowerId,
    required String borrowerName,
    required String bookTitle,
    required int daysLate,

    /// Menor unidade (Kz × 100).
    required int amountCents,
    @Default(FineStatus.pending) FineStatus status,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() DateTime? paidAt,
  }) = _FineModel;

  factory FineModel.fromJson(Map<String, dynamic> json) =>
      _$FineModelFromJson(json);
}

/// Reserva de uma obra sem exemplar disponível.
@freezed
abstract class ReservationModel with _$ReservationModel {
  const factory ReservationModel({
    required String id,
    required String bookId,
    required String bookTitle,
    required String borrowerId,
    required String borrowerName,
    @Default(ReservationStatus.pending) ReservationStatus status,
    @UtcDateTimeConverter() required DateTime createdAt,
  }) = _ReservationModel;

  factory ReservationModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationModelFromJson(json);
}
