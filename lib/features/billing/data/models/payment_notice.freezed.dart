// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_notice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentNotice {

 String get id; String get institutionId; String? get campusId;@UtcDateTimeConverter() DateTime get createdAt;@UtcDateTimeConverter() DateTime get updatedAt;@UtcDateTimeConverter() DateTime? get deletedAt; String get syncState; String get studentId; String get chargeId; NoticeKind get kind;@DateOnlyConverter() DateTime get dueDate;@MinorUnitConverter() int get amountMinor; String get message;@UtcDateTimeConverter() DateTime get sentAt;
/// Create a copy of PaymentNotice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentNoticeCopyWith<PaymentNotice> get copyWith => _$PaymentNoticeCopyWithImpl<PaymentNotice>(this as PaymentNotice, _$identity);

  /// Serializes this PaymentNotice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentNotice&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.chargeId, chargeId) || other.chargeId == chargeId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.message, message) || other.message == message)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,campusId,createdAt,updatedAt,deletedAt,syncState,studentId,chargeId,kind,dueDate,amountMinor,message,sentAt);

@override
String toString() {
  return 'PaymentNotice(id: $id, institutionId: $institutionId, campusId: $campusId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, studentId: $studentId, chargeId: $chargeId, kind: $kind, dueDate: $dueDate, amountMinor: $amountMinor, message: $message, sentAt: $sentAt)';
}


}

/// @nodoc
abstract mixin class $PaymentNoticeCopyWith<$Res>  {
  factory $PaymentNoticeCopyWith(PaymentNotice value, $Res Function(PaymentNotice) _then) = _$PaymentNoticeCopyWithImpl;
@useResult
$Res call({
 String id, String institutionId, String? campusId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String studentId, String chargeId, NoticeKind kind,@DateOnlyConverter() DateTime dueDate,@MinorUnitConverter() int amountMinor, String message,@UtcDateTimeConverter() DateTime sentAt
});




}
/// @nodoc
class _$PaymentNoticeCopyWithImpl<$Res>
    implements $PaymentNoticeCopyWith<$Res> {
  _$PaymentNoticeCopyWithImpl(this._self, this._then);

  final PaymentNotice _self;
  final $Res Function(PaymentNotice) _then;

/// Create a copy of PaymentNotice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? institutionId = null,Object? campusId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? studentId = null,Object? chargeId = null,Object? kind = null,Object? dueDate = null,Object? amountMinor = null,Object? message = null,Object? sentAt = null,}) {
  return _then(PaymentNotice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,chargeId: null == chargeId ? _self.chargeId : chargeId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as NoticeKind,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentNotice].
extension PaymentNoticePatterns on PaymentNotice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentNotice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentNotice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentNotice value)  $default,){
final _that = this;
switch (_that) {
case _PaymentNotice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentNotice value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentNotice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  String chargeId,  NoticeKind kind, @DateOnlyConverter()  DateTime dueDate, @MinorUnitConverter()  int amountMinor,  String message, @UtcDateTimeConverter()  DateTime sentAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentNotice() when $default != null:
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.chargeId,_that.kind,_that.dueDate,_that.amountMinor,_that.message,_that.sentAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  String chargeId,  NoticeKind kind, @DateOnlyConverter()  DateTime dueDate, @MinorUnitConverter()  int amountMinor,  String message, @UtcDateTimeConverter()  DateTime sentAt)  $default,) {final _that = this;
switch (_that) {
case _PaymentNotice():
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.chargeId,_that.kind,_that.dueDate,_that.amountMinor,_that.message,_that.sentAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  String chargeId,  NoticeKind kind, @DateOnlyConverter()  DateTime dueDate, @MinorUnitConverter()  int amountMinor,  String message, @UtcDateTimeConverter()  DateTime sentAt)?  $default,) {final _that = this;
switch (_that) {
case _PaymentNotice() when $default != null:
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.chargeId,_that.kind,_that.dueDate,_that.amountMinor,_that.message,_that.sentAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PaymentNotice implements PaymentNotice {
  const _PaymentNotice({required this.id, required this.institutionId, this.campusId, @UtcDateTimeConverter() required this.createdAt, @UtcDateTimeConverter() required this.updatedAt, @UtcDateTimeConverter() this.deletedAt, this.syncState = 'synced', required this.studentId, required this.chargeId, required this.kind, @DateOnlyConverter() required this.dueDate, @MinorUnitConverter() required this.amountMinor, required this.message, @UtcDateTimeConverter() required this.sentAt});
  factory _PaymentNotice.fromJson(Map<String, dynamic> json) => _$PaymentNoticeFromJson(json);

@override final  String id;
@override final  String institutionId;
@override final  String? campusId;
@override@UtcDateTimeConverter() final  DateTime createdAt;
@override@UtcDateTimeConverter() final  DateTime updatedAt;
@override@UtcDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  String syncState;
@override final  String studentId;
@override final  String chargeId;
@override final  NoticeKind kind;
@override@DateOnlyConverter() final  DateTime dueDate;
@override@MinorUnitConverter() final  int amountMinor;
@override final  String message;
@override@UtcDateTimeConverter() final  DateTime sentAt;

/// Create a copy of PaymentNotice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentNoticeCopyWith<_PaymentNotice> get copyWith => __$PaymentNoticeCopyWithImpl<_PaymentNotice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentNoticeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentNotice&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.chargeId, chargeId) || other.chargeId == chargeId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.message, message) || other.message == message)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,campusId,createdAt,updatedAt,deletedAt,syncState,studentId,chargeId,kind,dueDate,amountMinor,message,sentAt);

@override
String toString() {
  return 'PaymentNotice(id: $id, institutionId: $institutionId, campusId: $campusId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, studentId: $studentId, chargeId: $chargeId, kind: $kind, dueDate: $dueDate, amountMinor: $amountMinor, message: $message, sentAt: $sentAt)';
}


}

/// @nodoc
abstract mixin class _$PaymentNoticeCopyWith<$Res> implements $PaymentNoticeCopyWith<$Res> {
  factory _$PaymentNoticeCopyWith(_PaymentNotice value, $Res Function(_PaymentNotice) _then) = __$PaymentNoticeCopyWithImpl;
@override @useResult
$Res call({
 String id, String institutionId, String? campusId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String studentId, String chargeId, NoticeKind kind,@DateOnlyConverter() DateTime dueDate,@MinorUnitConverter() int amountMinor, String message,@UtcDateTimeConverter() DateTime sentAt
});




}
/// @nodoc
class __$PaymentNoticeCopyWithImpl<$Res>
    implements _$PaymentNoticeCopyWith<$Res> {
  __$PaymentNoticeCopyWithImpl(this._self, this._then);

  final _PaymentNotice _self;
  final $Res Function(_PaymentNotice) _then;

/// Create a copy of PaymentNotice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? institutionId = null,Object? campusId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? studentId = null,Object? chargeId = null,Object? kind = null,Object? dueDate = null,Object? amountMinor = null,Object? message = null,Object? sentAt = null,}) {
  return _then(_PaymentNotice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,chargeId: null == chargeId ? _self.chargeId : chargeId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as NoticeKind,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
