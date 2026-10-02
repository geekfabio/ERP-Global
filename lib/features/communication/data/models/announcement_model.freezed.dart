// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'announcement_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnnouncementModel {

 String get id; String get institutionId;@UtcDateTimeConverter() DateTime get createdAt;@UtcDateTimeConverter() DateTime get updatedAt;@UtcDateTimeConverter() DateTime? get deletedAt; String get syncState; String get title; String get body; AnnouncementAudience get audience;/// Turma alvo (obrigatório para `classroom`; opcional para `guardians`).
 String? get classroomId; AnnouncementStatus get status; bool get requiresReadReceipt;/// Canais de entrega (`in_app`, `push`, `sms`, `email`).
 List<String> get channels; String? get createdBy;@UtcDateTimeConverter() DateTime? get publishedAt;/// Quantos já confirmaram a leitura / quantos destinatários (calculado no servidor).
 int get readCount; int get recipientCount;
/// Create a copy of AnnouncementModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnnouncementModelCopyWith<AnnouncementModel> get copyWith => _$AnnouncementModelCopyWithImpl<AnnouncementModel>(this as AnnouncementModel, _$identity);

  /// Serializes this AnnouncementModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnnouncementModel&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.audience, audience) || other.audience == audience)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.status, status) || other.status == status)&&(identical(other.requiresReadReceipt, requiresReadReceipt) || other.requiresReadReceipt == requiresReadReceipt)&&const DeepCollectionEquality().equals(other.channels, channels)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.readCount, readCount) || other.readCount == readCount)&&(identical(other.recipientCount, recipientCount) || other.recipientCount == recipientCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,createdAt,updatedAt,deletedAt,syncState,title,body,audience,classroomId,status,requiresReadReceipt,const DeepCollectionEquality().hash(channels),createdBy,publishedAt,readCount,recipientCount);

@override
String toString() {
  return 'AnnouncementModel(id: $id, institutionId: $institutionId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, title: $title, body: $body, audience: $audience, classroomId: $classroomId, status: $status, requiresReadReceipt: $requiresReadReceipt, channels: $channels, createdBy: $createdBy, publishedAt: $publishedAt, readCount: $readCount, recipientCount: $recipientCount)';
}


}

