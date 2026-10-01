// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discount.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Discount {

 String get id; String get institutionId; String? get campusId;@UtcDateTimeConverter() DateTime get createdAt;@UtcDateTimeConverter() DateTime get updatedAt;@UtcDateTimeConverter() DateTime? get deletedAt; String get syncState; String get studentId; DiscountKind get kind; DiscountReason get reason; int get value; FeeType? get feeType;@DateOnlyConverter() DateTime get validFrom;@DateOnlyConverter() DateTime? get validUntil; String? get note; DiscountStatus get status; String? get decisionNote;@UtcDateTimeConverter() DateTime? get decidedAt;
/// Create a copy of Discount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscountCopyWith<Discount> get copyWith => _$DiscountCopyWithImpl<Discount>(this as Discount, _$identity);

  /// Serializes this Discount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Discount&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.value, value) || other.value == value)&&(identical(other.feeType, feeType) || other.feeType == feeType)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil)&&(identical(other.note, note) || other.note == note)&&(identical(other.status, status) || other.status == status)&&(identical(other.decisionNote, decisionNote) || other.decisionNote == decisionNote)&&(identical(other.decidedAt, decidedAt) || other.decidedAt == decidedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,campusId,createdAt,updatedAt,deletedAt,syncState,studentId,kind,reason,value,feeType,validFrom,validUntil,note,status,decisionNote,decidedAt);

@override
String toString() {
  return 'Discount(id: $id, institutionId: $institutionId, campusId: $campusId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, studentId: $studentId, kind: $kind, reason: $reason, value: $value, feeType: $feeType, validFrom: $validFrom, validUntil: $validUntil, note: $note, status: $status, decisionNote: $decisionNote, decidedAt: $decidedAt)';
}


}

