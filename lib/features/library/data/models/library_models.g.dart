// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookModel _$BookModelFromJson(Map<String, dynamic> json) => _BookModel(
  id: json['id'] as String,
  isbn: json['isbn'] as String,
  title: json['title'] as String,
  author: json['author'] as String,
  category: json['category'] as String,
  publisher: json['publisher'] as String?,
  year: (json['year'] as num?)?.toInt(),
  totalCopies: (json['totalCopies'] as num?)?.toInt() ?? 0,
  availableCopies: (json['availableCopies'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$BookModelToJson(_BookModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isbn': instance.isbn,
      'title': instance.title,
      'author': instance.author,
      'category': instance.category,
      'publisher': instance.publisher,
      'year': instance.year,
      'totalCopies': instance.totalCopies,
      'availableCopies': instance.availableCopies,
    };

_CopyModel _$CopyModelFromJson(Map<String, dynamic> json) => _CopyModel(
  id: json['id'] as String,
  bookId: json['bookId'] as String,
  barcode: json['barcode'] as String,
  status:
      $enumDecodeNullable(_$CopyStatusEnumMap, json['status']) ??
      CopyStatus.available,
);

Map<String, dynamic> _$CopyModelToJson(_CopyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookId': instance.bookId,
      'barcode': instance.barcode,
      'status': _$CopyStatusEnumMap[instance.status]!,
    };

const _$CopyStatusEnumMap = {
  CopyStatus.available: 'available',
  CopyStatus.loaned: 'loaned',
  CopyStatus.reserved: 'reserved',
  CopyStatus.lost: 'lost',
  CopyStatus.damaged: 'damaged',
};

_LoanModel _$LoanModelFromJson(Map<String, dynamic> json) => _LoanModel(
  id: json['id'] as String,
  copyId: json['copyId'] as String,
  bookTitle: json['bookTitle'] as String,
  barcode: json['barcode'] as String,
  borrowerId: json['borrowerId'] as String,
  borrowerName: json['borrowerName'] as String,
  loanedAt: const UtcDateTimeConverter().fromJson(json['loanedAt'] as String),
  dueAt: const UtcDateTimeConverter().fromJson(json['dueAt'] as String),
  returnedAt: _$JsonConverterFromJson<String, DateTime>(
    json['returnedAt'],
    const UtcDateTimeConverter().fromJson,
  ),
  status:
      $enumDecodeNullable(_$LoanStatusEnumMap, json['status']) ??
      LoanStatus.active,
  fineCents: (json['fineCents'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$LoanModelToJson(_LoanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'copyId': instance.copyId,
      'bookTitle': instance.bookTitle,
      'barcode': instance.barcode,
      'borrowerId': instance.borrowerId,
      'borrowerName': instance.borrowerName,
      'loanedAt': const UtcDateTimeConverter().toJson(instance.loanedAt),
      'dueAt': const UtcDateTimeConverter().toJson(instance.dueAt),
      'returnedAt': _$JsonConverterToJson<String, DateTime>(
        instance.returnedAt,
        const UtcDateTimeConverter().toJson,
      ),
      'status': _$LoanStatusEnumMap[instance.status]!,
      'fineCents': instance.fineCents,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$LoanStatusEnumMap = {
  LoanStatus.active: 'active',
  LoanStatus.overdue: 'overdue',
  LoanStatus.returned: 'returned',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_FineModel _$FineModelFromJson(Map<String, dynamic> json) => _FineModel(
  id: json['id'] as String,
  loanId: json['loanId'] as String,
  borrowerId: json['borrowerId'] as String,
  borrowerName: json['borrowerName'] as String,
  bookTitle: json['bookTitle'] as String,
  daysLate: (json['daysLate'] as num).toInt(),
  amountCents: (json['amountCents'] as num).toInt(),
  status:
      $enumDecodeNullable(_$FineStatusEnumMap, json['status']) ??
      FineStatus.pending,
  createdAt: const UtcDateTimeConverter().fromJson(json['createdAt'] as String),
  paidAt: _$JsonConverterFromJson<String, DateTime>(
    json['paidAt'],
    const UtcDateTimeConverter().fromJson,
  ),
);

Map<String, dynamic> _$FineModelToJson(_FineModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'loanId': instance.loanId,
      'borrowerId': instance.borrowerId,
      'borrowerName': instance.borrowerName,
      'bookTitle': instance.bookTitle,
      'daysLate': instance.daysLate,
      'amountCents': instance.amountCents,
      'status': _$FineStatusEnumMap[instance.status]!,
      'createdAt': const UtcDateTimeConverter().toJson(instance.createdAt),
      'paidAt': _$JsonConverterToJson<String, DateTime>(
        instance.paidAt,
        const UtcDateTimeConverter().toJson,
      ),
    };

const _$FineStatusEnumMap = {
  FineStatus.pending: 'pending',
  FineStatus.paid: 'paid',
};

_ReservationModel _$ReservationModelFromJson(Map<String, dynamic> json) =>
    _ReservationModel(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      bookTitle: json['bookTitle'] as String,
      borrowerId: json['borrowerId'] as String,
      borrowerName: json['borrowerName'] as String,
      status:
          $enumDecodeNullable(_$ReservationStatusEnumMap, json['status']) ??
          ReservationStatus.pending,
      createdAt: const UtcDateTimeConverter().fromJson(
        json['createdAt'] as String,
      ),
    );

Map<String, dynamic> _$ReservationModelToJson(_ReservationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookId': instance.bookId,
      'bookTitle': instance.bookTitle,
      'borrowerId': instance.borrowerId,
      'borrowerName': instance.borrowerName,
      'status': _$ReservationStatusEnumMap[instance.status]!,
      'createdAt': const UtcDateTimeConverter().toJson(instance.createdAt),
    };

const _$ReservationStatusEnumMap = {
  ReservationStatus.pending: 'pending',
  ReservationStatus.ready: 'ready',
  ReservationStatus.fulfilled: 'fulfilled',
  ReservationStatus.cancelled: 'cancelled',
};
