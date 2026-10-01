// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_rows.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RevenueRow {

 String get key;@MinorUnitConverter() int get receivedMinor; int get allocationCount;
/// Create a copy of RevenueRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RevenueRowCopyWith<RevenueRow> get copyWith => _$RevenueRowCopyWithImpl<RevenueRow>(this as RevenueRow, _$identity);

  /// Serializes this RevenueRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RevenueRow&&(identical(other.key, key) || other.key == key)&&(identical(other.receivedMinor, receivedMinor) || other.receivedMinor == receivedMinor)&&(identical(other.allocationCount, allocationCount) || other.allocationCount == allocationCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,receivedMinor,allocationCount);

@override
String toString() {
  return 'RevenueRow(key: $key, receivedMinor: $receivedMinor, allocationCount: $allocationCount)';
}


}

/// @nodoc
abstract mixin class $RevenueRowCopyWith<$Res>  {
  factory $RevenueRowCopyWith(RevenueRow value, $Res Function(RevenueRow) _then) = _$RevenueRowCopyWithImpl;
@useResult
$Res call({
 String key,@MinorUnitConverter() int receivedMinor, int allocationCount
});




}
/// @nodoc
class _$RevenueRowCopyWithImpl<$Res>
    implements $RevenueRowCopyWith<$Res> {
  _$RevenueRowCopyWithImpl(this._self, this._then);

  final RevenueRow _self;
  final $Res Function(RevenueRow) _then;

/// Create a copy of RevenueRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? receivedMinor = null,Object? allocationCount = null,}) {
  return _then(RevenueRow(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,receivedMinor: null == receivedMinor ? _self.receivedMinor : receivedMinor // ignore: cast_nullable_to_non_nullable
as int,allocationCount: null == allocationCount ? _self.allocationCount : allocationCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RevenueRow].
extension RevenueRowPatterns on RevenueRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RevenueRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RevenueRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RevenueRow value)  $default,){
final _that = this;
switch (_that) {
case _RevenueRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RevenueRow value)?  $default,){
final _that = this;
switch (_that) {
case _RevenueRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key, @MinorUnitConverter()  int receivedMinor,  int allocationCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RevenueRow() when $default != null:
return $default(_that.key,_that.receivedMinor,_that.allocationCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key, @MinorUnitConverter()  int receivedMinor,  int allocationCount)  $default,) {final _that = this;
switch (_that) {
case _RevenueRow():
return $default(_that.key,_that.receivedMinor,_that.allocationCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key, @MinorUnitConverter()  int receivedMinor,  int allocationCount)?  $default,) {final _that = this;
switch (_that) {
case _RevenueRow() when $default != null:
return $default(_that.key,_that.receivedMinor,_that.allocationCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _RevenueRow implements RevenueRow {
  const _RevenueRow({required this.key, @MinorUnitConverter() required this.receivedMinor, required this.allocationCount});
  factory _RevenueRow.fromJson(Map<String, dynamic> json) => _$RevenueRowFromJson(json);

@override final  String key;
@override@MinorUnitConverter() final  int receivedMinor;
@override final  int allocationCount;

/// Create a copy of RevenueRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RevenueRowCopyWith<_RevenueRow> get copyWith => __$RevenueRowCopyWithImpl<_RevenueRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RevenueRowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RevenueRow&&(identical(other.key, key) || other.key == key)&&(identical(other.receivedMinor, receivedMinor) || other.receivedMinor == receivedMinor)&&(identical(other.allocationCount, allocationCount) || other.allocationCount == allocationCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,receivedMinor,allocationCount);

@override
String toString() {
  return 'RevenueRow(key: $key, receivedMinor: $receivedMinor, allocationCount: $allocationCount)';
}


}

/// @nodoc
abstract mixin class _$RevenueRowCopyWith<$Res> implements $RevenueRowCopyWith<$Res> {
  factory _$RevenueRowCopyWith(_RevenueRow value, $Res Function(_RevenueRow) _then) = __$RevenueRowCopyWithImpl;
@override @useResult
$Res call({
 String key,@MinorUnitConverter() int receivedMinor, int allocationCount
});




}
/// @nodoc
class __$RevenueRowCopyWithImpl<$Res>
    implements _$RevenueRowCopyWith<$Res> {
  __$RevenueRowCopyWithImpl(this._self, this._then);

  final _RevenueRow _self;
  final $Res Function(_RevenueRow) _then;

/// Create a copy of RevenueRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? receivedMinor = null,Object? allocationCount = null,}) {
  return _then(_RevenueRow(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,receivedMinor: null == receivedMinor ? _self.receivedMinor : receivedMinor // ignore: cast_nullable_to_non_nullable
as int,allocationCount: null == allocationCount ? _self.allocationCount : allocationCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ForecastRow {

 String get period;@MinorUnitConverter() int get expectedMinor;@MinorUnitConverter() int get receivedMinor; int get chargeCount;
/// Create a copy of ForecastRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForecastRowCopyWith<ForecastRow> get copyWith => _$ForecastRowCopyWithImpl<ForecastRow>(this as ForecastRow, _$identity);

  /// Serializes this ForecastRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForecastRow&&(identical(other.period, period) || other.period == period)&&(identical(other.expectedMinor, expectedMinor) || other.expectedMinor == expectedMinor)&&(identical(other.receivedMinor, receivedMinor) || other.receivedMinor == receivedMinor)&&(identical(other.chargeCount, chargeCount) || other.chargeCount == chargeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,period,expectedMinor,receivedMinor,chargeCount);

@override
String toString() {
  return 'ForecastRow(period: $period, expectedMinor: $expectedMinor, receivedMinor: $receivedMinor, chargeCount: $chargeCount)';
}


}

/// @nodoc
abstract mixin class $ForecastRowCopyWith<$Res>  {
  factory $ForecastRowCopyWith(ForecastRow value, $Res Function(ForecastRow) _then) = _$ForecastRowCopyWithImpl;
@useResult
$Res call({
 String period,@MinorUnitConverter() int expectedMinor,@MinorUnitConverter() int receivedMinor, int chargeCount
});




}
/// @nodoc
class _$ForecastRowCopyWithImpl<$Res>
    implements $ForecastRowCopyWith<$Res> {
  _$ForecastRowCopyWithImpl(this._self, this._then);

  final ForecastRow _self;
  final $Res Function(ForecastRow) _then;

/// Create a copy of ForecastRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? period = null,Object? expectedMinor = null,Object? receivedMinor = null,Object? chargeCount = null,}) {
  return _then(ForecastRow(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,expectedMinor: null == expectedMinor ? _self.expectedMinor : expectedMinor // ignore: cast_nullable_to_non_nullable
as int,receivedMinor: null == receivedMinor ? _self.receivedMinor : receivedMinor // ignore: cast_nullable_to_non_nullable
as int,chargeCount: null == chargeCount ? _self.chargeCount : chargeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ForecastRow].
extension ForecastRowPatterns on ForecastRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForecastRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForecastRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForecastRow value)  $default,){
final _that = this;
switch (_that) {
case _ForecastRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForecastRow value)?  $default,){
final _that = this;
switch (_that) {
case _ForecastRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String period, @MinorUnitConverter()  int expectedMinor, @MinorUnitConverter()  int receivedMinor,  int chargeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForecastRow() when $default != null:
return $default(_that.period,_that.expectedMinor,_that.receivedMinor,_that.chargeCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String period, @MinorUnitConverter()  int expectedMinor, @MinorUnitConverter()  int receivedMinor,  int chargeCount)  $default,) {final _that = this;
switch (_that) {
case _ForecastRow():
return $default(_that.period,_that.expectedMinor,_that.receivedMinor,_that.chargeCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String period, @MinorUnitConverter()  int expectedMinor, @MinorUnitConverter()  int receivedMinor,  int chargeCount)?  $default,) {final _that = this;
switch (_that) {
case _ForecastRow() when $default != null:
return $default(_that.period,_that.expectedMinor,_that.receivedMinor,_that.chargeCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ForecastRow implements ForecastRow {
  const _ForecastRow({required this.period, @MinorUnitConverter() required this.expectedMinor, @MinorUnitConverter() required this.receivedMinor, required this.chargeCount});
  factory _ForecastRow.fromJson(Map<String, dynamic> json) => _$ForecastRowFromJson(json);

@override final  String period;
@override@MinorUnitConverter() final  int expectedMinor;
@override@MinorUnitConverter() final  int receivedMinor;
@override final  int chargeCount;

/// Create a copy of ForecastRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForecastRowCopyWith<_ForecastRow> get copyWith => __$ForecastRowCopyWithImpl<_ForecastRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForecastRowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForecastRow&&(identical(other.period, period) || other.period == period)&&(identical(other.expectedMinor, expectedMinor) || other.expectedMinor == expectedMinor)&&(identical(other.receivedMinor, receivedMinor) || other.receivedMinor == receivedMinor)&&(identical(other.chargeCount, chargeCount) || other.chargeCount == chargeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,period,expectedMinor,receivedMinor,chargeCount);

@override
String toString() {
  return 'ForecastRow(period: $period, expectedMinor: $expectedMinor, receivedMinor: $receivedMinor, chargeCount: $chargeCount)';
}


}

/// @nodoc
abstract mixin class _$ForecastRowCopyWith<$Res> implements $ForecastRowCopyWith<$Res> {
  factory _$ForecastRowCopyWith(_ForecastRow value, $Res Function(_ForecastRow) _then) = __$ForecastRowCopyWithImpl;
@override @useResult
$Res call({
 String period,@MinorUnitConverter() int expectedMinor,@MinorUnitConverter() int receivedMinor, int chargeCount
});




}
/// @nodoc
class __$ForecastRowCopyWithImpl<$Res>
    implements _$ForecastRowCopyWith<$Res> {
  __$ForecastRowCopyWithImpl(this._self, this._then);

  final _ForecastRow _self;
  final $Res Function(_ForecastRow) _then;

/// Create a copy of ForecastRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? period = null,Object? expectedMinor = null,Object? receivedMinor = null,Object? chargeCount = null,}) {
  return _then(_ForecastRow(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,expectedMinor: null == expectedMinor ? _self.expectedMinor : expectedMinor // ignore: cast_nullable_to_non_nullable
as int,receivedMinor: null == receivedMinor ? _self.receivedMinor : receivedMinor // ignore: cast_nullable_to_non_nullable
as int,chargeCount: null == chargeCount ? _self.chargeCount : chargeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
