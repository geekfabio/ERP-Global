// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'access_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccessLogModel {

 String get id; String get zoneId; String? get deviceId; String get cardUid; String? get holderId; String? get holderName; String? get holderType; GateDirection get direction; bool get allowed;/// Nome de `AccessReason` (ex.: `granted`, `outsideSchedule`).
 String get reason;/// `true` se o encarregado foi avisado desta passagem.
 bool get guardianAlerted;@UtcDateTimeConverter() DateTime get occurredAt;
/// Create a copy of AccessLogModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccessLogModelCopyWith<AccessLogModel> get copyWith => _$AccessLogModelCopyWithImpl<AccessLogModel>(this as AccessLogModel, _$identity);

  /// Serializes this AccessLogModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccessLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.zoneId, zoneId) || other.zoneId == zoneId)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.cardUid, cardUid) || other.cardUid == cardUid)&&(identical(other.holderId, holderId) || other.holderId == holderId)&&(identical(other.holderName, holderName) || other.holderName == holderName)&&(identical(other.holderType, holderType) || other.holderType == holderType)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.allowed, allowed) || other.allowed == allowed)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.guardianAlerted, guardianAlerted) || other.guardianAlerted == guardianAlerted)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,zoneId,deviceId,cardUid,holderId,holderName,holderType,direction,allowed,reason,guardianAlerted,occurredAt);

