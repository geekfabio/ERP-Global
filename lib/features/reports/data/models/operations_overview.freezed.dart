// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'operations_overview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LabeledCount {

 String get label; int get count;
/// Create a copy of LabeledCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LabeledCountCopyWith<LabeledCount> get copyWith => _$LabeledCountCopyWithImpl<LabeledCount>(this as LabeledCount, _$identity);

  /// Serializes this LabeledCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LabeledCount&&(identical(other.label, label) || other.label == label)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,count);

@override
String toString() {
  return 'LabeledCount(label: $label, count: $count)';
}


}

/// @nodoc
abstract mixin class $LabeledCountCopyWith<$Res>  {
  factory $LabeledCountCopyWith(LabeledCount value, $Res Function(LabeledCount) _then) = _$LabeledCountCopyWithImpl;
@useResult
$Res call({
 String label, int count
});




}
/// @nodoc
class _$LabeledCountCopyWithImpl<$Res>
    implements $LabeledCountCopyWith<$Res> {
  _$LabeledCountCopyWithImpl(this._self, this._then);

  final LabeledCount _self;
  final $Res Function(LabeledCount) _then;

/// Create a copy of LabeledCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? count = null,}) {
  return _then(LabeledCount(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LabeledCount].
extension LabeledCountPatterns on LabeledCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LabeledCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LabeledCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LabeledCount value)  $default,){
final _that = this;
switch (_that) {
case _LabeledCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LabeledCount value)?  $default,){
final _that = this;
switch (_that) {
case _LabeledCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LabeledCount() when $default != null:
return $default(_that.label,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  int count)  $default,) {final _that = this;
switch (_that) {
case _LabeledCount():
return $default(_that.label,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  int count)?  $default,) {final _that = this;
switch (_that) {
case _LabeledCount() when $default != null:
return $default(_that.label,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LabeledCount implements LabeledCount {
  const _LabeledCount({required this.label, required this.count});
  factory _LabeledCount.fromJson(Map<String, dynamic> json) => _$LabeledCountFromJson(json);

@override final  String label;
@override final  int count;

/// Create a copy of LabeledCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LabeledCountCopyWith<_LabeledCount> get copyWith => __$LabeledCountCopyWithImpl<_LabeledCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LabeledCountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LabeledCount&&(identical(other.label, label) || other.label == label)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,count);

@override
String toString() {
  return 'LabeledCount(label: $label, count: $count)';
}


}

/// @nodoc
abstract mixin class _$LabeledCountCopyWith<$Res> implements $LabeledCountCopyWith<$Res> {
  factory _$LabeledCountCopyWith(_LabeledCount value, $Res Function(_LabeledCount) _then) = __$LabeledCountCopyWithImpl;
@override @useResult
$Res call({
 String label, int count
});




}
/// @nodoc
class __$LabeledCountCopyWithImpl<$Res>
    implements _$LabeledCountCopyWith<$Res> {
  __$LabeledCountCopyWithImpl(this._self, this._then);

  final _LabeledCount _self;
  final $Res Function(_LabeledCount) _then;

/// Create a copy of LabeledCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? count = null,}) {
  return _then(_LabeledCount(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CafeteriaOverview {

 int get meals; int get revenue; int get prepaidBalance; int get lowBalanceCards; List<LabeledCount> get byMeal;
/// Create a copy of CafeteriaOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CafeteriaOverviewCopyWith<CafeteriaOverview> get copyWith => _$CafeteriaOverviewCopyWithImpl<CafeteriaOverview>(this as CafeteriaOverview, _$identity);

  /// Serializes this CafeteriaOverview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CafeteriaOverview&&(identical(other.meals, meals) || other.meals == meals)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.prepaidBalance, prepaidBalance) || other.prepaidBalance == prepaidBalance)&&(identical(other.lowBalanceCards, lowBalanceCards) || other.lowBalanceCards == lowBalanceCards)&&const DeepCollectionEquality().equals(other.byMeal, byMeal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,meals,revenue,prepaidBalance,lowBalanceCards,const DeepCollectionEquality().hash(byMeal));

@override
String toString() {
  return 'CafeteriaOverview(meals: $meals, revenue: $revenue, prepaidBalance: $prepaidBalance, lowBalanceCards: $lowBalanceCards, byMeal: $byMeal)';
}


}

/// @nodoc
abstract mixin class $CafeteriaOverviewCopyWith<$Res>  {
  factory $CafeteriaOverviewCopyWith(CafeteriaOverview value, $Res Function(CafeteriaOverview) _then) = _$CafeteriaOverviewCopyWithImpl;
@useResult
$Res call({
 int meals, int revenue, int prepaidBalance, int lowBalanceCards, List<LabeledCount> byMeal
});




}
/// @nodoc
class _$CafeteriaOverviewCopyWithImpl<$Res>
    implements $CafeteriaOverviewCopyWith<$Res> {
  _$CafeteriaOverviewCopyWithImpl(this._self, this._then);

  final CafeteriaOverview _self;
  final $Res Function(CafeteriaOverview) _then;

/// Create a copy of CafeteriaOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meals = null,Object? revenue = null,Object? prepaidBalance = null,Object? lowBalanceCards = null,Object? byMeal = null,}) {
  return _then(CafeteriaOverview(
meals: null == meals ? _self.meals : meals // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,prepaidBalance: null == prepaidBalance ? _self.prepaidBalance : prepaidBalance // ignore: cast_nullable_to_non_nullable
as int,lowBalanceCards: null == lowBalanceCards ? _self.lowBalanceCards : lowBalanceCards // ignore: cast_nullable_to_non_nullable
as int,byMeal: null == byMeal ? _self.byMeal : byMeal // ignore: cast_nullable_to_non_nullable
as List<LabeledCount>,
  ));
}

}


/// Adds pattern-matching-related methods to [CafeteriaOverview].
extension CafeteriaOverviewPatterns on CafeteriaOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CafeteriaOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CafeteriaOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CafeteriaOverview value)  $default,){
final _that = this;
switch (_that) {
case _CafeteriaOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CafeteriaOverview value)?  $default,){
final _that = this;
switch (_that) {
case _CafeteriaOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int meals,  int revenue,  int prepaidBalance,  int lowBalanceCards,  List<LabeledCount> byMeal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CafeteriaOverview() when $default != null:
return $default(_that.meals,_that.revenue,_that.prepaidBalance,_that.lowBalanceCards,_that.byMeal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int meals,  int revenue,  int prepaidBalance,  int lowBalanceCards,  List<LabeledCount> byMeal)  $default,) {final _that = this;
switch (_that) {
case _CafeteriaOverview():
return $default(_that.meals,_that.revenue,_that.prepaidBalance,_that.lowBalanceCards,_that.byMeal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int meals,  int revenue,  int prepaidBalance,  int lowBalanceCards,  List<LabeledCount> byMeal)?  $default,) {final _that = this;
switch (_that) {
case _CafeteriaOverview() when $default != null:
return $default(_that.meals,_that.revenue,_that.prepaidBalance,_that.lowBalanceCards,_that.byMeal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CafeteriaOverview implements CafeteriaOverview {
  const _CafeteriaOverview({required this.meals, required this.revenue, required this.prepaidBalance, required this.lowBalanceCards, required  List<LabeledCount> byMeal}): _byMeal = byMeal;
  factory _CafeteriaOverview.fromJson(Map<String, dynamic> json) => _$CafeteriaOverviewFromJson(json);

@override final  int meals;
@override final  int revenue;
@override final  int prepaidBalance;
@override final  int lowBalanceCards;
 final  List<LabeledCount> _byMeal;
@override List<LabeledCount> get byMeal {
  if (_byMeal is EqualUnmodifiableListView) return _byMeal;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_byMeal);
}


/// Create a copy of CafeteriaOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CafeteriaOverviewCopyWith<_CafeteriaOverview> get copyWith => __$CafeteriaOverviewCopyWithImpl<_CafeteriaOverview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CafeteriaOverviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CafeteriaOverview&&(identical(other.meals, meals) || other.meals == meals)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.prepaidBalance, prepaidBalance) || other.prepaidBalance == prepaidBalance)&&(identical(other.lowBalanceCards, lowBalanceCards) || other.lowBalanceCards == lowBalanceCards)&&const DeepCollectionEquality().equals(other._byMeal, _byMeal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,meals,revenue,prepaidBalance,lowBalanceCards,const DeepCollectionEquality().hash(_byMeal));

@override
String toString() {
  return 'CafeteriaOverview(meals: $meals, revenue: $revenue, prepaidBalance: $prepaidBalance, lowBalanceCards: $lowBalanceCards, byMeal: $byMeal)';
}


}

/// @nodoc
abstract mixin class _$CafeteriaOverviewCopyWith<$Res> implements $CafeteriaOverviewCopyWith<$Res> {
  factory _$CafeteriaOverviewCopyWith(_CafeteriaOverview value, $Res Function(_CafeteriaOverview) _then) = __$CafeteriaOverviewCopyWithImpl;
@override @useResult
$Res call({
 int meals, int revenue, int prepaidBalance, int lowBalanceCards, List<LabeledCount> byMeal
});




}
/// @nodoc
class __$CafeteriaOverviewCopyWithImpl<$Res>
    implements _$CafeteriaOverviewCopyWith<$Res> {
  __$CafeteriaOverviewCopyWithImpl(this._self, this._then);

  final _CafeteriaOverview _self;
  final $Res Function(_CafeteriaOverview) _then;

/// Create a copy of CafeteriaOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meals = null,Object? revenue = null,Object? prepaidBalance = null,Object? lowBalanceCards = null,Object? byMeal = null,}) {
  return _then(_CafeteriaOverview(
meals: null == meals ? _self.meals : meals // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,prepaidBalance: null == prepaidBalance ? _self.prepaidBalance : prepaidBalance // ignore: cast_nullable_to_non_nullable
as int,lowBalanceCards: null == lowBalanceCards ? _self.lowBalanceCards : lowBalanceCards // ignore: cast_nullable_to_non_nullable
as int,byMeal: null == byMeal ? _self._byMeal : byMeal // ignore: cast_nullable_to_non_nullable
as List<LabeledCount>,
  ));
}


}


/// @nodoc
mixin _$HourlyAccess {

 int get hour; int get entries; int get exits;
/// Create a copy of HourlyAccess
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HourlyAccessCopyWith<HourlyAccess> get copyWith => _$HourlyAccessCopyWithImpl<HourlyAccess>(this as HourlyAccess, _$identity);

  /// Serializes this HourlyAccess to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HourlyAccess&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.entries, entries) || other.entries == entries)&&(identical(other.exits, exits) || other.exits == exits));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hour,entries,exits);

@override
String toString() {
  return 'HourlyAccess(hour: $hour, entries: $entries, exits: $exits)';
}


}

/// @nodoc
abstract mixin class $HourlyAccessCopyWith<$Res>  {
  factory $HourlyAccessCopyWith(HourlyAccess value, $Res Function(HourlyAccess) _then) = _$HourlyAccessCopyWithImpl;
@useResult
$Res call({
 int hour, int entries, int exits
});




}
/// @nodoc
class _$HourlyAccessCopyWithImpl<$Res>
    implements $HourlyAccessCopyWith<$Res> {
  _$HourlyAccessCopyWithImpl(this._self, this._then);

  final HourlyAccess _self;
  final $Res Function(HourlyAccess) _then;

/// Create a copy of HourlyAccess
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hour = null,Object? entries = null,Object? exits = null,}) {
  return _then(HourlyAccess(
hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as int,exits: null == exits ? _self.exits : exits // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HourlyAccess].
extension HourlyAccessPatterns on HourlyAccess {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HourlyAccess value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HourlyAccess() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HourlyAccess value)  $default,){
final _that = this;
switch (_that) {
case _HourlyAccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HourlyAccess value)?  $default,){
final _that = this;
switch (_that) {
case _HourlyAccess() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int hour,  int entries,  int exits)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HourlyAccess() when $default != null:
return $default(_that.hour,_that.entries,_that.exits);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int hour,  int entries,  int exits)  $default,) {final _that = this;
switch (_that) {
case _HourlyAccess():
return $default(_that.hour,_that.entries,_that.exits);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int hour,  int entries,  int exits)?  $default,) {final _that = this;
switch (_that) {
case _HourlyAccess() when $default != null:
return $default(_that.hour,_that.entries,_that.exits);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HourlyAccess implements HourlyAccess {
  const _HourlyAccess({required this.hour, required this.entries, required this.exits});
  factory _HourlyAccess.fromJson(Map<String, dynamic> json) => _$HourlyAccessFromJson(json);

@override final  int hour;
@override final  int entries;
@override final  int exits;

/// Create a copy of HourlyAccess
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HourlyAccessCopyWith<_HourlyAccess> get copyWith => __$HourlyAccessCopyWithImpl<_HourlyAccess>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HourlyAccessToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HourlyAccess&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.entries, entries) || other.entries == entries)&&(identical(other.exits, exits) || other.exits == exits));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hour,entries,exits);

@override
String toString() {
  return 'HourlyAccess(hour: $hour, entries: $entries, exits: $exits)';
}


}

/// @nodoc
abstract mixin class _$HourlyAccessCopyWith<$Res> implements $HourlyAccessCopyWith<$Res> {
  factory _$HourlyAccessCopyWith(_HourlyAccess value, $Res Function(_HourlyAccess) _then) = __$HourlyAccessCopyWithImpl;
@override @useResult
$Res call({
 int hour, int entries, int exits
});




}
/// @nodoc
class __$HourlyAccessCopyWithImpl<$Res>
    implements _$HourlyAccessCopyWith<$Res> {
  __$HourlyAccessCopyWithImpl(this._self, this._then);

  final _HourlyAccess _self;
  final $Res Function(_HourlyAccess) _then;

/// Create a copy of HourlyAccess
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hour = null,Object? entries = null,Object? exits = null,}) {
  return _then(_HourlyAccess(
hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as int,exits: null == exits ? _self.exits : exits // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AccessOverview {

 int get entries; int get exits; int get denied; List<HourlyAccess> get byHour;
/// Create a copy of AccessOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccessOverviewCopyWith<AccessOverview> get copyWith => _$AccessOverviewCopyWithImpl<AccessOverview>(this as AccessOverview, _$identity);

  /// Serializes this AccessOverview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccessOverview&&(identical(other.entries, entries) || other.entries == entries)&&(identical(other.exits, exits) || other.exits == exits)&&(identical(other.denied, denied) || other.denied == denied)&&const DeepCollectionEquality().equals(other.byHour, byHour));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entries,exits,denied,const DeepCollectionEquality().hash(byHour));

@override
String toString() {
  return 'AccessOverview(entries: $entries, exits: $exits, denied: $denied, byHour: $byHour)';
}


}

/// @nodoc
abstract mixin class $AccessOverviewCopyWith<$Res>  {
  factory $AccessOverviewCopyWith(AccessOverview value, $Res Function(AccessOverview) _then) = _$AccessOverviewCopyWithImpl;
@useResult
$Res call({
 int entries, int exits, int denied, List<HourlyAccess> byHour
});




}
/// @nodoc
class _$AccessOverviewCopyWithImpl<$Res>
    implements $AccessOverviewCopyWith<$Res> {
  _$AccessOverviewCopyWithImpl(this._self, this._then);

  final AccessOverview _self;
  final $Res Function(AccessOverview) _then;

/// Create a copy of AccessOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,Object? exits = null,Object? denied = null,Object? byHour = null,}) {
  return _then(AccessOverview(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as int,exits: null == exits ? _self.exits : exits // ignore: cast_nullable_to_non_nullable
as int,denied: null == denied ? _self.denied : denied // ignore: cast_nullable_to_non_nullable
as int,byHour: null == byHour ? _self.byHour : byHour // ignore: cast_nullable_to_non_nullable
as List<HourlyAccess>,
  ));
}

}


/// Adds pattern-matching-related methods to [AccessOverview].
extension AccessOverviewPatterns on AccessOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccessOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccessOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccessOverview value)  $default,){
final _that = this;
switch (_that) {
case _AccessOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccessOverview value)?  $default,){
final _that = this;
switch (_that) {
case _AccessOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int entries,  int exits,  int denied,  List<HourlyAccess> byHour)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccessOverview() when $default != null:
return $default(_that.entries,_that.exits,_that.denied,_that.byHour);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int entries,  int exits,  int denied,  List<HourlyAccess> byHour)  $default,) {final _that = this;
switch (_that) {
case _AccessOverview():
return $default(_that.entries,_that.exits,_that.denied,_that.byHour);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int entries,  int exits,  int denied,  List<HourlyAccess> byHour)?  $default,) {final _that = this;
switch (_that) {
case _AccessOverview() when $default != null:
return $default(_that.entries,_that.exits,_that.denied,_that.byHour);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccessOverview implements AccessOverview {
  const _AccessOverview({required this.entries, required this.exits, required this.denied, required  List<HourlyAccess> byHour}): _byHour = byHour;
  factory _AccessOverview.fromJson(Map<String, dynamic> json) => _$AccessOverviewFromJson(json);

@override final  int entries;
@override final  int exits;
@override final  int denied;
 final  List<HourlyAccess> _byHour;
@override List<HourlyAccess> get byHour {
  if (_byHour is EqualUnmodifiableListView) return _byHour;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_byHour);
}


/// Create a copy of AccessOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccessOverviewCopyWith<_AccessOverview> get copyWith => __$AccessOverviewCopyWithImpl<_AccessOverview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccessOverviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccessOverview&&(identical(other.entries, entries) || other.entries == entries)&&(identical(other.exits, exits) || other.exits == exits)&&(identical(other.denied, denied) || other.denied == denied)&&const DeepCollectionEquality().equals(other._byHour, _byHour));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entries,exits,denied,const DeepCollectionEquality().hash(_byHour));

@override
String toString() {
  return 'AccessOverview(entries: $entries, exits: $exits, denied: $denied, byHour: $byHour)';
}


}

/// @nodoc
abstract mixin class _$AccessOverviewCopyWith<$Res> implements $AccessOverviewCopyWith<$Res> {
  factory _$AccessOverviewCopyWith(_AccessOverview value, $Res Function(_AccessOverview) _then) = __$AccessOverviewCopyWithImpl;
@override @useResult
$Res call({
 int entries, int exits, int denied, List<HourlyAccess> byHour
});




}
/// @nodoc
class __$AccessOverviewCopyWithImpl<$Res>
    implements _$AccessOverviewCopyWith<$Res> {
  __$AccessOverviewCopyWithImpl(this._self, this._then);

  final _AccessOverview _self;
  final $Res Function(_AccessOverview) _then;

/// Create a copy of AccessOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,Object? exits = null,Object? denied = null,Object? byHour = null,}) {
  return _then(_AccessOverview(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as int,exits: null == exits ? _self.exits : exits // ignore: cast_nullable_to_non_nullable
as int,denied: null == denied ? _self.denied : denied // ignore: cast_nullable_to_non_nullable
as int,byHour: null == byHour ? _self._byHour : byHour // ignore: cast_nullable_to_non_nullable
as List<HourlyAccess>,
  ));
}


}


/// @nodoc
mixin _$HrOverview {

 int get activeStaff; int get onLeave; int get contractsExpiring; int get teachersWithoutContract; List<LabeledCount> get byRole;
/// Create a copy of HrOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HrOverviewCopyWith<HrOverview> get copyWith => _$HrOverviewCopyWithImpl<HrOverview>(this as HrOverview, _$identity);

  /// Serializes this HrOverview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HrOverview&&(identical(other.activeStaff, activeStaff) || other.activeStaff == activeStaff)&&(identical(other.onLeave, onLeave) || other.onLeave == onLeave)&&(identical(other.contractsExpiring, contractsExpiring) || other.contractsExpiring == contractsExpiring)&&(identical(other.teachersWithoutContract, teachersWithoutContract) || other.teachersWithoutContract == teachersWithoutContract)&&const DeepCollectionEquality().equals(other.byRole, byRole));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activeStaff,onLeave,contractsExpiring,teachersWithoutContract,const DeepCollectionEquality().hash(byRole));

@override
String toString() {
  return 'HrOverview(activeStaff: $activeStaff, onLeave: $onLeave, contractsExpiring: $contractsExpiring, teachersWithoutContract: $teachersWithoutContract, byRole: $byRole)';
}


}

/// @nodoc
abstract mixin class $HrOverviewCopyWith<$Res>  {
  factory $HrOverviewCopyWith(HrOverview value, $Res Function(HrOverview) _then) = _$HrOverviewCopyWithImpl;
@useResult
$Res call({
 int activeStaff, int onLeave, int contractsExpiring, int teachersWithoutContract, List<LabeledCount> byRole
});




}
/// @nodoc
class _$HrOverviewCopyWithImpl<$Res>
    implements $HrOverviewCopyWith<$Res> {
  _$HrOverviewCopyWithImpl(this._self, this._then);

  final HrOverview _self;
  final $Res Function(HrOverview) _then;

/// Create a copy of HrOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeStaff = null,Object? onLeave = null,Object? contractsExpiring = null,Object? teachersWithoutContract = null,Object? byRole = null,}) {
  return _then(HrOverview(
activeStaff: null == activeStaff ? _self.activeStaff : activeStaff // ignore: cast_nullable_to_non_nullable
as int,onLeave: null == onLeave ? _self.onLeave : onLeave // ignore: cast_nullable_to_non_nullable
as int,contractsExpiring: null == contractsExpiring ? _self.contractsExpiring : contractsExpiring // ignore: cast_nullable_to_non_nullable
as int,teachersWithoutContract: null == teachersWithoutContract ? _self.teachersWithoutContract : teachersWithoutContract // ignore: cast_nullable_to_non_nullable
as int,byRole: null == byRole ? _self.byRole : byRole // ignore: cast_nullable_to_non_nullable
as List<LabeledCount>,
  ));
}

}


/// Adds pattern-matching-related methods to [HrOverview].
extension HrOverviewPatterns on HrOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HrOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HrOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HrOverview value)  $default,){
final _that = this;
switch (_that) {
case _HrOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HrOverview value)?  $default,){
final _that = this;
switch (_that) {
case _HrOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int activeStaff,  int onLeave,  int contractsExpiring,  int teachersWithoutContract,  List<LabeledCount> byRole)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HrOverview() when $default != null:
return $default(_that.activeStaff,_that.onLeave,_that.contractsExpiring,_that.teachersWithoutContract,_that.byRole);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int activeStaff,  int onLeave,  int contractsExpiring,  int teachersWithoutContract,  List<LabeledCount> byRole)  $default,) {final _that = this;
switch (_that) {
case _HrOverview():
return $default(_that.activeStaff,_that.onLeave,_that.contractsExpiring,_that.teachersWithoutContract,_that.byRole);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int activeStaff,  int onLeave,  int contractsExpiring,  int teachersWithoutContract,  List<LabeledCount> byRole)?  $default,) {final _that = this;
switch (_that) {
case _HrOverview() when $default != null:
return $default(_that.activeStaff,_that.onLeave,_that.contractsExpiring,_that.teachersWithoutContract,_that.byRole);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HrOverview implements HrOverview {
  const _HrOverview({required this.activeStaff, required this.onLeave, required this.contractsExpiring, required this.teachersWithoutContract, required  List<LabeledCount> byRole}): _byRole = byRole;
  factory _HrOverview.fromJson(Map<String, dynamic> json) => _$HrOverviewFromJson(json);

@override final  int activeStaff;
@override final  int onLeave;
@override final  int contractsExpiring;
@override final  int teachersWithoutContract;
 final  List<LabeledCount> _byRole;
@override List<LabeledCount> get byRole {
  if (_byRole is EqualUnmodifiableListView) return _byRole;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_byRole);
}


/// Create a copy of HrOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HrOverviewCopyWith<_HrOverview> get copyWith => __$HrOverviewCopyWithImpl<_HrOverview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HrOverviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HrOverview&&(identical(other.activeStaff, activeStaff) || other.activeStaff == activeStaff)&&(identical(other.onLeave, onLeave) || other.onLeave == onLeave)&&(identical(other.contractsExpiring, contractsExpiring) || other.contractsExpiring == contractsExpiring)&&(identical(other.teachersWithoutContract, teachersWithoutContract) || other.teachersWithoutContract == teachersWithoutContract)&&const DeepCollectionEquality().equals(other._byRole, _byRole));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activeStaff,onLeave,contractsExpiring,teachersWithoutContract,const DeepCollectionEquality().hash(_byRole));

@override
String toString() {
  return 'HrOverview(activeStaff: $activeStaff, onLeave: $onLeave, contractsExpiring: $contractsExpiring, teachersWithoutContract: $teachersWithoutContract, byRole: $byRole)';
}


}

/// @nodoc
abstract mixin class _$HrOverviewCopyWith<$Res> implements $HrOverviewCopyWith<$Res> {
  factory _$HrOverviewCopyWith(_HrOverview value, $Res Function(_HrOverview) _then) = __$HrOverviewCopyWithImpl;
@override @useResult
$Res call({
 int activeStaff, int onLeave, int contractsExpiring, int teachersWithoutContract, List<LabeledCount> byRole
});




}
/// @nodoc
class __$HrOverviewCopyWithImpl<$Res>
    implements _$HrOverviewCopyWith<$Res> {
  __$HrOverviewCopyWithImpl(this._self, this._then);

  final _HrOverview _self;
  final $Res Function(_HrOverview) _then;

/// Create a copy of HrOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeStaff = null,Object? onLeave = null,Object? contractsExpiring = null,Object? teachersWithoutContract = null,Object? byRole = null,}) {
  return _then(_HrOverview(
activeStaff: null == activeStaff ? _self.activeStaff : activeStaff // ignore: cast_nullable_to_non_nullable
as int,onLeave: null == onLeave ? _self.onLeave : onLeave // ignore: cast_nullable_to_non_nullable
as int,contractsExpiring: null == contractsExpiring ? _self.contractsExpiring : contractsExpiring // ignore: cast_nullable_to_non_nullable
as int,teachersWithoutContract: null == teachersWithoutContract ? _self.teachersWithoutContract : teachersWithoutContract // ignore: cast_nullable_to_non_nullable
as int,byRole: null == byRole ? _self._byRole : byRole // ignore: cast_nullable_to_non_nullable
as List<LabeledCount>,
  ));
}


}


