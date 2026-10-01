// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Invoice {

 String get id; String get institutionId; String? get campusId;@UtcDateTimeConverter() DateTime get createdAt;@UtcDateTimeConverter() DateTime get updatedAt;@UtcDateTimeConverter() DateTime? get deletedAt; String get syncState; String get studentId; String? get number;/// Série local (`FT 2026`); a numeração fiscal definitiva é do backend.
 String? get series;@UtcDateTimeConverter() DateTime? get issuedAt; InvoiceStatus get status; List<InvoiceLine> get lines;@MinorUnitConverter() int get taxMinor;@MinorUnitConverter() int get totalMinor;/// Preenchidos ao anular (a factura passa a `cancelled`).
 String? get cancelReason; String? get creditNoteId;
/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceCopyWith<Invoice> get copyWith => _$InvoiceCopyWithImpl<Invoice>(this as Invoice, _$identity);

  /// Serializes this Invoice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Invoice&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.number, number) || other.number == number)&&(identical(other.series, series) || other.series == series)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.lines, lines)&&(identical(other.taxMinor, taxMinor) || other.taxMinor == taxMinor)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.creditNoteId, creditNoteId) || other.creditNoteId == creditNoteId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,campusId,createdAt,updatedAt,deletedAt,syncState,studentId,number,series,issuedAt,status,const DeepCollectionEquality().hash(lines),taxMinor,totalMinor,cancelReason,creditNoteId);

@override
String toString() {
  return 'Invoice(id: $id, institutionId: $institutionId, campusId: $campusId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, studentId: $studentId, number: $number, series: $series, issuedAt: $issuedAt, status: $status, lines: $lines, taxMinor: $taxMinor, totalMinor: $totalMinor, cancelReason: $cancelReason, creditNoteId: $creditNoteId)';
}


}

