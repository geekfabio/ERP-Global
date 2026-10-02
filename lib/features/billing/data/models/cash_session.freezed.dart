// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cash_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CashSession {

 String get id; String get institutionId; String? get campusId;@UtcDateTimeConverter() DateTime get createdAt;@UtcDateTimeConverter() DateTime get updatedAt;@UtcDateTimeConverter() DateTime? get deletedAt; String get syncState; String get cashRegisterId; String get operatorId;@UtcDateTimeConverter() DateTime get openedAt;@MinorUnitConverter() int get openingMinor; CashSessionStatus get status;@UtcDateTimeConverter() DateTime? get closedAt; int? get expectedMinor; int? get countedMinor; int? get differenceMinor; String? get closingNotes;
/// Create a copy of CashSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashSessionCopyWith<CashSession> get copyWith => _$CashSessionCopyWithImpl<CashSession>(this as CashSession, _$identity);

  /// Serializes this CashSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashSession&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.cashRegisterId, cashRegisterId) || other.cashRegisterId == cashRegisterId)&&(identical(other.operatorId, operatorId) || other.operatorId == operatorId)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt)&&(identical(other.openingMinor, openingMinor) || other.openingMinor == openingMinor)&&(identical(other.status, status) || other.status == status)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.expectedMinor, expectedMinor) || other.expectedMinor == expectedMinor)&&(identical(other.countedMinor, countedMinor) || other.countedMinor == countedMinor)&&(identical(other.differenceMinor, differenceMinor) || other.differenceMinor == differenceMinor)&&(identical(other.closingNotes, closingNotes) || other.closingNotes == closingNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,campusId,createdAt,updatedAt,deletedAt,syncState,cashRegisterId,operatorId,openedAt,openingMinor,status,closedAt,expectedMinor,countedMinor,differenceMinor,closingNotes);

@override
String toString() {
  return 'CashSession(id: $id, institutionId: $institutionId, campusId: $campusId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, cashRegisterId: $cashRegisterId, operatorId: $operatorId, openedAt: $openedAt, openingMinor: $openingMinor, status: $status, closedAt: $closedAt, expectedMinor: $expectedMinor, countedMinor: $countedMinor, differenceMinor: $differenceMinor, closingNotes: $closingNotes)';
}


}

