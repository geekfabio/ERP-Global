// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'institution_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InstitutionModel {

 String get id; String get name; String get nif; String get address; String get phone; String get email; String get brandColor; String? get logoUrl;
/// Create a copy of InstitutionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstitutionModelCopyWith<InstitutionModel> get copyWith => _$InstitutionModelCopyWithImpl<InstitutionModel>(this as InstitutionModel, _$identity);

  /// Serializes this InstitutionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstitutionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nif, nif) || other.nif == nif)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.brandColor, brandColor) || other.brandColor == brandColor)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nif,address,phone,email,brandColor,logoUrl);

@override
String toString() {
  return 'InstitutionModel(id: $id, name: $name, nif: $nif, address: $address, phone: $phone, email: $email, brandColor: $brandColor, logoUrl: $logoUrl)';
}


}

/// @nodoc
abstract mixin class $InstitutionModelCopyWith<$Res>  {
  factory $InstitutionModelCopyWith(InstitutionModel value, $Res Function(InstitutionModel) _then) = _$InstitutionModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String nif, String address, String phone, String email, String brandColor, String? logoUrl
});




}
/// @nodoc
class _$InstitutionModelCopyWithImpl<$Res>
    implements $InstitutionModelCopyWith<$Res> {
  _$InstitutionModelCopyWithImpl(this._self, this._then);

  final InstitutionModel _self;
  final $Res Function(InstitutionModel) _then;

/// Create a copy of InstitutionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nif = null,Object? address = null,Object? phone = null,Object? email = null,Object? brandColor = null,Object? logoUrl = freezed,}) {
  return _then(InstitutionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nif: null == nif ? _self.nif : nif // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,brandColor: null == brandColor ? _self.brandColor : brandColor // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InstitutionModel].
extension InstitutionModelPatterns on InstitutionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstitutionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstitutionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstitutionModel value)  $default,){
final _that = this;
switch (_that) {
case _InstitutionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstitutionModel value)?  $default,){
final _that = this;
switch (_that) {
case _InstitutionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String nif,  String address,  String phone,  String email,  String brandColor,  String? logoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstitutionModel() when $default != null:
return $default(_that.id,_that.name,_that.nif,_that.address,_that.phone,_that.email,_that.brandColor,_that.logoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String nif,  String address,  String phone,  String email,  String brandColor,  String? logoUrl)  $default,) {final _that = this;
switch (_that) {
case _InstitutionModel():
return $default(_that.id,_that.name,_that.nif,_that.address,_that.phone,_that.email,_that.brandColor,_that.logoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String nif,  String address,  String phone,  String email,  String brandColor,  String? logoUrl)?  $default,) {final _that = this;
switch (_that) {
case _InstitutionModel() when $default != null:
return $default(_that.id,_that.name,_that.nif,_that.address,_that.phone,_that.email,_that.brandColor,_that.logoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InstitutionModel implements InstitutionModel {
  const _InstitutionModel({required this.id, required this.name, required this.nif, required this.address, required this.phone, required this.email, required this.brandColor, this.logoUrl});
  factory _InstitutionModel.fromJson(Map<String, dynamic> json) => _$InstitutionModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String nif;
@override final  String address;
@override final  String phone;
@override final  String email;
@override final  String brandColor;
@override final  String? logoUrl;

/// Create a copy of InstitutionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstitutionModelCopyWith<_InstitutionModel> get copyWith => __$InstitutionModelCopyWithImpl<_InstitutionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InstitutionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstitutionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nif, nif) || other.nif == nif)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.brandColor, brandColor) || other.brandColor == brandColor)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nif,address,phone,email,brandColor,logoUrl);

@override
String toString() {
  return 'InstitutionModel(id: $id, name: $name, nif: $nif, address: $address, phone: $phone, email: $email, brandColor: $brandColor, logoUrl: $logoUrl)';
}


}

/// @nodoc
abstract mixin class _$InstitutionModelCopyWith<$Res> implements $InstitutionModelCopyWith<$Res> {
  factory _$InstitutionModelCopyWith(_InstitutionModel value, $Res Function(_InstitutionModel) _then) = __$InstitutionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String nif, String address, String phone, String email, String brandColor, String? logoUrl
});




}
/// @nodoc
class __$InstitutionModelCopyWithImpl<$Res>
    implements _$InstitutionModelCopyWith<$Res> {
  __$InstitutionModelCopyWithImpl(this._self, this._then);

  final _InstitutionModel _self;
  final $Res Function(_InstitutionModel) _then;

/// Create a copy of InstitutionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nif = null,Object? address = null,Object? phone = null,Object? email = null,Object? brandColor = null,Object? logoUrl = freezed,}) {
  return _then(_InstitutionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nif: null == nif ? _self.nif : nif // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,brandColor: null == brandColor ? _self.brandColor : brandColor // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