/// @nodoc
abstract mixin class $DiscountCopyWith<$Res>  {
  factory $DiscountCopyWith(Discount value, $Res Function(Discount) _then) = _$DiscountCopyWithImpl;
@useResult
$Res call({
 String id, String institutionId, String? campusId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String studentId, DiscountKind kind, DiscountReason reason, int value, FeeType? feeType,@DateOnlyConverter() DateTime validFrom,@DateOnlyConverter() DateTime? validUntil, String? note, DiscountStatus status, String? decisionNote,@UtcDateTimeConverter() DateTime? decidedAt
});




}
/// @nodoc
class _$DiscountCopyWithImpl<$Res>
    implements $DiscountCopyWith<$Res> {
  _$DiscountCopyWithImpl(this._self, this._then);

  final Discount _self;
  final $Res Function(Discount) _then;

/// Create a copy of Discount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? institutionId = null,Object? campusId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? studentId = null,Object? kind = null,Object? reason = null,Object? value = null,Object? feeType = freezed,Object? validFrom = null,Object? validUntil = freezed,Object? note = freezed,Object? status = null,Object? decisionNote = freezed,Object? decidedAt = freezed,}) {
  return _then(Discount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DiscountKind,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as DiscountReason,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,feeType: freezed == feeType ? _self.feeType : feeType // ignore: cast_nullable_to_non_nullable
as FeeType?,validFrom: null == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime,validUntil: freezed == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DiscountStatus,decisionNote: freezed == decisionNote ? _self.decisionNote : decisionNote // ignore: cast_nullable_to_non_nullable
as String?,decidedAt: freezed == decidedAt ? _self.decidedAt : decidedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Discount].
extension DiscountPatterns on Discount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Discount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Discount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Discount value)  $default,){
final _that = this;
switch (_that) {
case _Discount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Discount value)?  $default,){
final _that = this;
switch (_that) {
case _Discount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  DiscountKind kind,  DiscountReason reason,  int value,  FeeType? feeType, @DateOnlyConverter()  DateTime validFrom, @DateOnlyConverter()  DateTime? validUntil,  String? note,  DiscountStatus status,  String? decisionNote, @UtcDateTimeConverter()  DateTime? decidedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Discount() when $default != null:
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.kind,_that.reason,_that.value,_that.feeType,_that.validFrom,_that.validUntil,_that.note,_that.status,_that.decisionNote,_that.decidedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  DiscountKind kind,  DiscountReason reason,  int value,  FeeType? feeType, @DateOnlyConverter()  DateTime validFrom, @DateOnlyConverter()  DateTime? validUntil,  String? note,  DiscountStatus status,  String? decisionNote, @UtcDateTimeConverter()  DateTime? decidedAt)  $default,) {final _that = this;
switch (_that) {
case _Discount():
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.kind,_that.reason,_that.value,_that.feeType,_that.validFrom,_that.validUntil,_that.note,_that.status,_that.decisionNote,_that.decidedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  DiscountKind kind,  DiscountReason reason,  int value,  FeeType? feeType, @DateOnlyConverter()  DateTime validFrom, @DateOnlyConverter()  DateTime? validUntil,  String? note,  DiscountStatus status,  String? decisionNote, @UtcDateTimeConverter()  DateTime? decidedAt)?  $default,) {final _that = this;
switch (_that) {
case _Discount() when $default != null:
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.kind,_that.reason,_that.value,_that.feeType,_that.validFrom,_that.validUntil,_that.note,_that.status,_that.decisionNote,_that.decidedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Discount implements Discount {
  const _Discount({required this.id, required this.institutionId, this.campusId, @UtcDateTimeConverter() required this.createdAt, @UtcDateTimeConverter() required this.updatedAt, @UtcDateTimeConverter() this.deletedAt, this.syncState = 'synced', required this.studentId, required this.kind, required this.reason, required this.value, this.feeType, @DateOnlyConverter() required this.validFrom, @DateOnlyConverter() this.validUntil, this.note, this.status = DiscountStatus.pending, this.decisionNote, @UtcDateTimeConverter() this.decidedAt});
  factory _Discount.fromJson(Map<String, dynamic> json) => _$DiscountFromJson(json);

@override final  String id;
@override final  String institutionId;
@override final  String? campusId;
@override@UtcDateTimeConverter() final  DateTime createdAt;
@override@UtcDateTimeConverter() final  DateTime updatedAt;
@override@UtcDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  String syncState;
@override final  String studentId;
@override final  DiscountKind kind;
@override final  DiscountReason reason;
@override final  int value;
@override final  FeeType? feeType;
@override@DateOnlyConverter() final  DateTime validFrom;
@override@DateOnlyConverter() final  DateTime? validUntil;
@override final  String? note;
@override@JsonKey() final  DiscountStatus status;
@override final  String? decisionNote;
@override@UtcDateTimeConverter() final  DateTime? decidedAt;

/// Create a copy of Discount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscountCopyWith<_Discount> get copyWith => __$DiscountCopyWithImpl<_Discount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiscountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Discount&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.value, value) || other.value == value)&&(identical(other.feeType, feeType) || other.feeType == feeType)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil)&&(identical(other.note, note) || other.note == note)&&(identical(other.status, status) || other.status == status)&&(identical(other.decisionNote, decisionNote) || other.decisionNote == decisionNote)&&(identical(other.decidedAt, decidedAt) || other.decidedAt == decidedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,campusId,createdAt,updatedAt,deletedAt,syncState,studentId,kind,reason,value,feeType,validFrom,validUntil,note,status,decisionNote,decidedAt);

@override
String toString() {
  return 'Discount(id: $id, institutionId: $institutionId, campusId: $campusId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, studentId: $studentId, kind: $kind, reason: $reason, value: $value, feeType: $feeType, validFrom: $validFrom, validUntil: $validUntil, note: $note, status: $status, decisionNote: $decisionNote, decidedAt: $decidedAt)';
}


}

/// @nodoc
abstract mixin class _$DiscountCopyWith<$Res> implements $DiscountCopyWith<$Res> {
  factory _$DiscountCopyWith(_Discount value, $Res Function(_Discount) _then) = __$DiscountCopyWithImpl;
@override @useResult
$Res call({
 String id, String institutionId, String? campusId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String studentId, DiscountKind kind, DiscountReason reason, int value, FeeType? feeType,@DateOnlyConverter() DateTime validFrom,@DateOnlyConverter() DateTime? validUntil, String? note, DiscountStatus status, String? decisionNote,@UtcDateTimeConverter() DateTime? decidedAt
});




}
/// @nodoc
class __$DiscountCopyWithImpl<$Res>
    implements _$DiscountCopyWith<$Res> {
  __$DiscountCopyWithImpl(this._self, this._then);

  final _Discount _self;
  final $Res Function(_Discount) _then;

/// Create a copy of Discount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? institutionId = null,Object? campusId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? studentId = null,Object? kind = null,Object? reason = null,Object? value = null,Object? feeType = freezed,Object? validFrom = null,Object? validUntil = freezed,Object? note = freezed,Object? status = null,Object? decisionNote = freezed,Object? decidedAt = freezed,}) {
  return _then(_Discount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DiscountKind,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as DiscountReason,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,feeType: freezed == feeType ? _self.feeType : feeType // ignore: cast_nullable_to_non_nullable
as FeeType?,validFrom: null == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime,validUntil: freezed == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DiscountStatus,decisionNote: freezed == decisionNote ? _self.decisionNote : decisionNote // ignore: cast_nullable_to_non_nullable
as String?,decidedAt: freezed == decidedAt ? _self.decidedAt : decidedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