/// @nodoc
abstract mixin class $CashSessionCopyWith<$Res>  {
  factory $CashSessionCopyWith(CashSession value, $Res Function(CashSession) _then) = _$CashSessionCopyWithImpl;
@useResult
$Res call({
 String id, String institutionId, String? campusId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String cashRegisterId, String operatorId,@UtcDateTimeConverter() DateTime openedAt,@MinorUnitConverter() int openingMinor, CashSessionStatus status,@UtcDateTimeConverter() DateTime? closedAt, int? expectedMinor, int? countedMinor, int? differenceMinor, String? closingNotes
});




}
/// @nodoc
class _$CashSessionCopyWithImpl<$Res>
    implements $CashSessionCopyWith<$Res> {
  _$CashSessionCopyWithImpl(this._self, this._then);

  final CashSession _self;
  final $Res Function(CashSession) _then;

/// Create a copy of CashSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? institutionId = null,Object? campusId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? cashRegisterId = null,Object? operatorId = null,Object? openedAt = null,Object? openingMinor = null,Object? status = null,Object? closedAt = freezed,Object? expectedMinor = freezed,Object? countedMinor = freezed,Object? differenceMinor = freezed,Object? closingNotes = freezed,}) {
  return _then(CashSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,cashRegisterId: null == cashRegisterId ? _self.cashRegisterId : cashRegisterId // ignore: cast_nullable_to_non_nullable
as String,operatorId: null == operatorId ? _self.operatorId : operatorId // ignore: cast_nullable_to_non_nullable
as String,openedAt: null == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as DateTime,openingMinor: null == openingMinor ? _self.openingMinor : openingMinor // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CashSessionStatus,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expectedMinor: freezed == expectedMinor ? _self.expectedMinor : expectedMinor // ignore: cast_nullable_to_non_nullable
as int?,countedMinor: freezed == countedMinor ? _self.countedMinor : countedMinor // ignore: cast_nullable_to_non_nullable
as int?,differenceMinor: freezed == differenceMinor ? _self.differenceMinor : differenceMinor // ignore: cast_nullable_to_non_nullable
as int?,closingNotes: freezed == closingNotes ? _self.closingNotes : closingNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CashSession].
extension CashSessionPatterns on CashSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashSession value)  $default,){
final _that = this;
switch (_that) {
case _CashSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashSession value)?  $default,){
final _that = this;
switch (_that) {
case _CashSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String cashRegisterId,  String operatorId, @UtcDateTimeConverter()  DateTime openedAt, @MinorUnitConverter()  int openingMinor,  CashSessionStatus status, @UtcDateTimeConverter()  DateTime? closedAt,  int? expectedMinor,  int? countedMinor,  int? differenceMinor,  String? closingNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashSession() when $default != null:
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.cashRegisterId,_that.operatorId,_that.openedAt,_that.openingMinor,_that.status,_that.closedAt,_that.expectedMinor,_that.countedMinor,_that.differenceMinor,_that.closingNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String cashRegisterId,  String operatorId, @UtcDateTimeConverter()  DateTime openedAt, @MinorUnitConverter()  int openingMinor,  CashSessionStatus status, @UtcDateTimeConverter()  DateTime? closedAt,  int? expectedMinor,  int? countedMinor,  int? differenceMinor,  String? closingNotes)  $default,) {final _that = this;
switch (_that) {
case _CashSession():
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.cashRegisterId,_that.operatorId,_that.openedAt,_that.openingMinor,_that.status,_that.closedAt,_that.expectedMinor,_that.countedMinor,_that.differenceMinor,_that.closingNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String cashRegisterId,  String operatorId, @UtcDateTimeConverter()  DateTime openedAt, @MinorUnitConverter()  int openingMinor,  CashSessionStatus status, @UtcDateTimeConverter()  DateTime? closedAt,  int? expectedMinor,  int? countedMinor,  int? differenceMinor,  String? closingNotes)?  $default,) {final _that = this;
switch (_that) {
case _CashSession() when $default != null:
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.cashRegisterId,_that.operatorId,_that.openedAt,_that.openingMinor,_that.status,_that.closedAt,_that.expectedMinor,_that.countedMinor,_that.differenceMinor,_that.closingNotes);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CashSession implements CashSession {
  const _CashSession({required this.id, required this.institutionId, this.campusId, @UtcDateTimeConverter() required this.createdAt, @UtcDateTimeConverter() required this.updatedAt, @UtcDateTimeConverter() this.deletedAt, this.syncState = 'synced', required this.cashRegisterId, required this.operatorId, @UtcDateTimeConverter() required this.openedAt, @MinorUnitConverter() required this.openingMinor, this.status = CashSessionStatus.open, @UtcDateTimeConverter() this.closedAt, this.expectedMinor, this.countedMinor, this.differenceMinor, this.closingNotes});
  factory _CashSession.fromJson(Map<String, dynamic> json) => _$CashSessionFromJson(json);

@override final  String id;
@override final  String institutionId;
@override final  String? campusId;
@override@UtcDateTimeConverter() final  DateTime createdAt;
@override@UtcDateTimeConverter() final  DateTime updatedAt;
@override@UtcDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  String syncState;
@override final  String cashRegisterId;
@override final  String operatorId;
@override@UtcDateTimeConverter() final  DateTime openedAt;
@override@MinorUnitConverter() final  int openingMinor;
@override@JsonKey() final  CashSessionStatus status;
@override@UtcDateTimeConverter() final  DateTime? closedAt;
@override final  int? expectedMinor;
@override final  int? countedMinor;
@override final  int? differenceMinor;
@override final  String? closingNotes;

/// Create a copy of CashSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashSessionCopyWith<_CashSession> get copyWith => __$CashSessionCopyWithImpl<_CashSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashSession&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.cashRegisterId, cashRegisterId) || other.cashRegisterId == cashRegisterId)&&(identical(other.operatorId, operatorId) || other.operatorId == operatorId)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt)&&(identical(other.openingMinor, openingMinor) || other.openingMinor == openingMinor)&&(identical(other.status, status) || other.status == status)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.expectedMinor, expectedMinor) || other.expectedMinor == expectedMinor)&&(identical(other.countedMinor, countedMinor) || other.countedMinor == countedMinor)&&(identical(other.differenceMinor, differenceMinor) || other.differenceMinor == differenceMinor)&&(identical(other.closingNotes, closingNotes) || other.closingNotes == closingNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,campusId,createdAt,updatedAt,deletedAt,syncState,cashRegisterId,operatorId,openedAt,openingMinor,status,closedAt,expectedMinor,countedMinor,differenceMinor,closingNotes);

@override
String toString() {
  return 'CashSession(id: $id, institutionId: $institutionId, campusId: $campusId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, cashRegisterId: $cashRegisterId, operatorId: $operatorId, openedAt: $openedAt, openingMinor: $openingMinor, status: $status, closedAt: $closedAt, expectedMinor: $expectedMinor, countedMinor: $countedMinor, differenceMinor: $differenceMinor, closingNotes: $closingNotes)';
}


}

/// @nodoc
abstract mixin class _$CashSessionCopyWith<$Res> implements $CashSessionCopyWith<$Res> {
  factory _$CashSessionCopyWith(_CashSession value, $Res Function(_CashSession) _then) = __$CashSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, String institutionId, String? campusId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String cashRegisterId, String operatorId,@UtcDateTimeConverter() DateTime openedAt,@MinorUnitConverter() int openingMinor, CashSessionStatus status,@UtcDateTimeConverter() DateTime? closedAt, int? expectedMinor, int? countedMinor, int? differenceMinor, String? closingNotes
});




}
/// @nodoc
class __$CashSessionCopyWithImpl<$Res>
    implements _$CashSessionCopyWith<$Res> {
  __$CashSessionCopyWithImpl(this._self, this._then);

  final _CashSession _self;
  final $Res Function(_CashSession) _then;

/// Create a copy of CashSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? institutionId = null,Object? campusId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? cashRegisterId = null,Object? operatorId = null,Object? openedAt = null,Object? openingMinor = null,Object? status = null,Object? closedAt = freezed,Object? expectedMinor = freezed,Object? countedMinor = freezed,Object? differenceMinor = freezed,Object? closingNotes = freezed,}) {
  return _then(_CashSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,cashRegisterId: null == cashRegisterId ? _self.cashRegisterId : cashRegisterId // ignore: cast_nullable_to_non_nullable
as String,operatorId: null == operatorId ? _self.operatorId : operatorId // ignore: cast_nullable_to_non_nullable
as String,openedAt: null == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as DateTime,openingMinor: null == openingMinor ? _self.openingMinor : openingMinor // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CashSessionStatus,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expectedMinor: freezed == expectedMinor ? _self.expectedMinor : expectedMinor // ignore: cast_nullable_to_non_nullable
as int?,countedMinor: freezed == countedMinor ? _self.countedMinor : countedMinor // ignore: cast_nullable_to_non_nullable
as int?,differenceMinor: freezed == differenceMinor ? _self.differenceMinor : differenceMinor // ignore: cast_nullable_to_non_nullable
as int?,closingNotes: freezed == closingNotes ? _self.closingNotes : closingNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CashMovement {

 String get id; String get institutionId; String? get campusId;@UtcDateTimeConverter() DateTime get createdAt;@UtcDateTimeConverter() DateTime get updatedAt;@UtcDateTimeConverter() DateTime? get deletedAt; String get syncState; String get sessionId; CashMovementType get type;@MinorUnitConverter() int get amountMinor;@UtcDateTimeConverter() DateTime get occurredAt; String? get description; String? get paymentId;
/// Create a copy of CashMovement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashMovementCopyWith<CashMovement> get copyWith => _$CashMovementCopyWithImpl<CashMovement>(this as CashMovement, _$identity);

  /// Serializes this CashMovement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashMovement&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,campusId,createdAt,updatedAt,deletedAt,syncState,sessionId,type,amountMinor,occurredAt,description,paymentId);

@override
String toString() {
  return 'CashMovement(id: $id, institutionId: $institutionId, campusId: $campusId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, sessionId: $sessionId, type: $type, amountMinor: $amountMinor, occurredAt: $occurredAt, description: $description, paymentId: $paymentId)';
}


}

/// @nodoc
abstract mixin class $CashMovementCopyWith<$Res>  {
  factory $CashMovementCopyWith(CashMovement value, $Res Function(CashMovement) _then) = _$CashMovementCopyWithImpl;
@useResult
$Res call({
 String id, String institutionId, String? campusId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String sessionId, CashMovementType type,@MinorUnitConverter() int amountMinor,@UtcDateTimeConverter() DateTime occurredAt, String? description, String? paymentId
});




}
/// @nodoc
class _$CashMovementCopyWithImpl<$Res>
    implements $CashMovementCopyWith<$Res> {
  _$CashMovementCopyWithImpl(this._self, this._then);

  final CashMovement _self;
  final $Res Function(CashMovement) _then;

/// Create a copy of CashMovement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? institutionId = null,Object? campusId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? sessionId = null,Object? type = null,Object? amountMinor = null,Object? occurredAt = null,Object? description = freezed,Object? paymentId = freezed,}) {
  return _then(CashMovement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CashMovementType,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,paymentId: freezed == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CashMovement].
extension CashMovementPatterns on CashMovement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashMovement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashMovement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashMovement value)  $default,){
final _that = this;
switch (_that) {
case _CashMovement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashMovement value)?  $default,){
final _that = this;
switch (_that) {
case _CashMovement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String sessionId,  CashMovementType type, @MinorUnitConverter()  int amountMinor, @UtcDateTimeConverter()  DateTime occurredAt,  String? description,  String? paymentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashMovement() when $default != null:
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.sessionId,_that.type,_that.amountMinor,_that.occurredAt,_that.description,_that.paymentId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String sessionId,  CashMovementType type, @MinorUnitConverter()  int amountMinor, @UtcDateTimeConverter()  DateTime occurredAt,  String? description,  String? paymentId)  $default,) {final _that = this;
switch (_that) {
case _CashMovement():
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.sessionId,_that.type,_that.amountMinor,_that.occurredAt,_that.description,_that.paymentId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String sessionId,  CashMovementType type, @MinorUnitConverter()  int amountMinor, @UtcDateTimeConverter()  DateTime occurredAt,  String? description,  String? paymentId)?  $default,) {final _that = this;
switch (_that) {
case _CashMovement() when $default != null:
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.sessionId,_that.type,_that.amountMinor,_that.occurredAt,_that.description,_that.paymentId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CashMovement implements CashMovement {
  const _CashMovement({required this.id, required this.institutionId, this.campusId, @UtcDateTimeConverter() required this.createdAt, @UtcDateTimeConverter() required this.updatedAt, @UtcDateTimeConverter() this.deletedAt, this.syncState = 'synced', required this.sessionId, required this.type, @MinorUnitConverter() required this.amountMinor, @UtcDateTimeConverter() required this.occurredAt, this.description, this.paymentId});
  factory _CashMovement.fromJson(Map<String, dynamic> json) => _$CashMovementFromJson(json);

@override final  String id;
@override final  String institutionId;
@override final  String? campusId;
@override@UtcDateTimeConverter() final  DateTime createdAt;
@override@UtcDateTimeConverter() final  DateTime updatedAt;
@override@UtcDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  String syncState;
@override final  String sessionId;
@override final  CashMovementType type;
@override@MinorUnitConverter() final  int amountMinor;
@override@UtcDateTimeConverter() final  DateTime occurredAt;
@override final  String? description;
@override final  String? paymentId;

/// Create a copy of CashMovement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashMovementCopyWith<_CashMovement> get copyWith => __$CashMovementCopyWithImpl<_CashMovement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashMovementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashMovement&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,campusId,createdAt,updatedAt,deletedAt,syncState,sessionId,type,amountMinor,occurredAt,description,paymentId);

@override
String toString() {
  return 'CashMovement(id: $id, institutionId: $institutionId, campusId: $campusId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, sessionId: $sessionId, type: $type, amountMinor: $amountMinor, occurredAt: $occurredAt, description: $description, paymentId: $paymentId)';
}


}

/// @nodoc
abstract mixin class _$CashMovementCopyWith<$Res> implements $CashMovementCopyWith<$Res> {
  factory _$CashMovementCopyWith(_CashMovement value, $Res Function(_CashMovement) _then) = __$CashMovementCopyWithImpl;
@override @useResult
$Res call({
 String id, String institutionId, String? campusId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String sessionId, CashMovementType type,@MinorUnitConverter() int amountMinor,@UtcDateTimeConverter() DateTime occurredAt, String? description, String? paymentId
});




}
/// @nodoc
class __$CashMovementCopyWithImpl<$Res>
    implements _$CashMovementCopyWith<$Res> {
  __$CashMovementCopyWithImpl(this._self, this._then);

  final _CashMovement _self;
  final $Res Function(_CashMovement) _then;

/// Create a copy of CashMovement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? institutionId = null,Object? campusId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? sessionId = null,Object? type = null,Object? amountMinor = null,Object? occurredAt = null,Object? description = freezed,Object? paymentId = freezed,}) {
  return _then(_CashMovement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CashMovementType,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,paymentId: freezed == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
