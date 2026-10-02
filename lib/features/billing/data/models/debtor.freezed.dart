// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debtor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Debtor {

 String get studentId; String? get classroomId;@MinorUnitConverter() int get overdueMinor; int get overdueCount;@DateOnlyConverter() DateTime get oldestDueDate; int get daysOverdue; bool get hasAgreement;
/// Create a copy of Debtor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtorCopyWith<Debtor> get copyWith => _$DebtorCopyWithImpl<Debtor>(this as Debtor, _$identity);

  /// Serializes this Debtor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Debtor&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.overdueMinor, overdueMinor) || other.overdueMinor == overdueMinor)&&(identical(other.overdueCount, overdueCount) || other.overdueCount == overdueCount)&&(identical(other.oldestDueDate, oldestDueDate) || other.oldestDueDate == oldestDueDate)&&(identical(other.daysOverdue, daysOverdue) || other.daysOverdue == daysOverdue)&&(identical(other.hasAgreement, hasAgreement) || other.hasAgreement == hasAgreement));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,classroomId,overdueMinor,overdueCount,oldestDueDate,daysOverdue,hasAgreement);

@override
String toString() {
  return 'Debtor(studentId: $studentId, classroomId: $classroomId, overdueMinor: $overdueMinor, overdueCount: $overdueCount, oldestDueDate: $oldestDueDate, daysOverdue: $daysOverdue, hasAgreement: $hasAgreement)';
}


}

