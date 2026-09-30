// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuditLogModel {

 String get id; String get institutionId;@UtcDateTimeConverter() DateTime get createdAt; String get actorId; String get actorName;/// Recurso afectado (`student`, `invoice`, `grade`…).
 String get entity; String? get entityId; AuditAction get action;/// Estado anterior e posterior (`null` em criação/remoção, respectivamente).
 Map<String, dynamic>? get before; Map<String, dynamic>? get after;
/// Create a copy of AuditLogModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditLogModelCopyWith<AuditLogModel> get copyWith => _$AuditLogModelCopyWithImpl<AuditLogModel>(this as AuditLogModel, _$identity);

  /// Serializes this AuditLogModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.actorId, actorId) || other.actorId == actorId)&&(identical(other.actorName, actorName) || other.actorName == actorName)&&(identical(other.entity, entity) || other.entity == entity)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.action, action) || other.action == action)&&const DeepCollectionEquality().equals(other.before, before)&&const DeepCollectionEquality().equals(other.after, after));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,createdAt,actorId,actorName,entity,entityId,action,const DeepCollectionEquality().hash(before),const DeepCollectionEquality().hash(after));

@override
String toString() {
  return 'AuditLogModel(id: $id, institutionId: $institutionId, createdAt: $createdAt, actorId: $actorId, actorName: $actorName, entity: $entity, entityId: $entityId, action: $action, before: $before, after: $after)';
}


}

/// @nodoc
abstract mixin class $AuditLogModelCopyWith<$Res>  {
  factory $AuditLogModelCopyWith(AuditLogModel value, $Res Function(AuditLogModel) _then) = _$AuditLogModelCopyWithImpl;
@useResult
$Res call({
 String id, String institutionId,@UtcDateTimeConverter() DateTime createdAt, String actorId, String actorName, String entity, String? entityId, AuditAction action, Map<String, dynamic>? before, Map<String, dynamic>? after
});




}
/// @nodoc
class _$AuditLogModelCopyWithImpl<$Res>
    implements $AuditLogModelCopyWith<$Res> {
  _$AuditLogModelCopyWithImpl(this._self, this._then);

  final AuditLogModel _self;
  final $Res Function(AuditLogModel) _then;

/// Create a copy of AuditLogModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? institutionId = null,Object? createdAt = null,Object? actorId = null,Object? actorName = null,Object? entity = null,Object? entityId = freezed,Object? action = null,Object? before = freezed,Object? after = freezed,}) {
  return _then(AuditLogModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,actorId: null == actorId ? _self.actorId : actorId // ignore: cast_nullable_to_non_nullable
as String,actorName: null == actorName ? _self.actorName : actorName // ignore: cast_nullable_to_non_nullable
as String,entity: null == entity ? _self.entity : entity // ignore: cast_nullable_to_non_nullable
as String,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as AuditAction,before: freezed == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,after: freezed == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditLogModel].
extension AuditLogModelPatterns on AuditLogModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditLogModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditLogModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditLogModel value)  $default,){
final _that = this;
switch (_that) {
case _AuditLogModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditLogModel value)?  $default,){
final _that = this;
switch (_that) {
case _AuditLogModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String institutionId, @UtcDateTimeConverter()  DateTime createdAt,  String actorId,  String actorName,  String entity,  String? entityId,  AuditAction action,  Map<String, dynamic>? before,  Map<String, dynamic>? after)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditLogModel() when $default != null:
return $default(_that.id,_that.institutionId,_that.createdAt,_that.actorId,_that.actorName,_that.entity,_that.entityId,_that.action,_that.before,_that.after);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String institutionId, @UtcDateTimeConverter()  DateTime createdAt,  String actorId,  String actorName,  String entity,  String? entityId,  AuditAction action,  Map<String, dynamic>? before,  Map<String, dynamic>? after)  $default,) {final _that = this;
switch (_that) {
case _AuditLogModel():
return $default(_that.id,_that.institutionId,_that.createdAt,_that.actorId,_that.actorName,_that.entity,_that.entityId,_that.action,_that.before,_that.after);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String institutionId, @UtcDateTimeConverter()  DateTime createdAt,  String actorId,  String actorName,  String entity,  String? entityId,  AuditAction action,  Map<String, dynamic>? before,  Map<String, dynamic>? after)?  $default,) {final _that = this;
switch (_that) {
case _AuditLogModel() when $default != null:
return $default(_that.id,_that.institutionId,_that.createdAt,_that.actorId,_that.actorName,_that.entity,_that.entityId,_that.action,_that.before,_that.after);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AuditLogModel implements AuditLogModel {
  const _AuditLogModel({required this.id, required this.institutionId, @UtcDateTimeConverter() required this.createdAt, required this.actorId, required this.actorName, required this.entity, this.entityId, required this.action,  Map<String, dynamic>? before,  Map<String, dynamic>? after}): _before = before,_after = after;
  factory _AuditLogModel.fromJson(Map<String, dynamic> json) => _$AuditLogModelFromJson(json);

@override final  String id;
@override final  String institutionId;
@override@UtcDateTimeConverter() final  DateTime createdAt;
@override final  String actorId;
@override final  String actorName;
/// Recurso afectado (`student`, `invoice`, `grade`…).
@override final  String entity;
@override final  String? entityId;
@override final  AuditAction action;
/// Estado anterior e posterior (`null` em criação/remoção, respectivamente).
 final  Map<String, dynamic>? _before;
/// Estado anterior e posterior (`null` em criação/remoção, respectivamente).
@override Map<String, dynamic>? get before {
  final value = _before;
  if (value == null) return null;
  if (_before is EqualUnmodifiableMapView) return _before;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _after;
@override Map<String, dynamic>? get after {
  final value = _after;
  if (value == null) return null;
  if (_after is EqualUnmodifiableMapView) return _after;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AuditLogModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditLogModelCopyWith<_AuditLogModel> get copyWith => __$AuditLogModelCopyWithImpl<_AuditLogModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditLogModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.actorId, actorId) || other.actorId == actorId)&&(identical(other.actorName, actorName) || other.actorName == actorName)&&(identical(other.entity, entity) || other.entity == entity)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.action, action) || other.action == action)&&const DeepCollectionEquality().equals(other._before, _before)&&const DeepCollectionEquality().equals(other._after, _after));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,createdAt,actorId,actorName,entity,entityId,action,const DeepCollectionEquality().hash(_before),const DeepCollectionEquality().hash(_after));