/// @nodoc
abstract mixin class $AnnouncementModelCopyWith<$Res>  {
  factory $AnnouncementModelCopyWith(AnnouncementModel value, $Res Function(AnnouncementModel) _then) = _$AnnouncementModelCopyWithImpl;
@useResult
$Res call({
 String id, String institutionId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String title, String body, AnnouncementAudience audience, String? classroomId, AnnouncementStatus status, bool requiresReadReceipt, List<String> channels, String? createdBy,@UtcDateTimeConverter() DateTime? publishedAt, int readCount, int recipientCount
});




}
/// @nodoc
class _$AnnouncementModelCopyWithImpl<$Res>
    implements $AnnouncementModelCopyWith<$Res> {
  _$AnnouncementModelCopyWithImpl(this._self, this._then);

  final AnnouncementModel _self;
  final $Res Function(AnnouncementModel) _then;

/// Create a copy of AnnouncementModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? institutionId = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? title = null,Object? body = null,Object? audience = null,Object? classroomId = freezed,Object? status = null,Object? requiresReadReceipt = null,Object? channels = null,Object? createdBy = freezed,Object? publishedAt = freezed,Object? readCount = null,Object? recipientCount = null,}) {
  return _then(AnnouncementModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,audience: null == audience ? _self.audience : audience // ignore: cast_nullable_to_non_nullable
as AnnouncementAudience,classroomId: freezed == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AnnouncementStatus,requiresReadReceipt: null == requiresReadReceipt ? _self.requiresReadReceipt : requiresReadReceipt // ignore: cast_nullable_to_non_nullable
as bool,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as List<String>,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,readCount: null == readCount ? _self.readCount : readCount // ignore: cast_nullable_to_non_nullable
as int,recipientCount: null == recipientCount ? _self.recipientCount : recipientCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AnnouncementModel].
extension AnnouncementModelPatterns on AnnouncementModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnnouncementModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnnouncementModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnnouncementModel value)  $default,){
final _that = this;
switch (_that) {
case _AnnouncementModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnnouncementModel value)?  $default,){
final _that = this;
switch (_that) {
case _AnnouncementModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String institutionId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String title,  String body,  AnnouncementAudience audience,  String? classroomId,  AnnouncementStatus status,  bool requiresReadReceipt,  List<String> channels,  String? createdBy, @UtcDateTimeConverter()  DateTime? publishedAt,  int readCount,  int recipientCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnnouncementModel() when $default != null:
return $default(_that.id,_that.institutionId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.title,_that.body,_that.audience,_that.classroomId,_that.status,_that.requiresReadReceipt,_that.channels,_that.createdBy,_that.publishedAt,_that.readCount,_that.recipientCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String institutionId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String title,  String body,  AnnouncementAudience audience,  String? classroomId,  AnnouncementStatus status,  bool requiresReadReceipt,  List<String> channels,  String? createdBy, @UtcDateTimeConverter()  DateTime? publishedAt,  int readCount,  int recipientCount)  $default,) {final _that = this;
switch (_that) {
case _AnnouncementModel():
return $default(_that.id,_that.institutionId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.title,_that.body,_that.audience,_that.classroomId,_that.status,_that.requiresReadReceipt,_that.channels,_that.createdBy,_that.publishedAt,_that.readCount,_that.recipientCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String institutionId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String title,  String body,  AnnouncementAudience audience,  String? classroomId,  AnnouncementStatus status,  bool requiresReadReceipt,  List<String> channels,  String? createdBy, @UtcDateTimeConverter()  DateTime? publishedAt,  int readCount,  int recipientCount)?  $default,) {final _that = this;
switch (_that) {
case _AnnouncementModel() when $default != null:
return $default(_that.id,_that.institutionId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.title,_that.body,_that.audience,_that.classroomId,_that.status,_that.requiresReadReceipt,_that.channels,_that.createdBy,_that.publishedAt,_that.readCount,_that.recipientCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AnnouncementModel implements AnnouncementModel {
  const _AnnouncementModel({required this.id, required this.institutionId, @UtcDateTimeConverter() required this.createdAt, @UtcDateTimeConverter() required this.updatedAt, @UtcDateTimeConverter() this.deletedAt, this.syncState = 'synced', required this.title, required this.body, required this.audience, this.classroomId, this.status = AnnouncementStatus.published, this.requiresReadReceipt = false,  List<String> channels = const <String>['in_app'], this.createdBy, @UtcDateTimeConverter() this.publishedAt, this.readCount = 0, this.recipientCount = 0}): _channels = channels;
  factory _AnnouncementModel.fromJson(Map<String, dynamic> json) => _$AnnouncementModelFromJson(json);

@override final  String id;
@override final  String institutionId;
@override@UtcDateTimeConverter() final  DateTime createdAt;
@override@UtcDateTimeConverter() final  DateTime updatedAt;
@override@UtcDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  String syncState;
@override final  String title;
@override final  String body;
@override final  AnnouncementAudience audience;
/// Turma alvo (obrigatório para `classroom`; opcional para `guardians`).
@override final  String? classroomId;
@override@JsonKey() final  AnnouncementStatus status;
@override@JsonKey() final  bool requiresReadReceipt;
/// Canais de entrega (`in_app`, `push`, `sms`, `email`).
 final  List<String> _channels;
/// Canais de entrega (`in_app`, `push`, `sms`, `email`).
@override@JsonKey() List<String> get channels {
  if (_channels is EqualUnmodifiableListView) return _channels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_channels);
}

@override final  String? createdBy;
@override@UtcDateTimeConverter() final  DateTime? publishedAt;
/// Quantos já confirmaram a leitura / quantos destinatários (calculado no servidor).
@override@JsonKey() final  int readCount;
@override@JsonKey() final  int recipientCount;

/// Create a copy of AnnouncementModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnouncementModelCopyWith<_AnnouncementModel> get copyWith => __$AnnouncementModelCopyWithImpl<_AnnouncementModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnnouncementModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnnouncementModel&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.audience, audience) || other.audience == audience)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.status, status) || other.status == status)&&(identical(other.requiresReadReceipt, requiresReadReceipt) || other.requiresReadReceipt == requiresReadReceipt)&&const DeepCollectionEquality().equals(other._channels, _channels)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.readCount, readCount) || other.readCount == readCount)&&(identical(other.recipientCount, recipientCount) || other.recipientCount == recipientCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,createdAt,updatedAt,deletedAt,syncState,title,body,audience,classroomId,status,requiresReadReceipt,const DeepCollectionEquality().hash(_channels),createdBy,publishedAt,readCount,recipientCount);

@override
String toString() {
  return 'AnnouncementModel(id: $id, institutionId: $institutionId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, title: $title, body: $body, audience: $audience, classroomId: $classroomId, status: $status, requiresReadReceipt: $requiresReadReceipt, channels: $channels, createdBy: $createdBy, publishedAt: $publishedAt, readCount: $readCount, recipientCount: $recipientCount)';
}


}

/// @nodoc
abstract mixin class _$AnnouncementModelCopyWith<$Res> implements $AnnouncementModelCopyWith<$Res> {
  factory _$AnnouncementModelCopyWith(_AnnouncementModel value, $Res Function(_AnnouncementModel) _then) = __$AnnouncementModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String institutionId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String title, String body, AnnouncementAudience audience, String? classroomId, AnnouncementStatus status, bool requiresReadReceipt, List<String> channels, String? createdBy,@UtcDateTimeConverter() DateTime? publishedAt, int readCount, int recipientCount
});




}
/// @nodoc
class __$AnnouncementModelCopyWithImpl<$Res>
    implements _$AnnouncementModelCopyWith<$Res> {
  __$AnnouncementModelCopyWithImpl(this._self, this._then);

  final _AnnouncementModel _self;
  final $Res Function(_AnnouncementModel) _then;

/// Create a copy of AnnouncementModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? institutionId = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? title = null,Object? body = null,Object? audience = null,Object? classroomId = freezed,Object? status = null,Object? requiresReadReceipt = null,Object? channels = null,Object? createdBy = freezed,Object? publishedAt = freezed,Object? readCount = null,Object? recipientCount = null,}) {
  return _then(_AnnouncementModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,audience: null == audience ? _self.audience : audience // ignore: cast_nullable_to_non_nullable
as AnnouncementAudience,classroomId: freezed == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AnnouncementStatus,requiresReadReceipt: null == requiresReadReceipt ? _self.requiresReadReceipt : requiresReadReceipt // ignore: cast_nullable_to_non_nullable
as bool,channels: null == channels ? _self._channels : channels // ignore: cast_nullable_to_non_nullable
as List<String>,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,readCount: null == readCount ? _self.readCount : readCount // ignore: cast_nullable_to_non_nullable
as int,recipientCount: null == recipientCount ? _self.recipientCount : recipientCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AnnouncementReadModel {

 String get announcementId; String get userId;@UtcDateTimeConverter() DateTime get readAt;
/// Create a copy of AnnouncementReadModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnnouncementReadModelCopyWith<AnnouncementReadModel> get copyWith => _$AnnouncementReadModelCopyWithImpl<AnnouncementReadModel>(this as AnnouncementReadModel, _$identity);

  /// Serializes this AnnouncementReadModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnnouncementReadModel&&(identical(other.announcementId, announcementId) || other.announcementId == announcementId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.readAt, readAt) || other.readAt == readAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,announcementId,userId,readAt);

@override
String toString() {
  return 'AnnouncementReadModel(announcementId: $announcementId, userId: $userId, readAt: $readAt)';
}


}

/// @nodoc
abstract mixin class $AnnouncementReadModelCopyWith<$Res>  {
  factory $AnnouncementReadModelCopyWith(AnnouncementReadModel value, $Res Function(AnnouncementReadModel) _then) = _$AnnouncementReadModelCopyWithImpl;
@useResult
$Res call({
 String announcementId, String userId,@UtcDateTimeConverter() DateTime readAt
});




}
/// @nodoc
class _$AnnouncementReadModelCopyWithImpl<$Res>
    implements $AnnouncementReadModelCopyWith<$Res> {
  _$AnnouncementReadModelCopyWithImpl(this._self, this._then);

  final AnnouncementReadModel _self;
  final $Res Function(AnnouncementReadModel) _then;

/// Create a copy of AnnouncementReadModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? announcementId = null,Object? userId = null,Object? readAt = null,}) {
  return _then(AnnouncementReadModel(
announcementId: null == announcementId ? _self.announcementId : announcementId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,readAt: null == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AnnouncementReadModel].
extension AnnouncementReadModelPatterns on AnnouncementReadModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnnouncementReadModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnnouncementReadModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnnouncementReadModel value)  $default,){
final _that = this;
switch (_that) {
case _AnnouncementReadModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnnouncementReadModel value)?  $default,){
final _that = this;
switch (_that) {
case _AnnouncementReadModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String announcementId,  String userId, @UtcDateTimeConverter()  DateTime readAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnnouncementReadModel() when $default != null:
return $default(_that.announcementId,_that.userId,_that.readAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String announcementId,  String userId, @UtcDateTimeConverter()  DateTime readAt)  $default,) {final _that = this;
switch (_that) {
case _AnnouncementReadModel():
return $default(_that.announcementId,_that.userId,_that.readAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String announcementId,  String userId, @UtcDateTimeConverter()  DateTime readAt)?  $default,) {final _that = this;
switch (_that) {
case _AnnouncementReadModel() when $default != null:
return $default(_that.announcementId,_that.userId,_that.readAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnnouncementReadModel implements AnnouncementReadModel {
  const _AnnouncementReadModel({required this.announcementId, required this.userId, @UtcDateTimeConverter() required this.readAt});
  factory _AnnouncementReadModel.fromJson(Map<String, dynamic> json) => _$AnnouncementReadModelFromJson(json);

@override final  String announcementId;
@override final  String userId;
@override@UtcDateTimeConverter() final  DateTime readAt;

/// Create a copy of AnnouncementReadModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnouncementReadModelCopyWith<_AnnouncementReadModel> get copyWith => __$AnnouncementReadModelCopyWithImpl<_AnnouncementReadModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnnouncementReadModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnnouncementReadModel&&(identical(other.announcementId, announcementId) || other.announcementId == announcementId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.readAt, readAt) || other.readAt == readAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,announcementId,userId,readAt);

@override
String toString() {
  return 'AnnouncementReadModel(announcementId: $announcementId, userId: $userId, readAt: $readAt)';
}


}

/// @nodoc
abstract mixin class _$AnnouncementReadModelCopyWith<$Res> implements $AnnouncementReadModelCopyWith<$Res> {
  factory _$AnnouncementReadModelCopyWith(_AnnouncementReadModel value, $Res Function(_AnnouncementReadModel) _then) = __$AnnouncementReadModelCopyWithImpl;
@override @useResult
$Res call({
 String announcementId, String userId,@UtcDateTimeConverter() DateTime readAt
});




}
/// @nodoc
class __$AnnouncementReadModelCopyWithImpl<$Res>
    implements _$AnnouncementReadModelCopyWith<$Res> {
  __$AnnouncementReadModelCopyWithImpl(this._self, this._then);

  final _AnnouncementReadModel _self;
  final $Res Function(_AnnouncementReadModel) _then;

/// Create a copy of AnnouncementReadModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? announcementId = null,Object? userId = null,Object? readAt = null,}) {
  return _then(_AnnouncementReadModel(
announcementId: null == announcementId ? _self.announcementId : announcementId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,readAt: null == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