/// @nodoc
mixin _$SecretariatOverview {

 int get totalPending; List<LabeledCount> get items;
/// Create a copy of SecretariatOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SecretariatOverviewCopyWith<SecretariatOverview> get copyWith => _$SecretariatOverviewCopyWithImpl<SecretariatOverview>(this as SecretariatOverview, _$identity);

  /// Serializes this SecretariatOverview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SecretariatOverview&&(identical(other.totalPending, totalPending) || other.totalPending == totalPending)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalPending,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'SecretariatOverview(totalPending: $totalPending, items: $items)';
}


}

/// @nodoc
abstract mixin class $SecretariatOverviewCopyWith<$Res>  {
  factory $SecretariatOverviewCopyWith(SecretariatOverview value, $Res Function(SecretariatOverview) _then) = _$SecretariatOverviewCopyWithImpl;
@useResult
$Res call({
 int totalPending, List<LabeledCount> items
});




}
/// @nodoc
class _$SecretariatOverviewCopyWithImpl<$Res>
    implements $SecretariatOverviewCopyWith<$Res> {
  _$SecretariatOverviewCopyWithImpl(this._self, this._then);

  final SecretariatOverview _self;
  final $Res Function(SecretariatOverview) _then;

/// Create a copy of SecretariatOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalPending = null,Object? items = null,}) {
  return _then(SecretariatOverview(
totalPending: null == totalPending ? _self.totalPending : totalPending // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<LabeledCount>,
  ));
}

}