/// @nodoc
abstract mixin class $DebtorCopyWith<$Res>  {
  factory $DebtorCopyWith(Debtor value, $Res Function(Debtor) _then) = _$DebtorCopyWithImpl;
@useResult
$Res call({
 String studentId, String? classroomId,@MinorUnitConverter() int overdueMinor, int overdueCount,@DateOnlyConverter() DateTime oldestDueDate, int daysOverdue, bool hasAgreement
});




}
/// @nodoc
class _$DebtorCopyWithImpl<$Res>
    implements $DebtorCopyWith<$Res> {
  _$DebtorCopyWithImpl(this._self, this._then);

  final Debtor _self;
  final $Res Function(Debtor) _then;

/// Create a copy of Debtor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? studentId = null,Object? classroomId = freezed,Object? overdueMinor = null,Object? overdueCount = null,Object? oldestDueDate = null,Object? daysOverdue = null,Object? hasAgreement = null,}) {
  return _then(Debtor(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,classroomId: freezed == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String?,overdueMinor: null == overdueMinor ? _self.overdueMinor : overdueMinor // ignore: cast_nullable_to_non_nullable
as int,overdueCount: null == overdueCount ? _self.overdueCount : overdueCount // ignore: cast_nullable_to_non_nullable
as int,oldestDueDate: null == oldestDueDate ? _self.oldestDueDate : oldestDueDate // ignore: cast_nullable_to_non_nullable
as DateTime,daysOverdue: null == daysOverdue ? _self.daysOverdue : daysOverdue // ignore: cast_nullable_to_non_nullable
as int,hasAgreement: null == hasAgreement ? _self.hasAgreement : hasAgreement // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Debtor].
extension DebtorPatterns on Debtor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Debtor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Debtor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Debtor value)  $default,){
final _that = this;
switch (_that) {
case _Debtor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Debtor value)?  $default,){
final _that = this;
switch (_that) {
case _Debtor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String studentId,  String? classroomId, @MinorUnitConverter()  int overdueMinor,  int overdueCount, @DateOnlyConverter()  DateTime oldestDueDate,  int daysOverdue,  bool hasAgreement)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Debtor() when $default != null:
return $default(_that.studentId,_that.classroomId,_that.overdueMinor,_that.overdueCount,_that.oldestDueDate,_that.daysOverdue,_that.hasAgreement);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String studentId,  String? classroomId, @MinorUnitConverter()  int overdueMinor,  int overdueCount, @DateOnlyConverter()  DateTime oldestDueDate,  int daysOverdue,  bool hasAgreement)  $default,) {final _that = this;
switch (_that) {
case _Debtor():
return $default(_that.studentId,_that.classroomId,_that.overdueMinor,_that.overdueCount,_that.oldestDueDate,_that.daysOverdue,_that.hasAgreement);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String studentId,  String? classroomId, @MinorUnitConverter()  int overdueMinor,  int overdueCount, @DateOnlyConverter()  DateTime oldestDueDate,  int daysOverdue,  bool hasAgreement)?  $default,) {final _that = this;
switch (_that) {
case _Debtor() when $default != null:
return $default(_that.studentId,_that.classroomId,_that.overdueMinor,_that.overdueCount,_that.oldestDueDate,_that.daysOverdue,_that.hasAgreement);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Debtor implements Debtor {
  const _Debtor({required this.studentId, this.classroomId, @MinorUnitConverter() required this.overdueMinor, required this.overdueCount, @DateOnlyConverter() required this.oldestDueDate, required this.daysOverdue, this.hasAgreement = false});
  factory _Debtor.fromJson(Map<String, dynamic> json) => _$DebtorFromJson(json);

@override final  String studentId;
@override final  String? classroomId;
@override@MinorUnitConverter() final  int overdueMinor;
@override final  int overdueCount;
@override@DateOnlyConverter() final  DateTime oldestDueDate;
@override final  int daysOverdue;
@override@JsonKey() final  bool hasAgreement;

/// Create a copy of Debtor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtorCopyWith<_Debtor> get copyWith => __$DebtorCopyWithImpl<_Debtor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DebtorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Debtor&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&(identical(other.overdueMinor, overdueMinor) || other.overdueMinor == overdueMinor)&&(identical(other.overdueCount, overdueCount) || other.overdueCount == overdueCount)&&(identical(other.oldestDueDate, oldestDueDate) || other.oldestDueDate == oldestDueDate)&&(identical(other.daysOverdue, daysOverdue) || other.daysOverdue == daysOverdue)&&(identical(other.hasAgreement, hasAgreement) || other.hasAgreement == hasAgreement));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,classroomId,overdueMinor,overdueCount,oldestDueDate,daysOverdue,hasAgreement);

@override
String toString() {
  return 'Debtor(studentId: $studentId, classroomId: $classroomId, overdueMinor: $overdueMinor, overdueCount: $overdueCount, oldestDueDate: $oldestDueDate, daysOverdue: $daysOverdue, hasAgreement: $hasAgreement)';
}


}

/// @nodoc
abstract mixin class _$DebtorCopyWith<$Res> implements $DebtorCopyWith<$Res> {
  factory _$DebtorCopyWith(_Debtor value, $Res Function(_Debtor) _then) = __$DebtorCopyWithImpl;
@override @useResult
$Res call({
 String studentId, String? classroomId,@MinorUnitConverter() int overdueMinor, int overdueCount,@DateOnlyConverter() DateTime oldestDueDate, int daysOverdue, bool hasAgreement
});




}
/// @nodoc
class __$DebtorCopyWithImpl<$Res>
    implements _$DebtorCopyWith<$Res> {
  __$DebtorCopyWithImpl(this._self, this._then);

  final _Debtor _self;
  final $Res Function(_Debtor) _then;

/// Create a copy of Debtor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? studentId = null,Object? classroomId = freezed,Object? overdueMinor = null,Object? overdueCount = null,Object? oldestDueDate = null,Object? daysOverdue = null,Object? hasAgreement = null,}) {
  return _then(_Debtor(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,classroomId: freezed == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String?,overdueMinor: null == overdueMinor ? _self.overdueMinor : overdueMinor // ignore: cast_nullable_to_non_nullable
as int,overdueCount: null == overdueCount ? _self.overdueCount : overdueCount // ignore: cast_nullable_to_non_nullable
as int,oldestDueDate: null == oldestDueDate ? _self.oldestDueDate : oldestDueDate // ignore: cast_nullable_to_non_nullable
as DateTime,daysOverdue: null == daysOverdue ? _self.daysOverdue : daysOverdue // ignore: cast_nullable_to_non_nullable
as int,hasAgreement: null == hasAgreement ? _self.hasAgreement : hasAgreement // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
