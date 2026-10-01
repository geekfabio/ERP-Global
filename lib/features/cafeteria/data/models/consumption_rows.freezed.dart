// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consumption_rows.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConsumptionRow {

 String get key; String? get label;/// Número de consumos (líquidos de estornos).
 int get purchaseCount; int get totalMinor;
/// Create a copy of ConsumptionRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsumptionRowCopyWith<ConsumptionRow> get copyWith => _$ConsumptionRowCopyWithImpl<ConsumptionRow>(this as ConsumptionRow, _$identity);

  /// Serializes this ConsumptionRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsumptionRow&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.purchaseCount, purchaseCount) || other.purchaseCount == purchaseCount)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,label,purchaseCount,totalMinor);

@override
String toString() {
  return 'ConsumptionRow(key: $key, label: $label, purchaseCount: $purchaseCount, totalMinor: $totalMinor)';
}


}

/// @nodoc
abstract mixin class $ConsumptionRowCopyWith<$Res>  {
  factory $ConsumptionRowCopyWith(ConsumptionRow value, $Res Function(ConsumptionRow) _then) = _$ConsumptionRowCopyWithImpl;
@useResult
$Res call({
 String key, String? label, int purchaseCount, int totalMinor
});




}
/// @nodoc
class _$ConsumptionRowCopyWithImpl<$Res>
    implements $ConsumptionRowCopyWith<$Res> {
  _$ConsumptionRowCopyWithImpl(this._self, this._then);

  final ConsumptionRow _self;
  final $Res Function(ConsumptionRow) _then;

/// Create a copy of ConsumptionRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? label = freezed,Object? purchaseCount = null,Object? totalMinor = null,}) {
  return _then(ConsumptionRow(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,purchaseCount: null == purchaseCount ? _self.purchaseCount : purchaseCount // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsumptionRow].
extension ConsumptionRowPatterns on ConsumptionRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsumptionRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsumptionRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsumptionRow value)  $default,){
final _that = this;
switch (_that) {
case _ConsumptionRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsumptionRow value)?  $default,){
final _that = this;
switch (_that) {
case _ConsumptionRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String? label,  int purchaseCount,  int totalMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsumptionRow() when $default != null:
return $default(_that.key,_that.label,_that.purchaseCount,_that.totalMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String? label,  int purchaseCount,  int totalMinor)  $default,) {final _that = this;
switch (_that) {
case _ConsumptionRow():
return $default(_that.key,_that.label,_that.purchaseCount,_that.totalMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String? label,  int purchaseCount,  int totalMinor)?  $default,) {final _that = this;
switch (_that) {
case _ConsumptionRow() when $default != null:
return $default(_that.key,_that.label,_that.purchaseCount,_that.totalMinor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsumptionRow implements ConsumptionRow {
  const _ConsumptionRow({required this.key, this.label, required this.purchaseCount, required this.totalMinor});
  factory _ConsumptionRow.fromJson(Map<String, dynamic> json) => _$ConsumptionRowFromJson(json);

@override final  String key;
@override final  String? label;
/// Número de consumos (líquidos de estornos).
@override final  int purchaseCount;
@override final  int totalMinor;

/// Create a copy of ConsumptionRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsumptionRowCopyWith<_ConsumptionRow> get copyWith => __$ConsumptionRowCopyWithImpl<_ConsumptionRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsumptionRowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsumptionRow&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.purchaseCount, purchaseCount) || other.purchaseCount == purchaseCount)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,label,purchaseCount,totalMinor);

@override
String toString() {
  return 'ConsumptionRow(key: $key, label: $label, purchaseCount: $purchaseCount, totalMinor: $totalMinor)';
}


}

/// @nodoc
abstract mixin class _$ConsumptionRowCopyWith<$Res> implements $ConsumptionRowCopyWith<$Res> {
  factory _$ConsumptionRowCopyWith(_ConsumptionRow value, $Res Function(_ConsumptionRow) _then) = __$ConsumptionRowCopyWithImpl;
@override @useResult
$Res call({
 String key, String? label, int purchaseCount, int totalMinor
});




}
/// @nodoc
class __$ConsumptionRowCopyWithImpl<$Res>
    implements _$ConsumptionRowCopyWith<$Res> {
  __$ConsumptionRowCopyWithImpl(this._self, this._then);

  final _ConsumptionRow _self;
  final $Res Function(_ConsumptionRow) _then;

/// Create a copy of ConsumptionRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? label = freezed,Object? purchaseCount = null,Object? totalMinor = null,}) {
  return _then(_ConsumptionRow(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,purchaseCount: null == purchaseCount ? _self.purchaseCount : purchaseCount // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PrepaidBalance {

 int get totalBalanceMinor; int get walletCount; int get blockedCount;
/// Create a copy of PrepaidBalance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrepaidBalanceCopyWith<PrepaidBalance> get copyWith => _$PrepaidBalanceCopyWithImpl<PrepaidBalance>(this as PrepaidBalance, _$identity);

  /// Serializes this PrepaidBalance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrepaidBalance&&(identical(other.totalBalanceMinor, totalBalanceMinor) || other.totalBalanceMinor == totalBalanceMinor)&&(identical(other.walletCount, walletCount) || other.walletCount == walletCount)&&(identical(other.blockedCount, blockedCount) || other.blockedCount == blockedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalBalanceMinor,walletCount,blockedCount);

@override
String toString() {
  return 'PrepaidBalance(totalBalanceMinor: $totalBalanceMinor, walletCount: $walletCount, blockedCount: $blockedCount)';
}


}

/// @nodoc
abstract mixin class $PrepaidBalanceCopyWith<$Res>  {
  factory $PrepaidBalanceCopyWith(PrepaidBalance value, $Res Function(PrepaidBalance) _then) = _$PrepaidBalanceCopyWithImpl;
@useResult
$Res call({
 int totalBalanceMinor, int walletCount, int blockedCount
});




}
/// @nodoc
class _$PrepaidBalanceCopyWithImpl<$Res>
    implements $PrepaidBalanceCopyWith<$Res> {
  _$PrepaidBalanceCopyWithImpl(this._self, this._then);

  final PrepaidBalance _self;
  final $Res Function(PrepaidBalance) _then;

/// Create a copy of PrepaidBalance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalBalanceMinor = null,Object? walletCount = null,Object? blockedCount = null,}) {
  return _then(PrepaidBalance(
totalBalanceMinor: null == totalBalanceMinor ? _self.totalBalanceMinor : totalBalanceMinor // ignore: cast_nullable_to_non_nullable
as int,walletCount: null == walletCount ? _self.walletCount : walletCount // ignore: cast_nullable_to_non_nullable
as int,blockedCount: null == blockedCount ? _self.blockedCount : blockedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PrepaidBalance].
extension PrepaidBalancePatterns on PrepaidBalance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrepaidBalance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrepaidBalance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrepaidBalance value)  $default,){
final _that = this;
switch (_that) {
case _PrepaidBalance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrepaidBalance value)?  $default,){
final _that = this;
switch (_that) {
case _PrepaidBalance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalBalanceMinor,  int walletCount,  int blockedCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrepaidBalance() when $default != null:
return $default(_that.totalBalanceMinor,_that.walletCount,_that.blockedCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalBalanceMinor,  int walletCount,  int blockedCount)  $default,) {final _that = this;
switch (_that) {
case _PrepaidBalance():
return $default(_that.totalBalanceMinor,_that.walletCount,_that.blockedCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalBalanceMinor,  int walletCount,  int blockedCount)?  $default,) {final _that = this;
switch (_that) {
case _PrepaidBalance() when $default != null:
return $default(_that.totalBalanceMinor,_that.walletCount,_that.blockedCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrepaidBalance implements PrepaidBalance {
  const _PrepaidBalance({required this.totalBalanceMinor, required this.walletCount, required this.blockedCount});
  factory _PrepaidBalance.fromJson(Map<String, dynamic> json) => _$PrepaidBalanceFromJson(json);

@override final  int totalBalanceMinor;
@override final  int walletCount;
@override final  int blockedCount;

/// Create a copy of PrepaidBalance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrepaidBalanceCopyWith<_PrepaidBalance> get copyWith => __$PrepaidBalanceCopyWithImpl<_PrepaidBalance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrepaidBalanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrepaidBalance&&(identical(other.totalBalanceMinor, totalBalanceMinor) || other.totalBalanceMinor == totalBalanceMinor)&&(identical(other.walletCount, walletCount) || other.walletCount == walletCount)&&(identical(other.blockedCount, blockedCount) || other.blockedCount == blockedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalBalanceMinor,walletCount,blockedCount);

@override
String toString() {
  return 'PrepaidBalance(totalBalanceMinor: $totalBalanceMinor, walletCount: $walletCount, blockedCount: $blockedCount)';
}


}

/// @nodoc
abstract mixin class _$PrepaidBalanceCopyWith<$Res> implements $PrepaidBalanceCopyWith<$Res> {
  factory _$PrepaidBalanceCopyWith(_PrepaidBalance value, $Res Function(_PrepaidBalance) _then) = __$PrepaidBalanceCopyWithImpl;
@override @useResult
$Res call({
 int totalBalanceMinor, int walletCount, int blockedCount
});




}
/// @nodoc
class __$PrepaidBalanceCopyWithImpl<$Res>
    implements _$PrepaidBalanceCopyWith<$Res> {
  __$PrepaidBalanceCopyWithImpl(this._self, this._then);

  final _PrepaidBalance _self;
  final $Res Function(_PrepaidBalance) _then;

/// Create a copy of PrepaidBalance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalBalanceMinor = null,Object? walletCount = null,Object? blockedCount = null,}) {
  return _then(_PrepaidBalance(
totalBalanceMinor: null == totalBalanceMinor ? _self.totalBalanceMinor : totalBalanceMinor // ignore: cast_nullable_to_non_nullable
as int,walletCount: null == walletCount ? _self.walletCount : walletCount // ignore: cast_nullable_to_non_nullable
as int,blockedCount: null == blockedCount ? _self.blockedCount : blockedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
