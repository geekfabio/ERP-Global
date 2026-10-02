// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'campus_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CampusModel {

 String get id; String get institutionId; String get name; String get address; String get phone;
/// Create a copy of CampusModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CampusModelCopyWith<CampusModel> get copyWith => _$CampusModelCopyWithImpl<CampusModel>(this as CampusModel, _$identity);

  /// Serializes this CampusModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CampusModel&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,name,address,phone);

@override
String toString() {
  return 'CampusModel(id: $id, institutionId: $institutionId, name: $name, address: $address, phone: $phone)';
}


}

/// @nodoc
abstract mixin class $CampusModelCopyWith<$Res>  {
  factory $CampusModelCopyWith(CampusModel value, $Res Function(CampusModel) _then) = _$CampusModelCopyWithImpl;
@useResult
$Res call({
 String id, String institutionId, String name, String address, String phone
});




}
/// @nodoc
class _$CampusModelCopyWithImpl<$Res>
    implements $CampusModelCopyWith<$Res> {
  _$CampusModelCopyWithImpl(this._self, this._then);

  final CampusModel _self;
  final $Res Function(CampusModel) _then;

/// Create a copy of CampusModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? institutionId = null,Object? name = null,Object? address = null,Object? phone = null,}) {
  return _then(CampusModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CampusModel].
extension CampusModelPatterns on CampusModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CampusModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CampusModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CampusModel value)  $default,){
final _that = this;
switch (_that) {
case _CampusModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CampusModel value)?  $default,){
final _that = this;
switch (_that) {
case _CampusModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String institutionId,  String name,  String address,  String phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CampusModel() when $default != null:
return $default(_that.id,_that.institutionId,_that.name,_that.address,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String institutionId,  String name,  String address,  String phone)  $default,) {final _that = this;
switch (_that) {
case _CampusModel():
return $default(_that.id,_that.institutionId,_that.name,_that.address,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String institutionId,  String name,  String address,  String phone)?  $default,) {final _that = this;
switch (_that) {
case _CampusModel() when $default != null:
return $default(_that.id,_that.institutionId,_that.name,_that.address,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CampusModel implements CampusModel {
  const _CampusModel({required this.id, required this.institutionId, required this.name, required this.address, required this.phone});
  factory _CampusModel.fromJson(Map<String, dynamic> json) => _$CampusModelFromJson(json);

@override final  String id;
@override final  String institutionId;
@override final  String name;
@override final  String address;
@override final  String phone;

/// Create a copy of CampusModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CampusModelCopyWith<_CampusModel> get copyWith => __$CampusModelCopyWithImpl<_CampusModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CampusModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CampusModel&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,name,address,phone);

@override
String toString() {
  return 'CampusModel(id: $id, institutionId: $institutionId, name: $name, address: $address, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$CampusModelCopyWith<$Res> implements $CampusModelCopyWith<$Res> {
  factory _$CampusModelCopyWith(_CampusModel value, $Res Function(_CampusModel) _then) = __$CampusModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String institutionId, String name, String address, String phone
});




}
/// @nodoc
class __$CampusModelCopyWithImpl<$Res>
    implements _$CampusModelCopyWith<$Res> {
  __$CampusModelCopyWithImpl(this._self, this._then);

  final _CampusModel _self;
  final $Res Function(_CampusModel) _then;

/// Create a copy of CampusModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? institutionId = null,Object? name = null,Object? address = null,Object? phone = null,}) {
  return _then(_CampusModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