@override
String toString() {
  return 'AuditLogModel(id: $id, institutionId: $institutionId, createdAt: $createdAt, actorId: $actorId, actorName: $actorName, entity: $entity, entityId: $entityId, action: $action, before: $before, after: $after)';
}


}

/// @nodoc
abstract mixin class _$AuditLogModelCopyWith<$Res> implements $AuditLogModelCopyWith<$Res> {
  factory _$AuditLogModelCopyWith(_AuditLogModel value, $Res Function(_AuditLogModel) _then) = __$AuditLogModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String institutionId,@UtcDateTimeConverter() DateTime createdAt, String actorId, String actorName, String entity, String? entityId, AuditAction action, Map<String, dynamic>? before, Map<String, dynamic>? after
});




}
/// @nodoc
class __$AuditLogModelCopyWithImpl<$Res>
    implements _$AuditLogModelCopyWith<$Res> {
  __$AuditLogModelCopyWithImpl(this._self, this._then);

  final _AuditLogModel _self;
  final $Res Function(_AuditLogModel) _then;

/// Create a copy of AuditLogModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? institutionId = null,Object? createdAt = null,Object? actorId = null,Object? actorName = null,Object? entity = null,Object? entityId = freezed,Object? action = null,Object? before = freezed,Object? after = freezed,}) {
  return _then(_AuditLogModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,actorId: null == actorId ? _self.actorId : actorId // ignore: cast_nullable_to_non_nullable
as String,actorName: null == actorName ? _self.actorName : actorName // ignore: cast_nullable_to_non_nullable
as String,entity: null == entity ? _self.entity : entity // ignore: cast_nullable_to_non_nullable
as String,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as AuditAction,before: freezed == before ? _self._before : before // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,after: freezed == after ? _self._after : after // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
