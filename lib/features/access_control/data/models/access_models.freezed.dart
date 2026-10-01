// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'access_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ZoneModel {

 String get id; String get campusId; String get name; String? get description; bool get isActive;
/// Create a copy of ZoneModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ZoneModelCopyWith<ZoneModel> get copyWith => _$ZoneModelCopyWithImpl<ZoneModel>(this as ZoneModel, _$identity);

  /// Serializes this ZoneModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ZoneModel&&(identical(other.id, id) || other.id == id)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,campusId,name,description,isActive);

@override
String toString() {
  return 'ZoneModel(id: $id, campusId: $campusId, name: $name, description: $description, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $ZoneModelCopyWith<$Res>  {
  factory $ZoneModelCopyWith(ZoneModel value, $Res Function(ZoneModel) _then) = _$ZoneModelCopyWithImpl;
@useResult
$Res call({
 String id, String campusId, String name, String? description, bool isActive
});




}
/// @nodoc
class _$ZoneModelCopyWithImpl<$Res>
    implements $ZoneModelCopyWith<$Res> {
  _$ZoneModelCopyWithImpl(this._self, this._then);

  final ZoneModel _self;
  final $Res Function(ZoneModel) _then;

/// Create a copy of ZoneModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? campusId = null,Object? name = null,Object? description = freezed,Object? isActive = null,}) {
  return _then(ZoneModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,campusId: null == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ZoneModel].
extension ZoneModelPatterns on ZoneModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ZoneModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ZoneModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ZoneModel value)  $default,){
final _that = this;
switch (_that) {
case _ZoneModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ZoneModel value)?  $default,){
final _that = this;
switch (_that) {
case _ZoneModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String campusId,  String name,  String? description,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ZoneModel() when $default != null:
return $default(_that.id,_that.campusId,_that.name,_that.description,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String campusId,  String name,  String? description,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _ZoneModel():
return $default(_that.id,_that.campusId,_that.name,_that.description,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String campusId,  String name,  String? description,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _ZoneModel() when $default != null:
return $default(_that.id,_that.campusId,_that.name,_that.description,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ZoneModel implements ZoneModel {
  const _ZoneModel({required this.id, required this.campusId, required this.name, this.description, this.isActive = true});
  factory _ZoneModel.fromJson(Map<String, dynamic> json) => _$ZoneModelFromJson(json);

@override final  String id;
@override final  String campusId;
@override final  String name;
@override final  String? description;
@override@JsonKey() final  bool isActive;

/// Create a copy of ZoneModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ZoneModelCopyWith<_ZoneModel> get copyWith => __$ZoneModelCopyWithImpl<_ZoneModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ZoneModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ZoneModel&&(identical(other.id, id) || other.id == id)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,campusId,name,description,isActive);

@override
String toString() {
  return 'ZoneModel(id: $id, campusId: $campusId, name: $name, description: $description, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ZoneModelCopyWith<$Res> implements $ZoneModelCopyWith<$Res> {
  factory _$ZoneModelCopyWith(_ZoneModel value, $Res Function(_ZoneModel) _then) = __$ZoneModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String campusId, String name, String? description, bool isActive
});




}
/// @nodoc
class __$ZoneModelCopyWithImpl<$Res>
    implements _$ZoneModelCopyWith<$Res> {
  __$ZoneModelCopyWithImpl(this._self, this._then);

  final _ZoneModel _self;
  final $Res Function(_ZoneModel) _then;

/// Create a copy of ZoneModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? campusId = null,Object? name = null,Object? description = freezed,Object? isActive = null,}) {
  return _then(_ZoneModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,campusId: null == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AccessDeviceModel {

 String get id; String get zoneId; String get name; DeviceKind get kind; DeviceStatus get status; bool get isActive;@UtcDateTimeConverter() DateTime? get lastSeenAt;
/// Create a copy of AccessDeviceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccessDeviceModelCopyWith<AccessDeviceModel> get copyWith => _$AccessDeviceModelCopyWithImpl<AccessDeviceModel>(this as AccessDeviceModel, _$identity);

  /// Serializes this AccessDeviceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccessDeviceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.zoneId, zoneId) || other.zoneId == zoneId)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.status, status) || other.status == status)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,zoneId,name,kind,status,isActive,lastSeenAt);

@override
String toString() {
  return 'AccessDeviceModel(id: $id, zoneId: $zoneId, name: $name, kind: $kind, status: $status, isActive: $isActive, lastSeenAt: $lastSeenAt)';
}


}

/// @nodoc
abstract mixin class $AccessDeviceModelCopyWith<$Res>  {
  factory $AccessDeviceModelCopyWith(AccessDeviceModel value, $Res Function(AccessDeviceModel) _then) = _$AccessDeviceModelCopyWithImpl;
@useResult
$Res call({
 String id, String zoneId, String name, DeviceKind kind, DeviceStatus status, bool isActive,@UtcDateTimeConverter() DateTime? lastSeenAt
});




}
/// @nodoc
class _$AccessDeviceModelCopyWithImpl<$Res>
    implements $AccessDeviceModelCopyWith<$Res> {
  _$AccessDeviceModelCopyWithImpl(this._self, this._then);

  final AccessDeviceModel _self;
  final $Res Function(AccessDeviceModel) _then;

/// Create a copy of AccessDeviceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? zoneId = null,Object? name = null,Object? kind = null,Object? status = null,Object? isActive = null,Object? lastSeenAt = freezed,}) {
  return _then(AccessDeviceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,zoneId: null == zoneId ? _self.zoneId : zoneId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DeviceKind,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DeviceStatus,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastSeenAt: freezed == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccessDeviceModel].
extension AccessDeviceModelPatterns on AccessDeviceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccessDeviceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccessDeviceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccessDeviceModel value)  $default,){
final _that = this;
switch (_that) {
case _AccessDeviceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccessDeviceModel value)?  $default,){
final _that = this;
switch (_that) {
case _AccessDeviceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String zoneId,  String name,  DeviceKind kind,  DeviceStatus status,  bool isActive, @UtcDateTimeConverter()  DateTime? lastSeenAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccessDeviceModel() when $default != null:
return $default(_that.id,_that.zoneId,_that.name,_that.kind,_that.status,_that.isActive,_that.lastSeenAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String zoneId,  String name,  DeviceKind kind,  DeviceStatus status,  bool isActive, @UtcDateTimeConverter()  DateTime? lastSeenAt)  $default,) {final _that = this;
switch (_that) {
case _AccessDeviceModel():
return $default(_that.id,_that.zoneId,_that.name,_that.kind,_that.status,_that.isActive,_that.lastSeenAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String zoneId,  String name,  DeviceKind kind,  DeviceStatus status,  bool isActive, @UtcDateTimeConverter()  DateTime? lastSeenAt)?  $default,) {final _that = this;
switch (_that) {
case _AccessDeviceModel() when $default != null:
return $default(_that.id,_that.zoneId,_that.name,_that.kind,_that.status,_that.isActive,_that.lastSeenAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccessDeviceModel implements AccessDeviceModel {
  const _AccessDeviceModel({required this.id, required this.zoneId, required this.name, this.kind = DeviceKind.reader, this.status = DeviceStatus.online, this.isActive = true, @UtcDateTimeConverter() this.lastSeenAt});
  factory _AccessDeviceModel.fromJson(Map<String, dynamic> json) => _$AccessDeviceModelFromJson(json);

@override final  String id;
@override final  String zoneId;
@override final  String name;
@override@JsonKey() final  DeviceKind kind;
@override@JsonKey() final  DeviceStatus status;
@override@JsonKey() final  bool isActive;
@override@UtcDateTimeConverter() final  DateTime? lastSeenAt;

/// Create a copy of AccessDeviceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccessDeviceModelCopyWith<_AccessDeviceModel> get copyWith => __$AccessDeviceModelCopyWithImpl<_AccessDeviceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccessDeviceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccessDeviceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.zoneId, zoneId) || other.zoneId == zoneId)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.status, status) || other.status == status)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,zoneId,name,kind,status,isActive,lastSeenAt);

@override
String toString() {
  return 'AccessDeviceModel(id: $id, zoneId: $zoneId, name: $name, kind: $kind, status: $status, isActive: $isActive, lastSeenAt: $lastSeenAt)';
}


}

/// @nodoc
abstract mixin class _$AccessDeviceModelCopyWith<$Res> implements $AccessDeviceModelCopyWith<$Res> {
  factory _$AccessDeviceModelCopyWith(_AccessDeviceModel value, $Res Function(_AccessDeviceModel) _then) = __$AccessDeviceModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String zoneId, String name, DeviceKind kind, DeviceStatus status, bool isActive,@UtcDateTimeConverter() DateTime? lastSeenAt
});




}
/// @nodoc
class __$AccessDeviceModelCopyWithImpl<$Res>
    implements _$AccessDeviceModelCopyWith<$Res> {
  __$AccessDeviceModelCopyWithImpl(this._self, this._then);

  final _AccessDeviceModel _self;
  final $Res Function(_AccessDeviceModel) _then;

/// Create a copy of AccessDeviceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? zoneId = null,Object? name = null,Object? kind = null,Object? status = null,Object? isActive = null,Object? lastSeenAt = freezed,}) {
  return _then(_AccessDeviceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,zoneId: null == zoneId ? _self.zoneId : zoneId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DeviceKind,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DeviceStatus,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastSeenAt: freezed == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AccessRuleModel {

 String get id; String get zoneId; String get name; AccessSubject get subject; List<int> get days; int get startMinute; int get endMinute; bool get requireActiveStudent; bool get requireFinancialClear; bool get isActive;
/// Create a copy of AccessRuleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccessRuleModelCopyWith<AccessRuleModel> get copyWith => _$AccessRuleModelCopyWithImpl<AccessRuleModel>(this as AccessRuleModel, _$identity);

  /// Serializes this AccessRuleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccessRuleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.zoneId, zoneId) || other.zoneId == zoneId)&&(identical(other.name, name) || other.name == name)&&(identical(other.subject, subject) || other.subject == subject)&&const DeepCollectionEquality().equals(other.days, days)&&(identical(other.startMinute, startMinute) || other.startMinute == startMinute)&&(identical(other.endMinute, endMinute) || other.endMinute == endMinute)&&(identical(other.requireActiveStudent, requireActiveStudent) || other.requireActiveStudent == requireActiveStudent)&&(identical(other.requireFinancialClear, requireFinancialClear) || other.requireFinancialClear == requireFinancialClear)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,zoneId,name,subject,const DeepCollectionEquality().hash(days),startMinute,endMinute,requireActiveStudent,requireFinancialClear,isActive);

@override
String toString() {
  return 'AccessRuleModel(id: $id, zoneId: $zoneId, name: $name, subject: $subject, days: $days, startMinute: $startMinute, endMinute: $endMinute, requireActiveStudent: $requireActiveStudent, requireFinancialClear: $requireFinancialClear, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $AccessRuleModelCopyWith<$Res>  {
  factory $AccessRuleModelCopyWith(AccessRuleModel value, $Res Function(AccessRuleModel) _then) = _$AccessRuleModelCopyWithImpl;
@useResult
$Res call({
 String id, String zoneId, String name, AccessSubject subject, List<int> days, int startMinute, int endMinute, bool requireActiveStudent, bool requireFinancialClear, bool isActive
});




}
/// @nodoc
class _$AccessRuleModelCopyWithImpl<$Res>
    implements $AccessRuleModelCopyWith<$Res> {
  _$AccessRuleModelCopyWithImpl(this._self, this._then);

  final AccessRuleModel _self;
  final $Res Function(AccessRuleModel) _then;

/// Create a copy of AccessRuleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? zoneId = null,Object? name = null,Object? subject = null,Object? days = null,Object? startMinute = null,Object? endMinute = null,Object? requireActiveStudent = null,Object? requireFinancialClear = null,Object? isActive = null,}) {
  return _then(AccessRuleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,zoneId: null == zoneId ? _self.zoneId : zoneId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as AccessSubject,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<int>,startMinute: null == startMinute ? _self.startMinute : startMinute // ignore: cast_nullable_to_non_nullable
as int,endMinute: null == endMinute ? _self.endMinute : endMinute // ignore: cast_nullable_to_non_nullable
as int,requireActiveStudent: null == requireActiveStudent ? _self.requireActiveStudent : requireActiveStudent // ignore: cast_nullable_to_non_nullable
as bool,requireFinancialClear: null == requireFinancialClear ? _self.requireFinancialClear : requireFinancialClear // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AccessRuleModel].
extension AccessRuleModelPatterns on AccessRuleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccessRuleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccessRuleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccessRuleModel value)  $default,){
final _that = this;
switch (_that) {
case _AccessRuleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccessRuleModel value)?  $default,){
final _that = this;
switch (_that) {
case _AccessRuleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String zoneId,  String name,  AccessSubject subject,  List<int> days,  int startMinute,  int endMinute,  bool requireActiveStudent,  bool requireFinancialClear,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccessRuleModel() when $default != null:
return $default(_that.id,_that.zoneId,_that.name,_that.subject,_that.days,_that.startMinute,_that.endMinute,_that.requireActiveStudent,_that.requireFinancialClear,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String zoneId,  String name,  AccessSubject subject,  List<int> days,  int startMinute,  int endMinute,  bool requireActiveStudent,  bool requireFinancialClear,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _AccessRuleModel():
return $default(_that.id,_that.zoneId,_that.name,_that.subject,_that.days,_that.startMinute,_that.endMinute,_that.requireActiveStudent,_that.requireFinancialClear,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String zoneId,  String name,  AccessSubject subject,  List<int> days,  int startMinute,  int endMinute,  bool requireActiveStudent,  bool requireFinancialClear,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _AccessRuleModel() when $default != null:
return $default(_that.id,_that.zoneId,_that.name,_that.subject,_that.days,_that.startMinute,_that.endMinute,_that.requireActiveStudent,_that.requireFinancialClear,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccessRuleModel implements AccessRuleModel {
  const _AccessRuleModel({required this.id, required this.zoneId, required this.name, this.subject = AccessSubject.all, required  List<int> days, required this.startMinute, required this.endMinute, this.requireActiveStudent = false, this.requireFinancialClear = false, this.isActive = true}): _days = days;
  factory _AccessRuleModel.fromJson(Map<String, dynamic> json) => _$AccessRuleModelFromJson(json);

@override final  String id;
@override final  String zoneId;
@override final  String name;
@override@JsonKey() final  AccessSubject subject;
 final  List<int> _days;
@override List<int> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}

@override final  int startMinute;
@override final  int endMinute;
@override@JsonKey() final  bool requireActiveStudent;
@override@JsonKey() final  bool requireFinancialClear;
@override@JsonKey() final  bool isActive;

/// Create a copy of AccessRuleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccessRuleModelCopyWith<_AccessRuleModel> get copyWith => __$AccessRuleModelCopyWithImpl<_AccessRuleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccessRuleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccessRuleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.zoneId, zoneId) || other.zoneId == zoneId)&&(identical(other.name, name) || other.name == name)&&(identical(other.subject, subject) || other.subject == subject)&&const DeepCollectionEquality().equals(other._days, _days)&&(identical(other.startMinute, startMinute) || other.startMinute == startMinute)&&(identical(other.endMinute, endMinute) || other.endMinute == endMinute)&&(identical(other.requireActiveStudent, requireActiveStudent) || other.requireActiveStudent == requireActiveStudent)&&(identical(other.requireFinancialClear, requireFinancialClear) || other.requireFinancialClear == requireFinancialClear)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,zoneId,name,subject,const DeepCollectionEquality().hash(_days),startMinute,endMinute,requireActiveStudent,requireFinancialClear,isActive);

@override
String toString() {
  return 'AccessRuleModel(id: $id, zoneId: $zoneId, name: $name, subject: $subject, days: $days, startMinute: $startMinute, endMinute: $endMinute, requireActiveStudent: $requireActiveStudent, requireFinancialClear: $requireFinancialClear, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$AccessRuleModelCopyWith<$Res> implements $AccessRuleModelCopyWith<$Res> {
  factory _$AccessRuleModelCopyWith(_AccessRuleModel value, $Res Function(_AccessRuleModel) _then) = __$AccessRuleModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String zoneId, String name, AccessSubject subject, List<int> days, int startMinute, int endMinute, bool requireActiveStudent, bool requireFinancialClear, bool isActive
});




}
/// @nodoc
class __$AccessRuleModelCopyWithImpl<$Res>
    implements _$AccessRuleModelCopyWith<$Res> {
  __$AccessRuleModelCopyWithImpl(this._self, this._then);

  final _AccessRuleModel _self;
  final $Res Function(_AccessRuleModel) _then;

/// Create a copy of AccessRuleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? zoneId = null,Object? name = null,Object? subject = null,Object? days = null,Object? startMinute = null,Object? endMinute = null,Object? requireActiveStudent = null,Object? requireFinancialClear = null,Object? isActive = null,}) {
  return _then(_AccessRuleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,zoneId: null == zoneId ? _self.zoneId : zoneId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as AccessSubject,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<int>,startMinute: null == startMinute ? _self.startMinute : startMinute // ignore: cast_nullable_to_non_nullable
as int,endMinute: null == endMinute ? _self.endMinute : endMinute // ignore: cast_nullable_to_non_nullable
as int,requireActiveStudent: null == requireActiveStudent ? _self.requireActiveStudent : requireActiveStudent // ignore: cast_nullable_to_non_nullable
as bool,requireFinancialClear: null == requireFinancialClear ? _self.requireFinancialClear : requireFinancialClear // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
