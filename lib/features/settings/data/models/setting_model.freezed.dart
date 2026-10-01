// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setting_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SettingModel {

 String get key; SettingModule get module; SettingType get type;/// `int`, `bool` ou `String` consoante [type]; percentagens em pontos
/// base (1400 = 14 %) e dinheiro na menor unidade.
 Object get value; int? get min; int? get max; List<String> get options;
/// Create a copy of SettingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingModelCopyWith<SettingModel> get copyWith => _$SettingModelCopyWithImpl<SettingModel>(this as SettingModel, _$identity);

  /// Serializes this SettingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingModel&&(identical(other.key, key) || other.key == key)&&(identical(other.module, module) || other.module == module)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,module,type,const DeepCollectionEquality().hash(value),min,max,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'SettingModel(key: $key, module: $module, type: $type, value: $value, min: $min, max: $max, options: $options)';
}


}

/// @nodoc
abstract mixin class $SettingModelCopyWith<$Res>  {
  factory $SettingModelCopyWith(SettingModel value, $Res Function(SettingModel) _then) = _$SettingModelCopyWithImpl;
@useResult
$Res call({
 String key, SettingModule module, SettingType type, Object value, int? min, int? max, List<String> options
});




}
/// @nodoc
class _$SettingModelCopyWithImpl<$Res>
    implements $SettingModelCopyWith<$Res> {
  _$SettingModelCopyWithImpl(this._self, this._then);

  final SettingModel _self;
  final $Res Function(SettingModel) _then;

/// Create a copy of SettingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? module = null,Object? type = null,Object? value = null,Object? min = freezed,Object? max = freezed,Object? options = null,}) {
  return _then(SettingModel(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as SettingModule,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SettingType,value: null == value ? _self.value : value ,min: freezed == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as int?,max: freezed == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingModel].
extension SettingModelPatterns on SettingModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingModel value)  $default,){
final _that = this;
switch (_that) {
case _SettingModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingModel value)?  $default,){
final _that = this;
switch (_that) {
case _SettingModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  SettingModule module,  SettingType type,  Object value,  int? min,  int? max,  List<String> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingModel() when $default != null:
return $default(_that.key,_that.module,_that.type,_that.value,_that.min,_that.max,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  SettingModule module,  SettingType type,  Object value,  int? min,  int? max,  List<String> options)  $default,) {final _that = this;
switch (_that) {
case _SettingModel():
return $default(_that.key,_that.module,_that.type,_that.value,_that.min,_that.max,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  SettingModule module,  SettingType type,  Object value,  int? min,  int? max,  List<String> options)?  $default,) {final _that = this;
switch (_that) {
case _SettingModel() when $default != null:
return $default(_that.key,_that.module,_that.type,_that.value,_that.min,_that.max,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SettingModel implements SettingModel {
  const _SettingModel({required this.key, required this.module, required this.type, required this.value, this.min, this.max,  List<String> options = const <String>[]}): _options = options;
  factory _SettingModel.fromJson(Map<String, dynamic> json) => _$SettingModelFromJson(json);

@override final  String key;
@override final  SettingModule module;
@override final  SettingType type;
/// `int`, `bool` ou `String` consoante [type]; percentagens em pontos
/// base (1400 = 14 %) e dinheiro na menor unidade.
@override final  Object value;
@override final  int? min;
@override final  int? max;
 final  List<String> _options;
@override@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of SettingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingModelCopyWith<_SettingModel> get copyWith => __$SettingModelCopyWithImpl<_SettingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettingModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingModel&&(identical(other.key, key) || other.key == key)&&(identical(other.module, module) || other.module == module)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&const DeepCollectionEquality().equals(other._options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,module,type,const DeepCollectionEquality().hash(value),min,max,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'SettingModel(key: $key, module: $module, type: $type, value: $value, min: $min, max: $max, options: $options)';
}


}

/// @nodoc
abstract mixin class _$SettingModelCopyWith<$Res> implements $SettingModelCopyWith<$Res> {
  factory _$SettingModelCopyWith(_SettingModel value, $Res Function(_SettingModel) _then) = __$SettingModelCopyWithImpl;
@override @useResult
$Res call({
 String key, SettingModule module, SettingType type, Object value, int? min, int? max, List<String> options
});




}
/// @nodoc
class __$SettingModelCopyWithImpl<$Res>
    implements _$SettingModelCopyWith<$Res> {
  __$SettingModelCopyWithImpl(this._self, this._then);

  final _SettingModel _self;
  final $Res Function(_SettingModel) _then;

/// Create a copy of SettingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? module = null,Object? type = null,Object? value = null,Object? min = freezed,Object? max = freezed,Object? options = null,}) {
  return _then(_SettingModel(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as SettingModule,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SettingType,value: null == value ? _self.value : value ,min: freezed == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as int?,max: freezed == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int?,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
