// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agenda_event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AgendaEventModel {

 String get id; String get institutionId;@UtcDateTimeConverter() DateTime get createdAt;@UtcDateTimeConverter() DateTime get updatedAt;@UtcDateTimeConverter() DateTime? get deletedAt; String get syncState; String get title; String? get description; AgendaEventType get type;@UtcDateTimeConverter() DateTime get startsAt;@UtcDateTimeConverter() DateTime? get endsAt; bool get allDay;/// Turma a que se destina; `null` = toda a escola.
 String? get classroomId; String? get location;
/// Create a copy of AgendaEventModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgendaEventModelCopyWith<AgendaEventModel> get copyWith => _$AgendaEventModelCopyWithImpl<AgendaEventModel>(this as AgendaEventModel, _$identity);

  /// Serializes this AgendaEventModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgendaEventModel&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.allDay, allDay) || other.allDay == allDay)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,createdAt,updatedAt,deletedAt,syncState,title,description,type,startsAt,endsAt,allDay,classroomId,location);

@override
String toString() {
  return 'AgendaEventModel(id: $id, institutionId: $institutionId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, title: $title, description: $description, type: $type, startsAt: $startsAt, endsAt: $endsAt, allDay: $allDay, classroomId: $classroomId, location: $location)';
}


}

/// @nodoc
abstract mixin class $AgendaEventModelCopyWith<$Res>  {
  factory $AgendaEventModelCopyWith(AgendaEventModel value, $Res Function(AgendaEventModel) _then) = _$AgendaEventModelCopyWithImpl;
@useResult
$Res call({
 String id, String institutionId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String title, String? description, AgendaEventType type,@UtcDateTimeConverter() DateTime startsAt,@UtcDateTimeConverter() DateTime? endsAt, bool allDay, String? classroomId, String? location
});




}
/// @nodoc
class _$AgendaEventModelCopyWithImpl<$Res>
    implements $AgendaEventModelCopyWith<$Res> {
  _$AgendaEventModelCopyWithImpl(this._self, this._then);

  final AgendaEventModel _self;
  final $Res Function(AgendaEventModel) _then;

/// Create a copy of AgendaEventModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? institutionId = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? title = null,Object? description = freezed,Object? type = null,Object? startsAt = null,Object? endsAt = freezed,Object? allDay = null,Object? classroomId = freezed,Object? location = freezed,}) {
  return _then(AgendaEventModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AgendaEventType,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,allDay: null == allDay ? _self.allDay : allDay // ignore: cast_nullable_to_non_nullable
as bool,classroomId: freezed == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AgendaEventModel].
extension AgendaEventModelPatterns on AgendaEventModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgendaEventModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgendaEventModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgendaEventModel value)  $default,){
final _that = this;
switch (_that) {
case _AgendaEventModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgendaEventModel value)?  $default,){
final _that = this;
switch (_that) {
case _AgendaEventModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String institutionId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String title,  String? description,  AgendaEventType type, @UtcDateTimeConverter()  DateTime startsAt, @UtcDateTimeConverter()  DateTime? endsAt,  bool allDay,  String? classroomId,  String? location)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgendaEventModel() when $default != null:
return $default(_that.id,_that.institutionId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.title,_that.description,_that.type,_that.startsAt,_that.endsAt,_that.allDay,_that.classroomId,_that.location);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String institutionId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String title,  String? description,  AgendaEventType type, @UtcDateTimeConverter()  DateTime startsAt, @UtcDateTimeConverter()  DateTime? endsAt,  bool allDay,  String? classroomId,  String? location)  $default,) {final _that = this;
switch (_that) {
case _AgendaEventModel():
return $default(_that.id,_that.institutionId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.title,_that.description,_that.type,_that.startsAt,_that.endsAt,_that.allDay,_that.classroomId,_that.location);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String institutionId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String title,  String? description,  AgendaEventType type, @UtcDateTimeConverter()  DateTime startsAt, @UtcDateTimeConverter()  DateTime? endsAt,  bool allDay,  String? classroomId,  String? location)?  $default,) {final _that = this;
switch (_that) {
case _AgendaEventModel() when $default != null:
return $default(_that.id,_that.institutionId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.title,_that.description,_that.type,_that.startsAt,_that.endsAt,_that.allDay,_that.classroomId,_that.location);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AgendaEventModel implements AgendaEventModel {
  const _AgendaEventModel({required this.id, required this.institutionId, @UtcDateTimeConverter() required this.createdAt, @UtcDateTimeConverter() required this.updatedAt, @UtcDateTimeConverter() this.deletedAt, this.syncState = 'synced', required this.title, this.description, required this.type, @UtcDateTimeConverter() required this.startsAt, @UtcDateTimeConverter() this.endsAt, this.allDay = false, this.classroomId, this.location});
  factory _AgendaEventModel.fromJson(Map<String, dynamic> json) => _$AgendaEventModelFromJson(json);

@override final  String id;
@override final  String institutionId;
@override@UtcDateTimeConverter() final  DateTime createdAt;
@override@UtcDateTimeConverter() final  DateTime updatedAt;
@override@UtcDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  String syncState;
@override final  String title;
@override final  String? description;
@override final  AgendaEventType type;
@override@UtcDateTimeConverter() final  DateTime startsAt;
@override@UtcDateTimeConverter() final  DateTime? endsAt;
@override@JsonKey() final  bool allDay;
/// Turma a que se destina; `null` = toda a escola.
@override final  String? classroomId;
@override final  String? location;

/// Create a copy of AgendaEventModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgendaEventModelCopyWith<_AgendaEventModel> get copyWith => __$AgendaEventModelCopyWithImpl<_AgendaEventModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgendaEventModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgendaEventModel&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.allDay, allDay) || other.allDay == allDay)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,createdAt,updatedAt,deletedAt,syncState,title,description,type,startsAt,endsAt,allDay,classroomId,location);

@override
String toString() {
  return 'AgendaEventModel(id: $id, institutionId: $institutionId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, title: $title, description: $description, type: $type, startsAt: $startsAt, endsAt: $endsAt, allDay: $allDay, classroomId: $classroomId, location: $location)';
}


}

/// @nodoc
abstract mixin class _$AgendaEventModelCopyWith<$Res> implements $AgendaEventModelCopyWith<$Res> {
  factory _$AgendaEventModelCopyWith(_AgendaEventModel value, $Res Function(_AgendaEventModel) _then) = __$AgendaEventModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String institutionId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String title, String? description, AgendaEventType type,@UtcDateTimeConverter() DateTime startsAt,@UtcDateTimeConverter() DateTime? endsAt, bool allDay, String? classroomId, String? location
});




}
/// @nodoc
class __$AgendaEventModelCopyWithImpl<$Res>
    implements _$AgendaEventModelCopyWith<$Res> {
  __$AgendaEventModelCopyWithImpl(this._self, this._then);

  final _AgendaEventModel _self;
  final $Res Function(_AgendaEventModel) _then;

/// Create a copy of AgendaEventModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? institutionId = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? title = null,Object? description = freezed,Object? type = null,Object? startsAt = null,Object? endsAt = freezed,Object? allDay = null,Object? classroomId = freezed,Object? location = freezed,}) {
  return _then(_AgendaEventModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AgendaEventType,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,allDay: null == allDay ? _self.allDay : allDay // ignore: cast_nullable_to_non_nullable
as bool,classroomId: freezed == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
