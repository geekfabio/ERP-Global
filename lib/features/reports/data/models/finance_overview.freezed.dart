// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'finance_overview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FinanceTotals {

 int get collected; int get expected; int get debt; int get defaultRate; int? get receivables; int? get payables; int? get result;
/// Create a copy of FinanceTotals
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinanceTotalsCopyWith<FinanceTotals> get copyWith => _$FinanceTotalsCopyWithImpl<FinanceTotals>(this as FinanceTotals, _$identity);

  /// Serializes this FinanceTotals to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinanceTotals&&(identical(other.collected, collected) || other.collected == collected)&&(identical(other.expected, expected) || other.expected == expected)&&(identical(other.debt, debt) || other.debt == debt)&&(identical(other.defaultRate, defaultRate) || other.defaultRate == defaultRate)&&(identical(other.receivables, receivables) || other.receivables == receivables)&&(identical(other.payables, payables) || other.payables == payables)&&(identical(other.result, result) || other.result == result));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,collected,expected,debt,defaultRate,receivables,payables,result);

@override
String toString() {
  return 'FinanceTotals(collected: $collected, expected: $expected, debt: $debt, defaultRate: $defaultRate, receivables: $receivables, payables: $payables, result: $result)';
}


}

/// @nodoc
abstract mixin class $FinanceTotalsCopyWith<$Res>  {
  factory $FinanceTotalsCopyWith(FinanceTotals value, $Res Function(FinanceTotals) _then) = _$FinanceTotalsCopyWithImpl;
@useResult
$Res call({
 int collected, int expected, int debt, int defaultRate, int? receivables, int? payables, int? result
});




}
/// @nodoc
class _$FinanceTotalsCopyWithImpl<$Res>
    implements $FinanceTotalsCopyWith<$Res> {
  _$FinanceTotalsCopyWithImpl(this._self, this._then);

  final FinanceTotals _self;
  final $Res Function(FinanceTotals) _then;

/// Create a copy of FinanceTotals
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? collected = null,Object? expected = null,Object? debt = null,Object? defaultRate = null,Object? receivables = freezed,Object? payables = freezed,Object? result = freezed,}) {
  return _then(FinanceTotals(
collected: null == collected ? _self.collected : collected // ignore: cast_nullable_to_non_nullable
as int,expected: null == expected ? _self.expected : expected // ignore: cast_nullable_to_non_nullable
as int,debt: null == debt ? _self.debt : debt // ignore: cast_nullable_to_non_nullable
as int,defaultRate: null == defaultRate ? _self.defaultRate : defaultRate // ignore: cast_nullable_to_non_nullable
as int,receivables: freezed == receivables ? _self.receivables : receivables // ignore: cast_nullable_to_non_nullable
as int?,payables: freezed == payables ? _self.payables : payables // ignore: cast_nullable_to_non_nullable
as int?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [FinanceTotals].
extension FinanceTotalsPatterns on FinanceTotals {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinanceTotals value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinanceTotals() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinanceTotals value)  $default,){
final _that = this;
switch (_that) {
case _FinanceTotals():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinanceTotals value)?  $default,){
final _that = this;
switch (_that) {
case _FinanceTotals() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int collected,  int expected,  int debt,  int defaultRate,  int? receivables,  int? payables,  int? result)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinanceTotals() when $default != null:
return $default(_that.collected,_that.expected,_that.debt,_that.defaultRate,_that.receivables,_that.payables,_that.result);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int collected,  int expected,  int debt,  int defaultRate,  int? receivables,  int? payables,  int? result)  $default,) {final _that = this;
switch (_that) {
case _FinanceTotals():
return $default(_that.collected,_that.expected,_that.debt,_that.defaultRate,_that.receivables,_that.payables,_that.result);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int collected,  int expected,  int debt,  int defaultRate,  int? receivables,  int? payables,  int? result)?  $default,) {final _that = this;
switch (_that) {
case _FinanceTotals() when $default != null:
return $default(_that.collected,_that.expected,_that.debt,_that.defaultRate,_that.receivables,_that.payables,_that.result);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinanceTotals implements FinanceTotals {
  const _FinanceTotals({required this.collected, required this.expected, required this.debt, required this.defaultRate, this.receivables, this.payables, this.result});
  factory _FinanceTotals.fromJson(Map<String, dynamic> json) => _$FinanceTotalsFromJson(json);

@override final  int collected;
@override final  int expected;
@override final  int debt;
@override final  int defaultRate;
@override final  int? receivables;
@override final  int? payables;
@override final  int? result;

/// Create a copy of FinanceTotals
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinanceTotalsCopyWith<_FinanceTotals> get copyWith => __$FinanceTotalsCopyWithImpl<_FinanceTotals>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinanceTotalsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinanceTotals&&(identical(other.collected, collected) || other.collected == collected)&&(identical(other.expected, expected) || other.expected == expected)&&(identical(other.debt, debt) || other.debt == debt)&&(identical(other.defaultRate, defaultRate) || other.defaultRate == defaultRate)&&(identical(other.receivables, receivables) || other.receivables == receivables)&&(identical(other.payables, payables) || other.payables == payables)&&(identical(other.result, result) || other.result == result));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,collected,expected,debt,defaultRate,receivables,payables,result);

@override
String toString() {
  return 'FinanceTotals(collected: $collected, expected: $expected, debt: $debt, defaultRate: $defaultRate, receivables: $receivables, payables: $payables, result: $result)';
}


}

/// @nodoc
abstract mixin class _$FinanceTotalsCopyWith<$Res> implements $FinanceTotalsCopyWith<$Res> {
  factory _$FinanceTotalsCopyWith(_FinanceTotals value, $Res Function(_FinanceTotals) _then) = __$FinanceTotalsCopyWithImpl;
@override @useResult
$Res call({
 int collected, int expected, int debt, int defaultRate, int? receivables, int? payables, int? result
});




}
/// @nodoc
class __$FinanceTotalsCopyWithImpl<$Res>
    implements _$FinanceTotalsCopyWith<$Res> {
  __$FinanceTotalsCopyWithImpl(this._self, this._then);

  final _FinanceTotals _self;
  final $Res Function(_FinanceTotals) _then;

/// Create a copy of FinanceTotals
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? collected = null,Object? expected = null,Object? debt = null,Object? defaultRate = null,Object? receivables = freezed,Object? payables = freezed,Object? result = freezed,}) {
  return _then(_FinanceTotals(
collected: null == collected ? _self.collected : collected // ignore: cast_nullable_to_non_nullable
as int,expected: null == expected ? _self.expected : expected // ignore: cast_nullable_to_non_nullable
as int,debt: null == debt ? _self.debt : debt // ignore: cast_nullable_to_non_nullable
as int,defaultRate: null == defaultRate ? _self.defaultRate : defaultRate // ignore: cast_nullable_to_non_nullable
as int,receivables: freezed == receivables ? _self.receivables : receivables // ignore: cast_nullable_to_non_nullable
as int?,payables: freezed == payables ? _self.payables : payables // ignore: cast_nullable_to_non_nullable
as int?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$FinanceMonthRow {

 String get month; String get label; int get expected; int get collected; int get debt;
/// Create a copy of FinanceMonthRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinanceMonthRowCopyWith<FinanceMonthRow> get copyWith => _$FinanceMonthRowCopyWithImpl<FinanceMonthRow>(this as FinanceMonthRow, _$identity);

  /// Serializes this FinanceMonthRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinanceMonthRow&&(identical(other.month, month) || other.month == month)&&(identical(other.label, label) || other.label == label)&&(identical(other.expected, expected) || other.expected == expected)&&(identical(other.collected, collected) || other.collected == collected)&&(identical(other.debt, debt) || other.debt == debt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,label,expected,collected,debt);

@override
String toString() {
  return 'FinanceMonthRow(month: $month, label: $label, expected: $expected, collected: $collected, debt: $debt)';
}


}

/// @nodoc
abstract mixin class $FinanceMonthRowCopyWith<$Res>  {
  factory $FinanceMonthRowCopyWith(FinanceMonthRow value, $Res Function(FinanceMonthRow) _then) = _$FinanceMonthRowCopyWithImpl;
@useResult
$Res call({
 String month, String label, int expected, int collected, int debt
});




}
/// @nodoc
class _$FinanceMonthRowCopyWithImpl<$Res>
    implements $FinanceMonthRowCopyWith<$Res> {
  _$FinanceMonthRowCopyWithImpl(this._self, this._then);

  final FinanceMonthRow _self;
  final $Res Function(FinanceMonthRow) _then;

/// Create a copy of FinanceMonthRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? label = null,Object? expected = null,Object? collected = null,Object? debt = null,}) {
  return _then(FinanceMonthRow(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,expected: null == expected ? _self.expected : expected // ignore: cast_nullable_to_non_nullable
as int,collected: null == collected ? _self.collected : collected // ignore: cast_nullable_to_non_nullable
as int,debt: null == debt ? _self.debt : debt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FinanceMonthRow].
extension FinanceMonthRowPatterns on FinanceMonthRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinanceMonthRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinanceMonthRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinanceMonthRow value)  $default,){
final _that = this;
switch (_that) {
case _FinanceMonthRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinanceMonthRow value)?  $default,){
final _that = this;
switch (_that) {
case _FinanceMonthRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String month,  String label,  int expected,  int collected,  int debt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinanceMonthRow() when $default != null:
return $default(_that.month,_that.label,_that.expected,_that.collected,_that.debt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String month,  String label,  int expected,  int collected,  int debt)  $default,) {final _that = this;
switch (_that) {
case _FinanceMonthRow():
return $default(_that.month,_that.label,_that.expected,_that.collected,_that.debt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String month,  String label,  int expected,  int collected,  int debt)?  $default,) {final _that = this;
switch (_that) {
case _FinanceMonthRow() when $default != null:
return $default(_that.month,_that.label,_that.expected,_that.collected,_that.debt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinanceMonthRow implements FinanceMonthRow {
  const _FinanceMonthRow({required this.month, required this.label, required this.expected, required this.collected, required this.debt});
  factory _FinanceMonthRow.fromJson(Map<String, dynamic> json) => _$FinanceMonthRowFromJson(json);

@override final  String month;
@override final  String label;
@override final  int expected;
@override final  int collected;
@override final  int debt;

/// Create a copy of FinanceMonthRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinanceMonthRowCopyWith<_FinanceMonthRow> get copyWith => __$FinanceMonthRowCopyWithImpl<_FinanceMonthRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinanceMonthRowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinanceMonthRow&&(identical(other.month, month) || other.month == month)&&(identical(other.label, label) || other.label == label)&&(identical(other.expected, expected) || other.expected == expected)&&(identical(other.collected, collected) || other.collected == collected)&&(identical(other.debt, debt) || other.debt == debt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,label,expected,collected,debt);

@override
String toString() {
  return 'FinanceMonthRow(month: $month, label: $label, expected: $expected, collected: $collected, debt: $debt)';
}


}

/// @nodoc
abstract mixin class _$FinanceMonthRowCopyWith<$Res> implements $FinanceMonthRowCopyWith<$Res> {
  factory _$FinanceMonthRowCopyWith(_FinanceMonthRow value, $Res Function(_FinanceMonthRow) _then) = __$FinanceMonthRowCopyWithImpl;
@override @useResult
$Res call({
 String month, String label, int expected, int collected, int debt
});




}
/// @nodoc
class __$FinanceMonthRowCopyWithImpl<$Res>
    implements _$FinanceMonthRowCopyWith<$Res> {
  __$FinanceMonthRowCopyWithImpl(this._self, this._then);

  final _FinanceMonthRow _self;
  final $Res Function(_FinanceMonthRow) _then;

/// Create a copy of FinanceMonthRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? label = null,Object? expected = null,Object? collected = null,Object? debt = null,}) {
  return _then(_FinanceMonthRow(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,expected: null == expected ? _self.expected : expected // ignore: cast_nullable_to_non_nullable
as int,collected: null == collected ? _self.collected : collected // ignore: cast_nullable_to_non_nullable
as int,debt: null == debt ? _self.debt : debt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$FinanceOverview {

 FinanceTotals get totals; List<FinanceMonthRow> get rows; FinanceTotals? get previous;
/// Create a copy of FinanceOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinanceOverviewCopyWith<FinanceOverview> get copyWith => _$FinanceOverviewCopyWithImpl<FinanceOverview>(this as FinanceOverview, _$identity);

  /// Serializes this FinanceOverview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinanceOverview&&(identical(other.totals, totals) || other.totals == totals)&&const DeepCollectionEquality().equals(other.rows, rows)&&(identical(other.previous, previous) || other.previous == previous));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totals,const DeepCollectionEquality().hash(rows),previous);

@override
String toString() {
  return 'FinanceOverview(totals: $totals, rows: $rows, previous: $previous)';
}


}

/// @nodoc
abstract mixin class $FinanceOverviewCopyWith<$Res>  {
  factory $FinanceOverviewCopyWith(FinanceOverview value, $Res Function(FinanceOverview) _then) = _$FinanceOverviewCopyWithImpl;
@useResult
$Res call({
 FinanceTotals totals, List<FinanceMonthRow> rows, FinanceTotals? previous
});


$FinanceTotalsCopyWith<$Res> get totals;$FinanceTotalsCopyWith<$Res>? get previous;

}
/// @nodoc
class _$FinanceOverviewCopyWithImpl<$Res>
    implements $FinanceOverviewCopyWith<$Res> {
  _$FinanceOverviewCopyWithImpl(this._self, this._then);

  final FinanceOverview _self;
  final $Res Function(FinanceOverview) _then;

/// Create a copy of FinanceOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totals = null,Object? rows = null,Object? previous = freezed,}) {
  return _then(FinanceOverview(
totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as FinanceTotals,rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<FinanceMonthRow>,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as FinanceTotals?,
  ));
}
/// Create a copy of FinanceOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FinanceTotalsCopyWith<$Res> get totals {
  
  return $FinanceTotalsCopyWith<$Res>(_self.totals, (value) {
    return _then(_self.copyWith(totals: value));
  });
}/// Create a copy of FinanceOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FinanceTotalsCopyWith<$Res>? get previous {
    if (_self.previous == null) {
    return null;
  }

  return $FinanceTotalsCopyWith<$Res>(_self.previous!, (value) {
    return _then(_self.copyWith(previous: value));
  });
}
}


/// Adds pattern-matching-related methods to [FinanceOverview].
extension FinanceOverviewPatterns on FinanceOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinanceOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinanceOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinanceOverview value)  $default,){
final _that = this;
switch (_that) {
case _FinanceOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinanceOverview value)?  $default,){
final _that = this;
switch (_that) {
case _FinanceOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FinanceTotals totals,  List<FinanceMonthRow> rows,  FinanceTotals? previous)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinanceOverview() when $default != null:
return $default(_that.totals,_that.rows,_that.previous);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FinanceTotals totals,  List<FinanceMonthRow> rows,  FinanceTotals? previous)  $default,) {final _that = this;
switch (_that) {
case _FinanceOverview():
return $default(_that.totals,_that.rows,_that.previous);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FinanceTotals totals,  List<FinanceMonthRow> rows,  FinanceTotals? previous)?  $default,) {final _that = this;
switch (_that) {
case _FinanceOverview() when $default != null:
return $default(_that.totals,_that.rows,_that.previous);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinanceOverview implements FinanceOverview {
  const _FinanceOverview({required this.totals, required  List<FinanceMonthRow> rows, this.previous}): _rows = rows;
  factory _FinanceOverview.fromJson(Map<String, dynamic> json) => _$FinanceOverviewFromJson(json);

@override final  FinanceTotals totals;
 final  List<FinanceMonthRow> _rows;
@override List<FinanceMonthRow> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}

@override final  FinanceTotals? previous;

/// Create a copy of FinanceOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinanceOverviewCopyWith<_FinanceOverview> get copyWith => __$FinanceOverviewCopyWithImpl<_FinanceOverview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinanceOverviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinanceOverview&&(identical(other.totals, totals) || other.totals == totals)&&const DeepCollectionEquality().equals(other._rows, _rows)&&(identical(other.previous, previous) || other.previous == previous));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totals,const DeepCollectionEquality().hash(_rows),previous);

@override
String toString() {
  return 'FinanceOverview(totals: $totals, rows: $rows, previous: $previous)';
}


}

/// @nodoc
abstract mixin class _$FinanceOverviewCopyWith<$Res> implements $FinanceOverviewCopyWith<$Res> {
  factory _$FinanceOverviewCopyWith(_FinanceOverview value, $Res Function(_FinanceOverview) _then) = __$FinanceOverviewCopyWithImpl;
@override @useResult
$Res call({
 FinanceTotals totals, List<FinanceMonthRow> rows, FinanceTotals? previous
});


@override $FinanceTotalsCopyWith<$Res> get totals;@override $FinanceTotalsCopyWith<$Res>? get previous;

}
/// @nodoc
class __$FinanceOverviewCopyWithImpl<$Res>
    implements _$FinanceOverviewCopyWith<$Res> {
  __$FinanceOverviewCopyWithImpl(this._self, this._then);

  final _FinanceOverview _self;
  final $Res Function(_FinanceOverview) _then;

/// Create a copy of FinanceOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totals = null,Object? rows = null,Object? previous = freezed,}) {
  return _then(_FinanceOverview(
totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as FinanceTotals,rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<FinanceMonthRow>,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as FinanceTotals?,
  ));
}

/// Create a copy of FinanceOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FinanceTotalsCopyWith<$Res> get totals {
  
  return $FinanceTotalsCopyWith<$Res>(_self.totals, (value) {
    return _then(_self.copyWith(totals: value));
  });
}/// Create a copy of FinanceOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FinanceTotalsCopyWith<$Res>? get previous {
    if (_self.previous == null) {
    return null;
  }

  return $FinanceTotalsCopyWith<$Res>(_self.previous!, (value) {
    return _then(_self.copyWith(previous: value));
  });
}
}

// dart format on