/// Adds pattern-matching-related methods to [SecretariatOverview].
extension SecretariatOverviewPatterns on SecretariatOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SecretariatOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SecretariatOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SecretariatOverview value)  $default,){
final _that = this;
switch (_that) {
case _SecretariatOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SecretariatOverview value)?  $default,){
final _that = this;
switch (_that) {
case _SecretariatOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalPending,  List<LabeledCount> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SecretariatOverview() when $default != null:
return $default(_that.totalPending,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalPending,  List<LabeledCount> items)  $default,) {final _that = this;
switch (_that) {
case _SecretariatOverview():
return $default(_that.totalPending,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalPending,  List<LabeledCount> items)?  $default,) {final _that = this;
switch (_that) {
case _SecretariatOverview() when $default != null:
return $default(_that.totalPending,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SecretariatOverview implements SecretariatOverview {
  const _SecretariatOverview({required this.totalPending, required  List<LabeledCount> items}): _items = items;
  factory _SecretariatOverview.fromJson(Map<String, dynamic> json) => _$SecretariatOverviewFromJson(json);

@override final  int totalPending;
 final  List<LabeledCount> _items;
@override List<LabeledCount> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of SecretariatOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SecretariatOverviewCopyWith<_SecretariatOverview> get copyWith => __$SecretariatOverviewCopyWithImpl<_SecretariatOverview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SecretariatOverviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SecretariatOverview&&(identical(other.totalPending, totalPending) || other.totalPending == totalPending)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalPending,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'SecretariatOverview(totalPending: $totalPending, items: $items)';
}


}

/// @nodoc
abstract mixin class _$SecretariatOverviewCopyWith<$Res> implements $SecretariatOverviewCopyWith<$Res> {
  factory _$SecretariatOverviewCopyWith(_SecretariatOverview value, $Res Function(_SecretariatOverview) _then) = __$SecretariatOverviewCopyWithImpl;
@override @useResult
$Res call({
 int totalPending, List<LabeledCount> items
});




}
/// @nodoc
class __$SecretariatOverviewCopyWithImpl<$Res>
    implements _$SecretariatOverviewCopyWith<$Res> {
  __$SecretariatOverviewCopyWithImpl(this._self, this._then);

  final _SecretariatOverview _self;
  final $Res Function(_SecretariatOverview) _then;

/// Create a copy of SecretariatOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalPending = null,Object? items = null,}) {
  return _then(_SecretariatOverview(
totalPending: null == totalPending ? _self.totalPending : totalPending // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<LabeledCount>,
  ));
}


}


/// @nodoc
mixin _$OperationsOverview {

 CafeteriaOverview? get cafeteria; AccessOverview? get access; HrOverview? get hr; SecretariatOverview? get secretariat;
/// Create a copy of OperationsOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OperationsOverviewCopyWith<OperationsOverview> get copyWith => _$OperationsOverviewCopyWithImpl<OperationsOverview>(this as OperationsOverview, _$identity);

  /// Serializes this OperationsOverview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OperationsOverview&&(identical(other.cafeteria, cafeteria) || other.cafeteria == cafeteria)&&(identical(other.access, access) || other.access == access)&&(identical(other.hr, hr) || other.hr == hr)&&(identical(other.secretariat, secretariat) || other.secretariat == secretariat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cafeteria,access,hr,secretariat);

@override
String toString() {
  return 'OperationsOverview(cafeteria: $cafeteria, access: $access, hr: $hr, secretariat: $secretariat)';
}


}

/// @nodoc
abstract mixin class $OperationsOverviewCopyWith<$Res>  {
  factory $OperationsOverviewCopyWith(OperationsOverview value, $Res Function(OperationsOverview) _then) = _$OperationsOverviewCopyWithImpl;
@useResult
$Res call({
 CafeteriaOverview? cafeteria, AccessOverview? access, HrOverview? hr, SecretariatOverview? secretariat
});


$CafeteriaOverviewCopyWith<$Res>? get cafeteria;$AccessOverviewCopyWith<$Res>? get access;$HrOverviewCopyWith<$Res>? get hr;$SecretariatOverviewCopyWith<$Res>? get secretariat;

}
/// @nodoc
class _$OperationsOverviewCopyWithImpl<$Res>
    implements $OperationsOverviewCopyWith<$Res> {
  _$OperationsOverviewCopyWithImpl(this._self, this._then);

  final OperationsOverview _self;
  final $Res Function(OperationsOverview) _then;

/// Create a copy of OperationsOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cafeteria = freezed,Object? access = freezed,Object? hr = freezed,Object? secretariat = freezed,}) {
  return _then(OperationsOverview(
cafeteria: freezed == cafeteria ? _self.cafeteria : cafeteria // ignore: cast_nullable_to_non_nullable
as CafeteriaOverview?,access: freezed == access ? _self.access : access // ignore: cast_nullable_to_non_nullable
as AccessOverview?,hr: freezed == hr ? _self.hr : hr // ignore: cast_nullable_to_non_nullable
as HrOverview?,secretariat: freezed == secretariat ? _self.secretariat : secretariat // ignore: cast_nullable_to_non_nullable
as SecretariatOverview?,
  ));
}
/// Create a copy of OperationsOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CafeteriaOverviewCopyWith<$Res>? get cafeteria {
    if (_self.cafeteria == null) {
    return null;
  }

  return $CafeteriaOverviewCopyWith<$Res>(_self.cafeteria!, (value) {
    return _then(_self.copyWith(cafeteria: value));
  });
}/// Create a copy of OperationsOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccessOverviewCopyWith<$Res>? get access {
    if (_self.access == null) {
    return null;
  }

  return $AccessOverviewCopyWith<$Res>(_self.access!, (value) {
    return _then(_self.copyWith(access: value));
  });
}/// Create a copy of OperationsOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HrOverviewCopyWith<$Res>? get hr {
    if (_self.hr == null) {
    return null;
  }

  return $HrOverviewCopyWith<$Res>(_self.hr!, (value) {
    return _then(_self.copyWith(hr: value));
  });
}/// Create a copy of OperationsOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SecretariatOverviewCopyWith<$Res>? get secretariat {
    if (_self.secretariat == null) {
    return null;
  }

  return $SecretariatOverviewCopyWith<$Res>(_self.secretariat!, (value) {
    return _then(_self.copyWith(secretariat: value));
  });
}
}