/// @nodoc
abstract mixin class $InvoiceCopyWith<$Res>  {
  factory $InvoiceCopyWith(Invoice value, $Res Function(Invoice) _then) = _$InvoiceCopyWithImpl;
@useResult
$Res call({
 String id, String institutionId, String? campusId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String studentId, String? number, String? series,@UtcDateTimeConverter() DateTime? issuedAt, InvoiceStatus status, List<InvoiceLine> lines,@MinorUnitConverter() int taxMinor,@MinorUnitConverter() int totalMinor, String? cancelReason, String? creditNoteId
});




}
/// @nodoc
class _$InvoiceCopyWithImpl<$Res>
    implements $InvoiceCopyWith<$Res> {
  _$InvoiceCopyWithImpl(this._self, this._then);

  final Invoice _self;
  final $Res Function(Invoice) _then;

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? institutionId = null,Object? campusId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? studentId = null,Object? number = freezed,Object? series = freezed,Object? issuedAt = freezed,Object? status = null,Object? lines = null,Object? taxMinor = null,Object? totalMinor = null,Object? cancelReason = freezed,Object? creditNoteId = freezed,}) {
  return _then(Invoice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String?,series: freezed == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as String?,issuedAt: freezed == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InvoiceStatus,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<InvoiceLine>,taxMinor: null == taxMinor ? _self.taxMinor : taxMinor // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,creditNoteId: freezed == creditNoteId ? _self.creditNoteId : creditNoteId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Invoice].
extension InvoicePatterns on Invoice {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Invoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Invoice() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Invoice value)  $default,){
final _that = this;
switch (_that) {
case _Invoice():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Invoice value)?  $default,){
final _that = this;
switch (_that) {
case _Invoice() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  String? number,  String? series, @UtcDateTimeConverter()  DateTime? issuedAt,  InvoiceStatus status,  List<InvoiceLine> lines, @MinorUnitConverter()  int taxMinor, @MinorUnitConverter()  int totalMinor,  String? cancelReason,  String? creditNoteId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Invoice() when $default != null:
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.number,_that.series,_that.issuedAt,_that.status,_that.lines,_that.taxMinor,_that.totalMinor,_that.cancelReason,_that.creditNoteId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  String? number,  String? series, @UtcDateTimeConverter()  DateTime? issuedAt,  InvoiceStatus status,  List<InvoiceLine> lines, @MinorUnitConverter()  int taxMinor, @MinorUnitConverter()  int totalMinor,  String? cancelReason,  String? creditNoteId)  $default,) {final _that = this;
switch (_that) {
case _Invoice():
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.number,_that.series,_that.issuedAt,_that.status,_that.lines,_that.taxMinor,_that.totalMinor,_that.cancelReason,_that.creditNoteId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  String? number,  String? series, @UtcDateTimeConverter()  DateTime? issuedAt,  InvoiceStatus status,  List<InvoiceLine> lines, @MinorUnitConverter()  int taxMinor, @MinorUnitConverter()  int totalMinor,  String? cancelReason,  String? creditNoteId)?  $default,) {final _that = this;
switch (_that) {
case _Invoice() when $default != null:
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.number,_that.series,_that.issuedAt,_that.status,_that.lines,_that.taxMinor,_that.totalMinor,_that.cancelReason,_that.creditNoteId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Invoice implements Invoice {
  const _Invoice({required this.id, required this.institutionId, this.campusId, @UtcDateTimeConverter() required this.createdAt, @UtcDateTimeConverter() required this.updatedAt, @UtcDateTimeConverter() this.deletedAt, this.syncState = 'synced', required this.studentId, this.number, this.series, @UtcDateTimeConverter() this.issuedAt, this.status = InvoiceStatus.draft,  List<InvoiceLine> lines = const <InvoiceLine>[], @MinorUnitConverter() this.taxMinor = 0, @MinorUnitConverter() required this.totalMinor, this.cancelReason, this.creditNoteId}): _lines = lines;
  factory _Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);

@override final  String id;
@override final  String institutionId;
@override final  String? campusId;
@override@UtcDateTimeConverter() final  DateTime createdAt;
@override@UtcDateTimeConverter() final  DateTime updatedAt;
@override@UtcDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  String syncState;
@override final  String studentId;
@override final  String? number;
/// Série local (`FT 2026`); a numeração fiscal definitiva é do backend.
@override final  String? series;
@override@UtcDateTimeConverter() final  DateTime? issuedAt;
@override@JsonKey() final  InvoiceStatus status;
 final  List<InvoiceLine> _lines;
@override@JsonKey() List<InvoiceLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override@JsonKey()@MinorUnitConverter() final  int taxMinor;
@override@MinorUnitConverter() final  int totalMinor;
/// Preenchidos ao anular (a factura passa a `cancelled`).
@override final  String? cancelReason;
@override final  String? creditNoteId;

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceCopyWith<_Invoice> get copyWith => __$InvoiceCopyWithImpl<_Invoice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoiceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Invoice&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.number, number) || other.number == number)&&(identical(other.series, series) || other.series == series)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._lines, _lines)&&(identical(other.taxMinor, taxMinor) || other.taxMinor == taxMinor)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.creditNoteId, creditNoteId) || other.creditNoteId == creditNoteId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,campusId,createdAt,updatedAt,deletedAt,syncState,studentId,number,series,issuedAt,status,const DeepCollectionEquality().hash(_lines),taxMinor,totalMinor,cancelReason,creditNoteId);

@override
String toString() {
  return 'Invoice(id: $id, institutionId: $institutionId, campusId: $campusId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, studentId: $studentId, number: $number, series: $series, issuedAt: $issuedAt, status: $status, lines: $lines, taxMinor: $taxMinor, totalMinor: $totalMinor, cancelReason: $cancelReason, creditNoteId: $creditNoteId)';
}


}

