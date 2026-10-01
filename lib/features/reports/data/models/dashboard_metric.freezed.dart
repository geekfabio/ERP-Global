// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_metric.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardMetric {

 String get widgetId; int get value; int? get previous;
/// Create a copy of DashboardMetric
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardMetricCopyWith<DashboardMetric> get copyWith => _$DashboardMetricCopyWithImpl<DashboardMetric>(this as DashboardMetric, _$identity);

  /// Serializes this DashboardMetric to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardMetric&&(identical(other.widgetId, widgetId) || other.widgetId == widgetId)&&(identical(other.value, value) || other.value == value)&&(identical(other.previous, previous) || other.previous == previous));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,widgetId,value,previous);

@override
String toString() {
  return 'DashboardMetric(widgetId: $widgetId, value: $value, previous: $previous)';
}


}

/// @nodoc
abstract mixin class $DashboardMetricCopyWith<$Res>  {
  factory $DashboardMetricCopyWith(DashboardMetric value, $Res Function(DashboardMetric) _then) = _$DashboardMetricCopyWithImpl;
@useResult
$Res call({
 String widgetId, int value, int? previous
});




}
/// @nodoc
class _$DashboardMetricCopyWithImpl<$Res>
    implements $DashboardMetricCopyWith<$Res> {
  _$DashboardMetricCopyWithImpl(this._self, this._then);

  final DashboardMetric _self;
  final $Res Function(DashboardMetric) _then;

/// Create a copy of DashboardMetric
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? widgetId = null,Object? value = null,Object? previous = freezed,}) {
  return _then(DashboardMetric(
widgetId: null == widgetId ? _self.widgetId : widgetId // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardMetric].
extension DashboardMetricPatterns on DashboardMetric {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardMetric value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardMetric() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardMetric value)  $default,){
final _that = this;
switch (_that) {
case _DashboardMetric():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardMetric value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardMetric() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String widgetId,  int value,  int? previous)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardMetric() when $default != null:
return $default(_that.widgetId,_that.value,_that.previous);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String widgetId,  int value,  int? previous)  $default,) {final _that = this;
switch (_that) {
case _DashboardMetric():
return $default(_that.widgetId,_that.value,_that.previous);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String widgetId,  int value,  int? previous)?  $default,) {final _that = this;
switch (_that) {
case _DashboardMetric() when $default != null:
return $default(_that.widgetId,_that.value,_that.previous);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardMetric implements DashboardMetric {
  const _DashboardMetric({required this.widgetId, required this.value, this.previous});
  factory _DashboardMetric.fromJson(Map<String, dynamic> json) => _$DashboardMetricFromJson(json);

@override final  String widgetId;
@override final  int value;
@override final  int? previous;

/// Create a copy of DashboardMetric
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardMetricCopyWith<_DashboardMetric> get copyWith => __$DashboardMetricCopyWithImpl<_DashboardMetric>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardMetricToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardMetric&&(identical(other.widgetId, widgetId) || other.widgetId == widgetId)&&(identical(other.value, value) || other.value == value)&&(identical(other.previous, previous) || other.previous == previous));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,widgetId,value,previous);

@override
String toString() {
  return 'DashboardMetric(widgetId: $widgetId, value: $value, previous: $previous)';
}


}

/// @nodoc
abstract mixin class _$DashboardMetricCopyWith<$Res> implements $DashboardMetricCopyWith<$Res> {
  factory _$DashboardMetricCopyWith(_DashboardMetric value, $Res Function(_DashboardMetric) _then) = __$DashboardMetricCopyWithImpl;
@override @useResult
$Res call({
 String widgetId, int value, int? previous
});




}
/// @nodoc
class __$DashboardMetricCopyWithImpl<$Res>
    implements _$DashboardMetricCopyWith<$Res> {
  __$DashboardMetricCopyWithImpl(this._self, this._then);

  final _DashboardMetric _self;
  final $Res Function(_DashboardMetric) _then;

/// Create a copy of DashboardMetric
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? widgetId = null,Object? value = null,Object? previous = freezed,}) {
  return _then(_DashboardMetric(
widgetId: null == widgetId ? _self.widgetId : widgetId // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$CampusOption {

 String get id; String get name;
/// Create a copy of CampusOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CampusOptionCopyWith<CampusOption> get copyWith => _$CampusOptionCopyWithImpl<CampusOption>(this as CampusOption, _$identity);

  /// Serializes this CampusOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CampusOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'CampusOption(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $CampusOptionCopyWith<$Res>  {
  factory $CampusOptionCopyWith(CampusOption value, $Res Function(CampusOption) _then) = _$CampusOptionCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$CampusOptionCopyWithImpl<$Res>
    implements $CampusOptionCopyWith<$Res> {
  _$CampusOptionCopyWithImpl(this._self, this._then);

  final CampusOption _self;
  final $Res Function(CampusOption) _then;

/// Create a copy of CampusOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(CampusOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CampusOption].
extension CampusOptionPatterns on CampusOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CampusOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CampusOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CampusOption value)  $default,){
final _that = this;
switch (_that) {
case _CampusOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CampusOption value)?  $default,){
final _that = this;
switch (_that) {
case _CampusOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CampusOption() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _CampusOption():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _CampusOption() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CampusOption implements CampusOption {
  const _CampusOption({required this.id, required this.name});
  factory _CampusOption.fromJson(Map<String, dynamic> json) => _$CampusOptionFromJson(json);

@override final  String id;
@override final  String name;

/// Create a copy of CampusOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CampusOptionCopyWith<_CampusOption> get copyWith => __$CampusOptionCopyWithImpl<_CampusOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CampusOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CampusOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'CampusOption(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$CampusOptionCopyWith<$Res> implements $CampusOptionCopyWith<$Res> {
  factory _$CampusOptionCopyWith(_CampusOption value, $Res Function(_CampusOption) _then) = __$CampusOptionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$CampusOptionCopyWithImpl<$Res>
    implements _$CampusOptionCopyWith<$Res> {
  __$CampusOptionCopyWithImpl(this._self, this._then);

  final _CampusOption _self;
  final $Res Function(_CampusOption) _then;

/// Create a copy of CampusOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_CampusOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