/// Adds pattern-matching-related methods to [OperationsOverview].
extension OperationsOverviewPatterns on OperationsOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OperationsOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OperationsOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OperationsOverview value)  $default,){
final _that = this;
switch (_that) {
case _OperationsOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OperationsOverview value)?  $default,){
final _that = this;
switch (_that) {
case _OperationsOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CafeteriaOverview? cafeteria,  AccessOverview? access,  HrOverview? hr,  SecretariatOverview? secretariat)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OperationsOverview() when $default != null:
return $default(_that.cafeteria,_that.access,_that.hr,_that.secretariat);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CafeteriaOverview? cafeteria,  AccessOverview? access,  HrOverview? hr,  SecretariatOverview? secretariat)  $default,) {final _that = this;
switch (_that) {
case _OperationsOverview():
return $default(_that.cafeteria,_that.access,_that.hr,_that.secretariat);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CafeteriaOverview? cafeteria,  AccessOverview? access,  HrOverview? hr,  SecretariatOverview? secretariat)?  $default,) {final _that = this;
switch (_that) {
case _OperationsOverview() when $default != null:
return $default(_that.cafeteria,_that.access,_that.hr,_that.secretariat);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OperationsOverview implements OperationsOverview {
  const _OperationsOverview({this.cafeteria, this.access, this.hr, this.secretariat});
  factory _OperationsOverview.fromJson(Map<String, dynamic> json) => _$OperationsOverviewFromJson(json);

@override final  CafeteriaOverview? cafeteria;
@override final  AccessOverview? access;
@override final  HrOverview? hr;
@override final  SecretariatOverview? secretariat;

/// Create a copy of OperationsOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OperationsOverviewCopyWith<_OperationsOverview> get copyWith => __$OperationsOverviewCopyWithImpl<_OperationsOverview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OperationsOverviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OperationsOverview&&(identical(other.cafeteria, cafeteria) || other.cafeteria == cafeteria)&&(identical(other.access, access) || other.access == access)&&(identical(other.hr, hr) || other.hr == hr)&&(identical(other.secretariat, secretariat) || other.secretariat == secretariat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cafeteria,access,hr,secretariat);

@override
String toString() {
  return 'OperationsOverview(cafeteria: $cafeteria, access: $access, hr: $hr, secretariat: $secretariat)';
}


}

/// @nodoc
abstract mixin class _$OperationsOverviewCopyWith<$Res> implements $OperationsOverviewCopyWith<$Res> {
  factory _$OperationsOverviewCopyWith(_OperationsOverview value, $Res Function(_OperationsOverview) _then) = __$OperationsOverviewCopyWithImpl;
@override @useResult
$Res call({
 CafeteriaOverview? cafeteria, AccessOverview? access, HrOverview? hr, SecretariatOverview? secretariat
});


@override $CafeteriaOverviewCopyWith<$Res>? get cafeteria;@override $AccessOverviewCopyWith<$Res>? get access;@override $HrOverviewCopyWith<$Res>? get hr;@override $SecretariatOverviewCopyWith<$Res>? get secretariat;

}
/// @nodoc
class __$OperationsOverviewCopyWithImpl<$Res>
    implements _$OperationsOverviewCopyWith<$Res> {
  __$OperationsOverviewCopyWithImpl(this._self, this._then);

  final _OperationsOverview _self;
  final $Res Function(_OperationsOverview) _then;

/// Create a copy of OperationsOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cafeteria = freezed,Object? access = freezed,Object? hr = freezed,Object? secretariat = freezed,}) {
  return _then(_OperationsOverview(
cafeteria: freezed == cafeteria ? _self.cafeteria : cafeteria // ignore: cast_nullable_to_non_nullable
as CafeteriaOverview?,access: freezed == access ? _self.access : access // ignore: cast_nullable_to_non_nullable
as AccessOverview?,hr: freezed == hr ? _self.hr : hr // ignore: cast_nullable_to_non_nullable
as HrOverview?,secretariat: freezed == secretariat ? _self.secretariat : secretariat // ignore: cast_nullable_to_non_nullable
as SecretariatOverview?,
  ));
}

/// Create a copy of OperationsOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CafeteriaOverviewCopyWith<$Res>? get cafeteria {
    if (_self.cafeteria == null) {
    return null;
  }

  return $CafeteriaOverviewCopyWith<$Res>(_self.cafeteria!, (value) {
    return _then(_self.copyWith(cafeteria: value));
  });
}/// Create a copy of OperationsOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccessOverviewCopyWith<$Res>? get access {
    if (_self.access == null) {
    return null;
  }

  return $AccessOverviewCopyWith<$Res>(_self.access!, (value) {
    return _then(_self.copyWith(access: value));
  });
}/// Create a copy of OperationsOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HrOverviewCopyWith<$Res>? get hr {
    if (_self.hr == null) {
    return null;
  }

  return $HrOverviewCopyWith<$Res>(_self.hr!, (value) {
    return _then(_self.copyWith(hr: value));
  });
}/// Create a copy of OperationsOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SecretariatOverviewCopyWith<$Res>? get secretariat {
    if (_self.secretariat == null) {
    return null;
  }

  return $SecretariatOverviewCopyWith<$Res>(_self.secretariat!, (value) {
    return _then(_self.copyWith(secretariat: value));
  });
}
}

// dart format on
