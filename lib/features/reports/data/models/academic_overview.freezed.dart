// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'academic_overview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AcademicTotals {

 int get enrolled; int get active; int get occupancy; int? get approvalRate; int? get attendanceRate;
/// Create a copy of AcademicTotals
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AcademicTotalsCopyWith<AcademicTotals> get copyWith => _$AcademicTotalsCopyWithImpl<AcademicTotals>(this as AcademicTotals, _$identity);

  /// Serializes this AcademicTotals to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AcademicTotals&&(identical(other.enrolled, enrolled) || other.enrolled == enrolled)&&(identical(other.active, active) || other.active == active)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy)&&(identical(other.approvalRate, approvalRate) || other.approvalRate == approvalRate)&&(identical(other.attendanceRate, attendanceRate) || other.attendanceRate == attendanceRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enrolled,active,occupancy,approvalRate,attendanceRate);

@override
String toString() {
  return 'AcademicTotals(enrolled: $enrolled, active: $active, occupancy: $occupancy, approvalRate: $approvalRate, attendanceRate: $attendanceRate)';
}


}

/// @nodoc
abstract mixin class $AcademicTotalsCopyWith<$Res>  {
  factory $AcademicTotalsCopyWith(AcademicTotals value, $Res Function(AcademicTotals) _then) = _$AcademicTotalsCopyWithImpl;
@useResult
$Res call({
 int enrolled, int active, int occupancy, int? approvalRate, int? attendanceRate
});




}
/// @nodoc
class _$AcademicTotalsCopyWithImpl<$Res>
    implements $AcademicTotalsCopyWith<$Res> {
  _$AcademicTotalsCopyWithImpl(this._self, this._then);

  final AcademicTotals _self;
  final $Res Function(AcademicTotals) _then;

/// Create a copy of AcademicTotals
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enrolled = null,Object? active = null,Object? occupancy = null,Object? approvalRate = freezed,Object? attendanceRate = freezed,}) {
  return _then(AcademicTotals(
enrolled: null == enrolled ? _self.enrolled : enrolled // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as int,occupancy: null == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as int,approvalRate: freezed == approvalRate ? _self.approvalRate : approvalRate // ignore: cast_nullable_to_non_nullable
as int?,attendanceRate: freezed == attendanceRate ? _self.attendanceRate : attendanceRate // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AcademicTotals].
extension AcademicTotalsPatterns on AcademicTotals {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AcademicTotals value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AcademicTotals() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AcademicTotals value)  $default,){
final _that = this;
switch (_that) {
case _AcademicTotals():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AcademicTotals value)?  $default,){
final _that = this;
switch (_that) {
case _AcademicTotals() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int enrolled,  int active,  int occupancy,  int? approvalRate,  int? attendanceRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AcademicTotals() when $default != null:
return $default(_that.enrolled,_that.active,_that.occupancy,_that.approvalRate,_that.attendanceRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int enrolled,  int active,  int occupancy,  int? approvalRate,  int? attendanceRate)  $default,) {final _that = this;
switch (_that) {
case _AcademicTotals():
return $default(_that.enrolled,_that.active,_that.occupancy,_that.approvalRate,_that.attendanceRate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int enrolled,  int active,  int occupancy,  int? approvalRate,  int? attendanceRate)?  $default,) {final _that = this;
switch (_that) {
case _AcademicTotals() when $default != null:
return $default(_that.enrolled,_that.active,_that.occupancy,_that.approvalRate,_that.attendanceRate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AcademicTotals implements AcademicTotals {
  const _AcademicTotals({required this.enrolled, required this.active, required this.occupancy, this.approvalRate, this.attendanceRate});
  factory _AcademicTotals.fromJson(Map<String, dynamic> json) => _$AcademicTotalsFromJson(json);

@override final  int enrolled;
@override final  int active;
@override final  int occupancy;
@override final  int? approvalRate;
@override final  int? attendanceRate;

/// Create a copy of AcademicTotals
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AcademicTotalsCopyWith<_AcademicTotals> get copyWith => __$AcademicTotalsCopyWithImpl<_AcademicTotals>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AcademicTotalsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AcademicTotals&&(identical(other.enrolled, enrolled) || other.enrolled == enrolled)&&(identical(other.active, active) || other.active == active)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy)&&(identical(other.approvalRate, approvalRate) || other.approvalRate == approvalRate)&&(identical(other.attendanceRate, attendanceRate) || other.attendanceRate == attendanceRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enrolled,active,occupancy,approvalRate,attendanceRate);

@override
String toString() {
  return 'AcademicTotals(enrolled: $enrolled, active: $active, occupancy: $occupancy, approvalRate: $approvalRate, attendanceRate: $attendanceRate)';
}


}

/// @nodoc
abstract mixin class _$AcademicTotalsCopyWith<$Res> implements $AcademicTotalsCopyWith<$Res> {
  factory _$AcademicTotalsCopyWith(_AcademicTotals value, $Res Function(_AcademicTotals) _then) = __$AcademicTotalsCopyWithImpl;
@override @useResult
$Res call({
 int enrolled, int active, int occupancy, int? approvalRate, int? attendanceRate
});




}
/// @nodoc
class __$AcademicTotalsCopyWithImpl<$Res>
    implements _$AcademicTotalsCopyWith<$Res> {
  __$AcademicTotalsCopyWithImpl(this._self, this._then);

  final _AcademicTotals _self;
  final $Res Function(_AcademicTotals) _then;

/// Create a copy of AcademicTotals
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enrolled = null,Object? active = null,Object? occupancy = null,Object? approvalRate = freezed,Object? attendanceRate = freezed,}) {
  return _then(_AcademicTotals(
enrolled: null == enrolled ? _self.enrolled : enrolled // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as int,occupancy: null == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as int,approvalRate: freezed == approvalRate ? _self.approvalRate : approvalRate // ignore: cast_nullable_to_non_nullable
as int?,attendanceRate: freezed == attendanceRate ? _self.attendanceRate : attendanceRate // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$AcademicGradeRow {

 String get gradeId; String get label; int get enrolled; int get active; int get capacity; int get occupancy; int? get approvalRate; int? get attendanceRate;
/// Create a copy of AcademicGradeRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AcademicGradeRowCopyWith<AcademicGradeRow> get copyWith => _$AcademicGradeRowCopyWithImpl<AcademicGradeRow>(this as AcademicGradeRow, _$identity);

  /// Serializes this AcademicGradeRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AcademicGradeRow&&(identical(other.gradeId, gradeId) || other.gradeId == gradeId)&&(identical(other.label, label) || other.label == label)&&(identical(other.enrolled, enrolled) || other.enrolled == enrolled)&&(identical(other.active, active) || other.active == active)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy)&&(identical(other.approvalRate, approvalRate) || other.approvalRate == approvalRate)&&(identical(other.attendanceRate, attendanceRate) || other.attendanceRate == attendanceRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gradeId,label,enrolled,active,capacity,occupancy,approvalRate,attendanceRate);

@override
String toString() {
  return 'AcademicGradeRow(gradeId: $gradeId, label: $label, enrolled: $enrolled, active: $active, capacity: $capacity, occupancy: $occupancy, approvalRate: $approvalRate, attendanceRate: $attendanceRate)';
}


}

/// @nodoc
abstract mixin class $AcademicGradeRowCopyWith<$Res>  {
  factory $AcademicGradeRowCopyWith(AcademicGradeRow value, $Res Function(AcademicGradeRow) _then) = _$AcademicGradeRowCopyWithImpl;
@useResult
$Res call({
 String gradeId, String label, int enrolled, int active, int capacity, int occupancy, int? approvalRate, int? attendanceRate
});




}
/// @nodoc
class _$AcademicGradeRowCopyWithImpl<$Res>
    implements $AcademicGradeRowCopyWith<$Res> {
  _$AcademicGradeRowCopyWithImpl(this._self, this._then);

  final AcademicGradeRow _self;
  final $Res Function(AcademicGradeRow) _then;

/// Create a copy of AcademicGradeRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gradeId = null,Object? label = null,Object? enrolled = null,Object? active = null,Object? capacity = null,Object? occupancy = null,Object? approvalRate = freezed,Object? attendanceRate = freezed,}) {
  return _then(AcademicGradeRow(
gradeId: null == gradeId ? _self.gradeId : gradeId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,enrolled: null == enrolled ? _self.enrolled : enrolled // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as int,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,occupancy: null == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as int,approvalRate: freezed == approvalRate ? _self.approvalRate : approvalRate // ignore: cast_nullable_to_non_nullable
as int?,attendanceRate: freezed == attendanceRate ? _self.attendanceRate : attendanceRate // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AcademicGradeRow].
extension AcademicGradeRowPatterns on AcademicGradeRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AcademicGradeRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AcademicGradeRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AcademicGradeRow value)  $default,){
final _that = this;
switch (_that) {
case _AcademicGradeRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AcademicGradeRow value)?  $default,){
final _that = this;
switch (_that) {
case _AcademicGradeRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String gradeId,  String label,  int enrolled,  int active,  int capacity,  int occupancy,  int? approvalRate,  int? attendanceRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AcademicGradeRow() when $default != null:
return $default(_that.gradeId,_that.label,_that.enrolled,_that.active,_that.capacity,_that.occupancy,_that.approvalRate,_that.attendanceRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String gradeId,  String label,  int enrolled,  int active,  int capacity,  int occupancy,  int? approvalRate,  int? attendanceRate)  $default,) {final _that = this;
switch (_that) {
case _AcademicGradeRow():
return $default(_that.gradeId,_that.label,_that.enrolled,_that.active,_that.capacity,_that.occupancy,_that.approvalRate,_that.attendanceRate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String gradeId,  String label,  int enrolled,  int active,  int capacity,  int occupancy,  int? approvalRate,  int? attendanceRate)?  $default,) {final _that = this;
switch (_that) {
case _AcademicGradeRow() when $default != null:
return $default(_that.gradeId,_that.label,_that.enrolled,_that.active,_that.capacity,_that.occupancy,_that.approvalRate,_that.attendanceRate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AcademicGradeRow implements AcademicGradeRow {
  const _AcademicGradeRow({required this.gradeId, required this.label, required this.enrolled, required this.active, required this.capacity, required this.occupancy, this.approvalRate, this.attendanceRate});
  factory _AcademicGradeRow.fromJson(Map<String, dynamic> json) => _$AcademicGradeRowFromJson(json);

@override final  String gradeId;
@override final  String label;
@override final  int enrolled;
@override final  int active;
@override final  int capacity;
@override final  int occupancy;
@override final  int? approvalRate;
@override final  int? attendanceRate;

/// Create a copy of AcademicGradeRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AcademicGradeRowCopyWith<_AcademicGradeRow> get copyWith => __$AcademicGradeRowCopyWithImpl<_AcademicGradeRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AcademicGradeRowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AcademicGradeRow&&(identical(other.gradeId, gradeId) || other.gradeId == gradeId)&&(identical(other.label, label) || other.label == label)&&(identical(other.enrolled, enrolled) || other.enrolled == enrolled)&&(identical(other.active, active) || other.active == active)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy)&&(identical(other.approvalRate, approvalRate) || other.approvalRate == approvalRate)&&(identical(other.attendanceRate, attendanceRate) || other.attendanceRate == attendanceRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gradeId,label,enrolled,active,capacity,occupancy,approvalRate,attendanceRate);

@override
String toString() {
  return 'AcademicGradeRow(gradeId: $gradeId, label: $label, enrolled: $enrolled, active: $active, capacity: $capacity, occupancy: $occupancy, approvalRate: $approvalRate, attendanceRate: $attendanceRate)';
}


}

/// @nodoc
abstract mixin class _$AcademicGradeRowCopyWith<$Res> implements $AcademicGradeRowCopyWith<$Res> {
  factory _$AcademicGradeRowCopyWith(_AcademicGradeRow value, $Res Function(_AcademicGradeRow) _then) = __$AcademicGradeRowCopyWithImpl;
@override @useResult
$Res call({
 String gradeId, String label, int enrolled, int active, int capacity, int occupancy, int? approvalRate, int? attendanceRate
});




}
/// @nodoc
class __$AcademicGradeRowCopyWithImpl<$Res>
    implements _$AcademicGradeRowCopyWith<$Res> {
  __$AcademicGradeRowCopyWithImpl(this._self, this._then);

  final _AcademicGradeRow _self;
  final $Res Function(_AcademicGradeRow) _then;

/// Create a copy of AcademicGradeRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gradeId = null,Object? label = null,Object? enrolled = null,Object? active = null,Object? capacity = null,Object? occupancy = null,Object? approvalRate = freezed,Object? attendanceRate = freezed,}) {
  return _then(_AcademicGradeRow(
gradeId: null == gradeId ? _self.gradeId : gradeId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,enrolled: null == enrolled ? _self.enrolled : enrolled // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as int,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,occupancy: null == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as int,approvalRate: freezed == approvalRate ? _self.approvalRate : approvalRate // ignore: cast_nullable_to_non_nullable
as int?,attendanceRate: freezed == attendanceRate ? _self.attendanceRate : attendanceRate // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$AcademicOverview {

 AcademicTotals get totals; List<AcademicGradeRow> get rows; AcademicTotals? get previous;
/// Create a copy of AcademicOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AcademicOverviewCopyWith<AcademicOverview> get copyWith => _$AcademicOverviewCopyWithImpl<AcademicOverview>(this as AcademicOverview, _$identity);

  /// Serializes this AcademicOverview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AcademicOverview&&(identical(other.totals, totals) || other.totals == totals)&&const DeepCollectionEquality().equals(other.rows, rows)&&(identical(other.previous, previous) || other.previous == previous));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totals,const DeepCollectionEquality().hash(rows),previous);

@override
String toString() {
  return 'AcademicOverview(totals: $totals, rows: $rows, previous: $previous)';
}


}

/// @nodoc
abstract mixin class $AcademicOverviewCopyWith<$Res>  {
  factory $AcademicOverviewCopyWith(AcademicOverview value, $Res Function(AcademicOverview) _then) = _$AcademicOverviewCopyWithImpl;
@useResult
$Res call({
 AcademicTotals totals, List<AcademicGradeRow> rows, AcademicTotals? previous
});


$AcademicTotalsCopyWith<$Res> get totals;$AcademicTotalsCopyWith<$Res>? get previous;

}
/// @nodoc
class _$AcademicOverviewCopyWithImpl<$Res>
    implements $AcademicOverviewCopyWith<$Res> {
  _$AcademicOverviewCopyWithImpl(this._self, this._then);

  final AcademicOverview _self;
  final $Res Function(AcademicOverview) _then;

/// Create a copy of AcademicOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totals = null,Object? rows = null,Object? previous = freezed,}) {
  return _then(AcademicOverview(
totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as AcademicTotals,rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<AcademicGradeRow>,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as AcademicTotals?,
  ));
}
/// Create a copy of AcademicOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AcademicTotalsCopyWith<$Res> get totals {
  
  return $AcademicTotalsCopyWith<$Res>(_self.totals, (value) {
    return _then(_self.copyWith(totals: value));
  });
}/// Create a copy of AcademicOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AcademicTotalsCopyWith<$Res>? get previous {
    if (_self.previous == null) {
    return null;
  }

  return $AcademicTotalsCopyWith<$Res>(_self.previous!, (value) {
    return _then(_self.copyWith(previous: value));
  });
}
}


/// Adds pattern-matching-related methods to [AcademicOverview].
extension AcademicOverviewPatterns on AcademicOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AcademicOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AcademicOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AcademicOverview value)  $default,){
final _that = this;
switch (_that) {
case _AcademicOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AcademicOverview value)?  $default,){
final _that = this;
switch (_that) {
case _AcademicOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AcademicTotals totals,  List<AcademicGradeRow> rows,  AcademicTotals? previous)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AcademicOverview() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AcademicTotals totals,  List<AcademicGradeRow> rows,  AcademicTotals? previous)  $default,) {final _that = this;
switch (_that) {
case _AcademicOverview():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AcademicTotals totals,  List<AcademicGradeRow> rows,  AcademicTotals? previous)?  $default,) {final _that = this;
switch (_that) {
case _AcademicOverview() when $default != null:
return $default(_that.totals,_that.rows,_that.previous);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AcademicOverview implements AcademicOverview {
  const _AcademicOverview({required this.totals, required  List<AcademicGradeRow> rows, this.previous}): _rows = rows;
  factory _AcademicOverview.fromJson(Map<String, dynamic> json) => _$AcademicOverviewFromJson(json);

@override final  AcademicTotals totals;
 final  List<AcademicGradeRow> _rows;
@override List<AcademicGradeRow> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}

@override final  AcademicTotals? previous;

/// Create a copy of AcademicOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AcademicOverviewCopyWith<_AcademicOverview> get copyWith => __$AcademicOverviewCopyWithImpl<_AcademicOverview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AcademicOverviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AcademicOverview&&(identical(other.totals, totals) || other.totals == totals)&&const DeepCollectionEquality().equals(other._rows, _rows)&&(identical(other.previous, previous) || other.previous == previous));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totals,const DeepCollectionEquality().hash(_rows),previous);

@override
String toString() {
  return 'AcademicOverview(totals: $totals, rows: $rows, previous: $previous)';
}


}

/// @nodoc
abstract mixin class _$AcademicOverviewCopyWith<$Res> implements $AcademicOverviewCopyWith<$Res> {
  factory _$AcademicOverviewCopyWith(_AcademicOverview value, $Res Function(_AcademicOverview) _then) = __$AcademicOverviewCopyWithImpl;
@override @useResult
$Res call({
 AcademicTotals totals, List<AcademicGradeRow> rows, AcademicTotals? previous
});


@override $AcademicTotalsCopyWith<$Res> get totals;@override $AcademicTotalsCopyWith<$Res>? get previous;

}
/// @nodoc
class __$AcademicOverviewCopyWithImpl<$Res>
    implements _$AcademicOverviewCopyWith<$Res> {
  __$AcademicOverviewCopyWithImpl(this._self, this._then);

  final _AcademicOverview _self;
  final $Res Function(_AcademicOverview) _then;

/// Create a copy of AcademicOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totals = null,Object? rows = null,Object? previous = freezed,}) {
  return _then(_AcademicOverview(
totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as AcademicTotals,rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<AcademicGradeRow>,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as AcademicTotals?,
  ));
}

/// Create a copy of AcademicOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AcademicTotalsCopyWith<$Res> get totals {
  
  return $AcademicTotalsCopyWith<$Res>(_self.totals, (value) {
    return _then(_self.copyWith(totals: value));
  });
}/// Create a copy of AcademicOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AcademicTotalsCopyWith<$Res>? get previous {
    if (_self.previous == null) {
    return null;
  }

  return $AcademicTotalsCopyWith<$Res>(_self.previous!, (value) {
    return _then(_self.copyWith(previous: value));
  });
}
}

// dart format on