/// @nodoc
abstract mixin class _$InvoiceCopyWith<$Res> implements $InvoiceCopyWith<$Res> {
  factory _$InvoiceCopyWith(_Invoice value, $Res Function(_Invoice) _then) = __$InvoiceCopyWithImpl;
@override @useResult
$Res call({
 String id, String institutionId, String? campusId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String studentId, String? number, String? series,@UtcDateTimeConverter() DateTime? issuedAt, InvoiceStatus status, List<InvoiceLine> lines,@MinorUnitConverter() int taxMinor,@MinorUnitConverter() int totalMinor, String? cancelReason, String? creditNoteId
});




}
/// @nodoc
class __$InvoiceCopyWithImpl<$Res>
    implements _$InvoiceCopyWith<$Res> {
  __$InvoiceCopyWithImpl(this._self, this._then);

  final _Invoice _self;
  final $Res Function(_Invoice) _then;

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? institutionId = null,Object? campusId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? studentId = null,Object? number = freezed,Object? series = freezed,Object? issuedAt = freezed,Object? status = null,Object? lines = null,Object? taxMinor = null,Object? totalMinor = null,Object? cancelReason = freezed,Object? creditNoteId = freezed,}) {
  return _then(_Invoice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String?,series: freezed == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as String?,issuedAt: freezed == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InvoiceStatus,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<InvoiceLine>,taxMinor: null == taxMinor ? _self.taxMinor : taxMinor // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,creditNoteId: freezed == creditNoteId ? _self.creditNoteId : creditNoteId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$InvoiceLine {

 String get chargeId; String get description;@MinorUnitConverter() int get amountMinor;/// Taxa de IVA em pontos-base (1400 = 14 %); 0 = isento.
 int get taxRateBp;@MinorUnitConverter() int get taxMinor; String? get exemptionReason;
/// Create a copy of InvoiceLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceLineCopyWith<InvoiceLine> get copyWith => _$InvoiceLineCopyWithImpl<InvoiceLine>(this as InvoiceLine, _$identity);

  /// Serializes this InvoiceLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoiceLine&&(identical(other.chargeId, chargeId) || other.chargeId == chargeId)&&(identical(other.description, description) || other.description == description)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.taxRateBp, taxRateBp) || other.taxRateBp == taxRateBp)&&(identical(other.taxMinor, taxMinor) || other.taxMinor == taxMinor)&&(identical(other.exemptionReason, exemptionReason) || other.exemptionReason == exemptionReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chargeId,description,amountMinor,taxRateBp,taxMinor,exemptionReason);

@override
String toString() {
  return 'InvoiceLine(chargeId: $chargeId, description: $description, amountMinor: $amountMinor, taxRateBp: $taxRateBp, taxMinor: $taxMinor, exemptionReason: $exemptionReason)';
}


}

/// @nodoc
abstract mixin class $InvoiceLineCopyWith<$Res>  {
  factory $InvoiceLineCopyWith(InvoiceLine value, $Res Function(InvoiceLine) _then) = _$InvoiceLineCopyWithImpl;
@useResult
$Res call({
 String chargeId, String description,@MinorUnitConverter() int amountMinor, int taxRateBp,@MinorUnitConverter() int taxMinor, String? exemptionReason
});




}
/// @nodoc
class _$InvoiceLineCopyWithImpl<$Res>
    implements $InvoiceLineCopyWith<$Res> {
  _$InvoiceLineCopyWithImpl(this._self, this._then);

  final InvoiceLine _self;
  final $Res Function(InvoiceLine) _then;

/// Create a copy of InvoiceLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chargeId = null,Object? description = null,Object? amountMinor = null,Object? taxRateBp = null,Object? taxMinor = null,Object? exemptionReason = freezed,}) {
  return _then(InvoiceLine(
chargeId: null == chargeId ? _self.chargeId : chargeId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,taxRateBp: null == taxRateBp ? _self.taxRateBp : taxRateBp // ignore: cast_nullable_to_non_nullable
as int,taxMinor: null == taxMinor ? _self.taxMinor : taxMinor // ignore: cast_nullable_to_non_nullable
as int,exemptionReason: freezed == exemptionReason ? _self.exemptionReason : exemptionReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InvoiceLine].
extension InvoiceLinePatterns on InvoiceLine {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvoiceLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvoiceLine() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvoiceLine value)  $default,){
final _that = this;
switch (_that) {
case _InvoiceLine():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvoiceLine value)?  $default,){
final _that = this;
switch (_that) {
case _InvoiceLine() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String chargeId,  String description, @MinorUnitConverter()  int amountMinor,  int taxRateBp, @MinorUnitConverter()  int taxMinor,  String? exemptionReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvoiceLine() when $default != null:
return $default(_that.chargeId,_that.description,_that.amountMinor,_that.taxRateBp,_that.taxMinor,_that.exemptionReason);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String chargeId,  String description, @MinorUnitConverter()  int amountMinor,  int taxRateBp, @MinorUnitConverter()  int taxMinor,  String? exemptionReason)  $default,) {final _that = this;
switch (_that) {
case _InvoiceLine():
return $default(_that.chargeId,_that.description,_that.amountMinor,_that.taxRateBp,_that.taxMinor,_that.exemptionReason);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String chargeId,  String description, @MinorUnitConverter()  int amountMinor,  int taxRateBp, @MinorUnitConverter()  int taxMinor,  String? exemptionReason)?  $default,) {final _that = this;
switch (_that) {
case _InvoiceLine() when $default != null:
return $default(_that.chargeId,_that.description,_that.amountMinor,_that.taxRateBp,_that.taxMinor,_that.exemptionReason);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _InvoiceLine implements InvoiceLine {
  const _InvoiceLine({required this.chargeId, required this.description, @MinorUnitConverter() required this.amountMinor, this.taxRateBp = 0, @MinorUnitConverter() this.taxMinor = 0, this.exemptionReason});
  factory _InvoiceLine.fromJson(Map<String, dynamic> json) => _$InvoiceLineFromJson(json);

@override final  String chargeId;
@override final  String description;
@override@MinorUnitConverter() final  int amountMinor;
/// Taxa de IVA em pontos-base (1400 = 14 %); 0 = isento.
@override@JsonKey() final  int taxRateBp;
@override@JsonKey()@MinorUnitConverter() final  int taxMinor;
@override final  String? exemptionReason;

/// Create a copy of InvoiceLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceLineCopyWith<_InvoiceLine> get copyWith => __$InvoiceLineCopyWithImpl<_InvoiceLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoiceLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoiceLine&&(identical(other.chargeId, chargeId) || other.chargeId == chargeId)&&(identical(other.description, description) || other.description == description)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.taxRateBp, taxRateBp) || other.taxRateBp == taxRateBp)&&(identical(other.taxMinor, taxMinor) || other.taxMinor == taxMinor)&&(identical(other.exemptionReason, exemptionReason) || other.exemptionReason == exemptionReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chargeId,description,amountMinor,taxRateBp,taxMinor,exemptionReason);

@override
String toString() {
  return 'InvoiceLine(chargeId: $chargeId, description: $description, amountMinor: $amountMinor, taxRateBp: $taxRateBp, taxMinor: $taxMinor, exemptionReason: $exemptionReason)';
}


}

/// @nodoc
abstract mixin class _$InvoiceLineCopyWith<$Res> implements $InvoiceLineCopyWith<$Res> {
  factory _$InvoiceLineCopyWith(_InvoiceLine value, $Res Function(_InvoiceLine) _then) = __$InvoiceLineCopyWithImpl;
@override @useResult
$Res call({
 String chargeId, String description,@MinorUnitConverter() int amountMinor, int taxRateBp,@MinorUnitConverter() int taxMinor, String? exemptionReason
});




}
/// @nodoc
class __$InvoiceLineCopyWithImpl<$Res>
    implements _$InvoiceLineCopyWith<$Res> {
  __$InvoiceLineCopyWithImpl(this._self, this._then);

  final _InvoiceLine _self;
  final $Res Function(_InvoiceLine) _then;

/// Create a copy of InvoiceLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chargeId = null,Object? description = null,Object? amountMinor = null,Object? taxRateBp = null,Object? taxMinor = null,Object? exemptionReason = freezed,}) {
  return _then(_InvoiceLine(
chargeId: null == chargeId ? _self.chargeId : chargeId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,taxRateBp: null == taxRateBp ? _self.taxRateBp : taxRateBp // ignore: cast_nullable_to_non_nullable
as int,taxMinor: null == taxMinor ? _self.taxMinor : taxMinor // ignore: cast_nullable_to_non_nullable
as int,exemptionReason: freezed == exemptionReason ? _self.exemptionReason : exemptionReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
