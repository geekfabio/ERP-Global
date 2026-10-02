// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'charge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Charge {

 String get id; String get institutionId; String? get campusId;@UtcDateTimeConverter() DateTime get createdAt;@UtcDateTimeConverter() DateTime get updatedAt;@UtcDateTimeConverter() DateTime? get deletedAt; String get syncState; String get studentId; String get feeItemId;@DateOnlyConverter() DateTime get dueDate;@MinorUnitConverter() int get amountMinor;@MinorUnitConverter() int get discountMinor; ChargeStatus get status;
/// Create a copy of Charge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChargeCopyWith<Charge> get copyWith => _$ChargeCopyWithImpl<Charge>(this as Charge, _$identity);

  /// Serializes this Charge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Charge&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.feeItemId, feeItemId) || other.feeItemId == feeItemId)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,campusId,createdAt,updatedAt,deletedAt,syncState,studentId,feeItemId,dueDate,amountMinor,discountMinor,status);

@override
String toString() {
  return 'Charge(id: $id, institutionId: $institutionId, campusId: $campusId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, studentId: $studentId, feeItemId: $feeItemId, dueDate: $dueDate, amountMinor: $amountMinor, discountMinor: $discountMinor, status: $status)';
}


}

/// @nodoc
abstract mixin class $ChargeCopyWith<$Res>  {
  factory $ChargeCopyWith(Charge value, $Res Function(Charge) _then) = _$ChargeCopyWithImpl;
@useResult
$Res call({
 String id, String institutionId, String? campusId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String studentId, String feeItemId,@DateOnlyConverter() DateTime dueDate,@MinorUnitConverter() int amountMinor,@MinorUnitConverter() int discountMinor, ChargeStatus status
});




}
/// @nodoc
class _$ChargeCopyWithImpl<$Res>
    implements $ChargeCopyWith<$Res> {
  _$ChargeCopyWithImpl(this._self, this._then);

  final Charge _self;
  final $Res Function(Charge) _then;

/// Create a copy of Charge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? institutionId = null,Object? campusId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? studentId = null,Object? feeItemId = null,Object? dueDate = null,Object? amountMinor = null,Object? discountMinor = null,Object? status = null,}) {
  return _then(Charge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,feeItemId: null == feeItemId ? _self.feeItemId : feeItemId // ignore: cast_nullable_to_non_nullable
as String,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChargeStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [Charge].
extension ChargePatterns on Charge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Charge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Charge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Charge value)  $default,){
final _that = this;
switch (_that) {
case _Charge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Charge value)?  $default,){
final _that = this;
switch (_that) {
case _Charge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  String feeItemId, @DateOnlyConverter()  DateTime dueDate, @MinorUnitConverter()  int amountMinor, @MinorUnitConverter()  int discountMinor,  ChargeStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Charge() when $default != null:
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.feeItemId,_that.dueDate,_that.amountMinor,_that.discountMinor,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  String feeItemId, @DateOnlyConverter()  DateTime dueDate, @MinorUnitConverter()  int amountMinor, @MinorUnitConverter()  int discountMinor,  ChargeStatus status)  $default,) {final _that = this;
switch (_that) {
case _Charge():
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.feeItemId,_that.dueDate,_that.amountMinor,_that.discountMinor,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId,  String feeItemId, @DateOnlyConverter()  DateTime dueDate, @MinorUnitConverter()  int amountMinor, @MinorUnitConverter()  int discountMinor,  ChargeStatus status)?  $default,) {final _that = this;
switch (_that) {
case _Charge() when $default != null:
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.feeItemId,_that.dueDate,_that.amountMinor,_that.discountMinor,_that.status);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Charge implements Charge {
  const _Charge({required this.id, required this.institutionId, this.campusId, @UtcDateTimeConverter() required this.createdAt, @UtcDateTimeConverter() required this.updatedAt, @UtcDateTimeConverter() this.deletedAt, this.syncState = 'synced', required this.studentId, required this.feeItemId, @DateOnlyConverter() required this.dueDate, @MinorUnitConverter() required this.amountMinor, @MinorUnitConverter() this.discountMinor = 0, this.status = ChargeStatus.pending});
  factory _Charge.fromJson(Map<String, dynamic> json) => _$ChargeFromJson(json);

@override final  String id;
@override final  String institutionId;
@override final  String? campusId;
@override@UtcDateTimeConverter() final  DateTime createdAt;
@override@UtcDateTimeConverter() final  DateTime updatedAt;
@override@UtcDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  String syncState;
@override final  String studentId;
@override final  String feeItemId;
@override@DateOnlyConverter() final  DateTime dueDate;
@override@MinorUnitConverter() final  int amountMinor;
@override@JsonKey()@MinorUnitConverter() final  int discountMinor;
@override@JsonKey() final  ChargeStatus status;

/// Create a copy of Charge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChargeCopyWith<_Charge> get copyWith => __$ChargeCopyWithImpl<_Charge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChargeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Charge&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.feeItemId, feeItemId) || other.feeItemId == feeItemId)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,campusId,createdAt,updatedAt,deletedAt,syncState,studentId,feeItemId,dueDate,amountMinor,discountMinor,status);

@override
String toString() {
  return 'Charge(id: $id, institutionId: $institutionId, campusId: $campusId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, studentId: $studentId, feeItemId: $feeItemId, dueDate: $dueDate, amountMinor: $amountMinor, discountMinor: $discountMinor, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ChargeCopyWith<$Res> implements $ChargeCopyWith<$Res> {
  factory _$ChargeCopyWith(_Charge value, $Res Function(_Charge) _then) = __$ChargeCopyWithImpl;
@override @useResult
$Res call({
 String id, String institutionId, String? campusId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String studentId, String feeItemId,@DateOnlyConverter() DateTime dueDate,@MinorUnitConverter() int amountMinor,@MinorUnitConverter() int discountMinor, ChargeStatus status
});




}
/// @nodoc
class __$ChargeCopyWithImpl<$Res>
    implements _$ChargeCopyWith<$Res> {
  __$ChargeCopyWithImpl(this._self, this._then);

  final _Charge _self;
  final $Res Function(_Charge) _then;

/// Create a copy of Charge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? institutionId = null,Object? campusId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? studentId = null,Object? feeItemId = null,Object? dueDate = null,Object? amountMinor = null,Object? discountMinor = null,Object? status = null,}) {
  return _then(_Charge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,feeItemId: null == feeItemId ? _self.feeItemId : feeItemId // ignore: cast_nullable_to_non_nullable
as String,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChargeStatus,
  ));
}


}

// dart format on