@override
String toString() {
  return 'AccessLogModel(id: $id, zoneId: $zoneId, deviceId: $deviceId, cardUid: $cardUid, holderId: $holderId, holderName: $holderName, holderType: $holderType, direction: $direction, allowed: $allowed, reason: $reason, guardianAlerted: $guardianAlerted, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class $AccessLogModelCopyWith<$Res>  {
  factory $AccessLogModelCopyWith(AccessLogModel value, $Res Function(AccessLogModel) _then) = _$AccessLogModelCopyWithImpl;
@useResult
$Res call({
 String id, String zoneId, String? deviceId, String cardUid, String? holderId, String? holderName, String? holderType, GateDirection direction, bool allowed, String reason, bool guardianAlerted,@UtcDateTimeConverter() DateTime occurredAt
});




}
/// @nodoc
class _$AccessLogModelCopyWithImpl<$Res>
    implements $AccessLogModelCopyWith<$Res> {
  _$AccessLogModelCopyWithImpl(this._self, this._then);

  final AccessLogModel _self;
  final $Res Function(AccessLogModel) _then;

/// Create a copy of AccessLogModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? zoneId = null,Object? deviceId = freezed,Object? cardUid = null,Object? holderId = freezed,Object? holderName = freezed,Object? holderType = freezed,Object? direction = null,Object? allowed = null,Object? reason = null,Object? guardianAlerted = null,Object? occurredAt = null,}) {
  return _then(AccessLogModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,zoneId: null == zoneId ? _self.zoneId : zoneId // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,cardUid: null == cardUid ? _self.cardUid : cardUid // ignore: cast_nullable_to_non_nullable
as String,holderId: freezed == holderId ? _self.holderId : holderId // ignore: cast_nullable_to_non_nullable
as String?,holderName: freezed == holderName ? _self.holderName : holderName // ignore: cast_nullable_to_non_nullable
as String?,holderType: freezed == holderType ? _self.holderType : holderType // ignore: cast_nullable_to_non_nullable
as String?,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as GateDirection,allowed: null == allowed ? _self.allowed : allowed // ignore: cast_nullable_to_non_nullable
as bool,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,guardianAlerted: null == guardianAlerted ? _self.guardianAlerted : guardianAlerted // ignore: cast_nullable_to_non_nullable
as bool,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AccessLogModel].
extension AccessLogModelPatterns on AccessLogModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccessLogModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccessLogModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccessLogModel value)  $default,){
final _that = this;
switch (_that) {
case _AccessLogModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccessLogModel value)?  $default,){
final _that = this;
switch (_that) {
case _AccessLogModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String zoneId,  String? deviceId,  String cardUid,  String? holderId,  String? holderName,  String? holderType,  GateDirection direction,  bool allowed,  String reason,  bool guardianAlerted, @UtcDateTimeConverter()  DateTime occurredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccessLogModel() when $default != null:
return $default(_that.id,_that.zoneId,_that.deviceId,_that.cardUid,_that.holderId,_that.holderName,_that.holderType,_that.direction,_that.allowed,_that.reason,_that.guardianAlerted,_that.occurredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String zoneId,  String? deviceId,  String cardUid,  String? holderId,  String? holderName,  String? holderType,  GateDirection direction,  bool allowed,  String reason,  bool guardianAlerted, @UtcDateTimeConverter()  DateTime occurredAt)  $default,) {final _that = this;
switch (_that) {
case _AccessLogModel():
return $default(_that.id,_that.zoneId,_that.deviceId,_that.cardUid,_that.holderId,_that.holderName,_that.holderType,_that.direction,_that.allowed,_that.reason,_that.guardianAlerted,_that.occurredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String zoneId,  String? deviceId,  String cardUid,  String? holderId,  String? holderName,  String? holderType,  GateDirection direction,  bool allowed,  String reason,  bool guardianAlerted, @UtcDateTimeConverter()  DateTime occurredAt)?  $default,) {final _that = this;
switch (_that) {
case _AccessLogModel() when $default != null:
return $default(_that.id,_that.zoneId,_that.deviceId,_that.cardUid,_that.holderId,_that.holderName,_that.holderType,_that.direction,_that.allowed,_that.reason,_that.guardianAlerted,_that.occurredAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccessLogModel implements AccessLogModel {
  const _AccessLogModel({required this.id, required this.zoneId, this.deviceId, required this.cardUid, this.holderId, this.holderName, this.holderType, this.direction = GateDirection.entry, required this.allowed, required this.reason, this.guardianAlerted = false, @UtcDateTimeConverter() required this.occurredAt});
  factory _AccessLogModel.fromJson(Map<String, dynamic> json) => _$AccessLogModelFromJson(json);

@override final  String id;
@override final  String zoneId;
@override final  String? deviceId;
@override final  String cardUid;
@override final  String? holderId;
@override final  String? holderName;
@override final  String? holderType;
@override@JsonKey() final  GateDirection direction;
@override final  bool allowed;
/// Nome de `AccessReason` (ex.: `granted`, `outsideSchedule`).
@override final  String reason;
/// `true` se o encarregado foi avisado desta passagem.
@override@JsonKey() final  bool guardianAlerted;
@override@UtcDateTimeConverter() final  DateTime occurredAt;

/// Create a copy of AccessLogModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccessLogModelCopyWith<_AccessLogModel> get copyWith => __$AccessLogModelCopyWithImpl<_AccessLogModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccessLogModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccessLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.zoneId, zoneId) || other.zoneId == zoneId)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.cardUid, cardUid) || other.cardUid == cardUid)&&(identical(other.holderId, holderId) || other.holderId == holderId)&&(identical(other.holderName, holderName) || other.holderName == holderName)&&(identical(other.holderType, holderType) || other.holderType == holderType)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.allowed, allowed) || other.allowed == allowed)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.guardianAlerted, guardianAlerted) || other.guardianAlerted == guardianAlerted)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,zoneId,deviceId,cardUid,holderId,holderName,holderType,direction,allowed,reason,guardianAlerted,occurredAt);

@override
String toString() {
  return 'AccessLogModel(id: $id, zoneId: $zoneId, deviceId: $deviceId, cardUid: $cardUid, holderId: $holderId, holderName: $holderName, holderType: $holderType, direction: $direction, allowed: $allowed, reason: $reason, guardianAlerted: $guardianAlerted, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class _$AccessLogModelCopyWith<$Res> implements $AccessLogModelCopyWith<$Res> {
  factory _$AccessLogModelCopyWith(_AccessLogModel value, $Res Function(_AccessLogModel) _then) = __$AccessLogModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String zoneId, String? deviceId, String cardUid, String? holderId, String? holderName, String? holderType, GateDirection direction, bool allowed, String reason, bool guardianAlerted,@UtcDateTimeConverter() DateTime occurredAt
});




}
/// @nodoc
class __$AccessLogModelCopyWithImpl<$Res>
    implements _$AccessLogModelCopyWith<$Res> {
  __$AccessLogModelCopyWithImpl(this._self, this._then);

  final _AccessLogModel _self;
  final $Res Function(_AccessLogModel) _then;

/// Create a copy of AccessLogModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? zoneId = null,Object? deviceId = freezed,Object? cardUid = null,Object? holderId = freezed,Object? holderName = freezed,Object? holderType = freezed,Object? direction = null,Object? allowed = null,Object? reason = null,Object? guardianAlerted = null,Object? occurredAt = null,}) {
  return _then(_AccessLogModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,zoneId: null == zoneId ? _self.zoneId : zoneId // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,cardUid: null == cardUid ? _self.cardUid : cardUid // ignore: cast_nullable_to_non_nullable
as String,holderId: freezed == holderId ? _self.holderId : holderId // ignore: cast_nullable_to_non_nullable
as String?,holderName: freezed == holderName ? _self.holderName : holderName // ignore: cast_nullable_to_non_nullable
as String?,holderType: freezed == holderType ? _self.holderType : holderType // ignore: cast_nullable_to_non_nullable
as String?,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as GateDirection,allowed: null == allowed ? _self.allowed : allowed // ignore: cast_nullable_to_non_nullable
as bool,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,guardianAlerted: null == guardianAlerted ? _self.guardianAlerted : guardianAlerted // ignore: cast_nullable_to_non_nullable
as bool,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
