// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payroll_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttendanceRecord {

 String get id; String get employeeId;/// `AAAA-MM-DD`.
 String get date; AttendanceStatus get status;
/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceRecordCopyWith<AttendanceRecord> get copyWith => _$AttendanceRecordCopyWithImpl<AttendanceRecord>(this as AttendanceRecord, _$identity);

  /// Serializes this AttendanceRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeId,date,status);

@override
String toString() {
  return 'AttendanceRecord(id: $id, employeeId: $employeeId, date: $date, status: $status)';
}


}

/// @nodoc
abstract mixin class $AttendanceRecordCopyWith<$Res>  {
  factory $AttendanceRecordCopyWith(AttendanceRecord value, $Res Function(AttendanceRecord) _then) = _$AttendanceRecordCopyWithImpl;
@useResult
$Res call({
 String id, String employeeId, String date, AttendanceStatus status
});




}
/// @nodoc
class _$AttendanceRecordCopyWithImpl<$Res>
    implements $AttendanceRecordCopyWith<$Res> {
  _$AttendanceRecordCopyWithImpl(this._self, this._then);

  final AttendanceRecord _self;
  final $Res Function(AttendanceRecord) _then;

/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? employeeId = null,Object? date = null,Object? status = null,}) {
  return _then(AttendanceRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceRecord].
extension AttendanceRecordPatterns on AttendanceRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceRecord value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceRecord value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String employeeId,  String date,  AttendanceStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
return $default(_that.id,_that.employeeId,_that.date,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String employeeId,  String date,  AttendanceStatus status)  $default,) {final _that = this;
switch (_that) {
case _AttendanceRecord():
return $default(_that.id,_that.employeeId,_that.date,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String employeeId,  String date,  AttendanceStatus status)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
return $default(_that.id,_that.employeeId,_that.date,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceRecord implements AttendanceRecord {
  const _AttendanceRecord({required this.id, required this.employeeId, required this.date, this.status = AttendanceStatus.present});
  factory _AttendanceRecord.fromJson(Map<String, dynamic> json) => _$AttendanceRecordFromJson(json);

@override final  String id;
@override final  String employeeId;
/// `AAAA-MM-DD`.
@override final  String date;
@override@JsonKey() final  AttendanceStatus status;

/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceRecordCopyWith<_AttendanceRecord> get copyWith => __$AttendanceRecordCopyWithImpl<_AttendanceRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeId,date,status);

@override
String toString() {
  return 'AttendanceRecord(id: $id, employeeId: $employeeId, date: $date, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AttendanceRecordCopyWith<$Res> implements $AttendanceRecordCopyWith<$Res> {
  factory _$AttendanceRecordCopyWith(_AttendanceRecord value, $Res Function(_AttendanceRecord) _then) = __$AttendanceRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String employeeId, String date, AttendanceStatus status
});




}
/// @nodoc
class __$AttendanceRecordCopyWithImpl<$Res>
    implements _$AttendanceRecordCopyWith<$Res> {
  __$AttendanceRecordCopyWithImpl(this._self, this._then);

  final _AttendanceRecord _self;
  final $Res Function(_AttendanceRecord) _then;

/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? employeeId = null,Object? date = null,Object? status = null,}) {
  return _then(_AttendanceRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,
  ));
}


}


/// @nodoc
mixin _$LeaveModel {

 String get id; String get employeeId; LeaveKind get kind; String get startDate; String get endDate;/// Dias úteis (calculado pelo servidor).
 int get days;
/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveModelCopyWith<LeaveModel> get copyWith => _$LeaveModelCopyWithImpl<LeaveModel>(this as LeaveModel, _$identity);

  /// Serializes this LeaveModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveModel&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.days, days) || other.days == days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeId,kind,startDate,endDate,days);

@override
String toString() {
  return 'LeaveModel(id: $id, employeeId: $employeeId, kind: $kind, startDate: $startDate, endDate: $endDate, days: $days)';
}


}

/// @nodoc
abstract mixin class $LeaveModelCopyWith<$Res>  {
  factory $LeaveModelCopyWith(LeaveModel value, $Res Function(LeaveModel) _then) = _$LeaveModelCopyWithImpl;
@useResult
$Res call({
 String id, String employeeId, LeaveKind kind, String startDate, String endDate, int days
});




}
/// @nodoc
class _$LeaveModelCopyWithImpl<$Res>
    implements $LeaveModelCopyWith<$Res> {
  _$LeaveModelCopyWithImpl(this._self, this._then);

  final LeaveModel _self;
  final $Res Function(LeaveModel) _then;

/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? employeeId = null,Object? kind = null,Object? startDate = null,Object? endDate = null,Object? days = null,}) {
  return _then(LeaveModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as LeaveKind,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveModel].
extension LeaveModelPatterns on LeaveModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveModel value)  $default,){
final _that = this;
switch (_that) {
case _LeaveModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String employeeId,  LeaveKind kind,  String startDate,  String endDate,  int days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveModel() when $default != null:
return $default(_that.id,_that.employeeId,_that.kind,_that.startDate,_that.endDate,_that.days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String employeeId,  LeaveKind kind,  String startDate,  String endDate,  int days)  $default,) {final _that = this;
switch (_that) {
case _LeaveModel():
return $default(_that.id,_that.employeeId,_that.kind,_that.startDate,_that.endDate,_that.days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String employeeId,  LeaveKind kind,  String startDate,  String endDate,  int days)?  $default,) {final _that = this;
switch (_that) {
case _LeaveModel() when $default != null:
return $default(_that.id,_that.employeeId,_that.kind,_that.startDate,_that.endDate,_that.days);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveModel implements LeaveModel {
  const _LeaveModel({required this.id, required this.employeeId, this.kind = LeaveKind.vacation, required this.startDate, required this.endDate, this.days = 0});
  factory _LeaveModel.fromJson(Map<String, dynamic> json) => _$LeaveModelFromJson(json);

@override final  String id;
@override final  String employeeId;
@override@JsonKey() final  LeaveKind kind;
@override final  String startDate;
@override final  String endDate;
/// Dias úteis (calculado pelo servidor).
@override@JsonKey() final  int days;

/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveModelCopyWith<_LeaveModel> get copyWith => __$LeaveModelCopyWithImpl<_LeaveModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveModel&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.days, days) || other.days == days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeId,kind,startDate,endDate,days);

@override
String toString() {
  return 'LeaveModel(id: $id, employeeId: $employeeId, kind: $kind, startDate: $startDate, endDate: $endDate, days: $days)';
}


}

/// @nodoc
abstract mixin class _$LeaveModelCopyWith<$Res> implements $LeaveModelCopyWith<$Res> {
  factory _$LeaveModelCopyWith(_LeaveModel value, $Res Function(_LeaveModel) _then) = __$LeaveModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String employeeId, LeaveKind kind, String startDate, String endDate, int days
});




}
/// @nodoc
class __$LeaveModelCopyWithImpl<$Res>
    implements _$LeaveModelCopyWith<$Res> {
  __$LeaveModelCopyWithImpl(this._self, this._then);

  final _LeaveModel _self;
  final $Res Function(_LeaveModel) _then;

/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? employeeId = null,Object? kind = null,Object? startDate = null,Object? endDate = null,Object? days = null,}) {
  return _then(_LeaveModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as LeaveKind,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$IrtBracket {

/// Limite inferior (cêntimos).
 int get from;/// Taxa marginal em pontos base (1300 = 13%).
 int get rateBp;/// Parcela fixa (cêntimos).
 int get fixedAmount;
/// Create a copy of IrtBracket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IrtBracketCopyWith<IrtBracket> get copyWith => _$IrtBracketCopyWithImpl<IrtBracket>(this as IrtBracket, _$identity);

  /// Serializes this IrtBracket to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IrtBracket&&(identical(other.from, from) || other.from == from)&&(identical(other.rateBp, rateBp) || other.rateBp == rateBp)&&(identical(other.fixedAmount, fixedAmount) || other.fixedAmount == fixedAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,rateBp,fixedAmount);

@override
String toString() {
  return 'IrtBracket(from: $from, rateBp: $rateBp, fixedAmount: $fixedAmount)';
}


}

/// @nodoc
abstract mixin class $IrtBracketCopyWith<$Res>  {
  factory $IrtBracketCopyWith(IrtBracket value, $Res Function(IrtBracket) _then) = _$IrtBracketCopyWithImpl;
@useResult
$Res call({
 int from, int rateBp, int fixedAmount
});




}
/// @nodoc
class _$IrtBracketCopyWithImpl<$Res>
    implements $IrtBracketCopyWith<$Res> {
  _$IrtBracketCopyWithImpl(this._self, this._then);

  final IrtBracket _self;
  final $Res Function(IrtBracket) _then;

/// Create a copy of IrtBracket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? rateBp = null,Object? fixedAmount = null,}) {
  return _then(IrtBracket(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as int,rateBp: null == rateBp ? _self.rateBp : rateBp // ignore: cast_nullable_to_non_nullable
as int,fixedAmount: null == fixedAmount ? _self.fixedAmount : fixedAmount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [IrtBracket].
extension IrtBracketPatterns on IrtBracket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IrtBracket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IrtBracket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IrtBracket value)  $default,){
final _that = this;
switch (_that) {
case _IrtBracket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IrtBracket value)?  $default,){
final _that = this;
switch (_that) {
case _IrtBracket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int from,  int rateBp,  int fixedAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IrtBracket() when $default != null:
return $default(_that.from,_that.rateBp,_that.fixedAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int from,  int rateBp,  int fixedAmount)  $default,) {final _that = this;
switch (_that) {
case _IrtBracket():
return $default(_that.from,_that.rateBp,_that.fixedAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int from,  int rateBp,  int fixedAmount)?  $default,) {final _that = this;
switch (_that) {
case _IrtBracket() when $default != null:
return $default(_that.from,_that.rateBp,_that.fixedAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IrtBracket implements IrtBracket {
  const _IrtBracket({required this.from, required this.rateBp, this.fixedAmount = 0});
  factory _IrtBracket.fromJson(Map<String, dynamic> json) => _$IrtBracketFromJson(json);

/// Limite inferior (cêntimos).
@override final  int from;
/// Taxa marginal em pontos base (1300 = 13%).
@override final  int rateBp;
/// Parcela fixa (cêntimos).
@override@JsonKey() final  int fixedAmount;

/// Create a copy of IrtBracket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IrtBracketCopyWith<_IrtBracket> get copyWith => __$IrtBracketCopyWithImpl<_IrtBracket>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IrtBracketToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IrtBracket&&(identical(other.from, from) || other.from == from)&&(identical(other.rateBp, rateBp) || other.rateBp == rateBp)&&(identical(other.fixedAmount, fixedAmount) || other.fixedAmount == fixedAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,rateBp,fixedAmount);

@override
String toString() {
  return 'IrtBracket(from: $from, rateBp: $rateBp, fixedAmount: $fixedAmount)';
}


}

/// @nodoc
abstract mixin class _$IrtBracketCopyWith<$Res> implements $IrtBracketCopyWith<$Res> {
  factory _$IrtBracketCopyWith(_IrtBracket value, $Res Function(_IrtBracket) _then) = __$IrtBracketCopyWithImpl;
@override @useResult
$Res call({
 int from, int rateBp, int fixedAmount
});




}
/// @nodoc
class __$IrtBracketCopyWithImpl<$Res>
    implements _$IrtBracketCopyWith<$Res> {
  __$IrtBracketCopyWithImpl(this._self, this._then);

  final _IrtBracket _self;
  final $Res Function(_IrtBracket) _then;

/// Create a copy of IrtBracket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? rateBp = null,Object? fixedAmount = null,}) {
  return _then(_IrtBracket(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as int,rateBp: null == rateBp ? _self.rateBp : rateBp // ignore: cast_nullable_to_non_nullable
as int,fixedAmount: null == fixedAmount ? _self.fixedAmount : fixedAmount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PayrollSettings {

/// INSS a cargo do trabalhador, em pontos base (300 = 3%).
 int get inssEmployeeBp;/// INSS a cargo da entidade patronal, em pontos base.
 int get inssEmployerBp; int get vacationDaysPerYear;/// Divisor do salário para o desconto de faltas.
 int get workingDaysPerMonth; List<IrtBracket> get irtBrackets;
/// Create a copy of PayrollSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayrollSettingsCopyWith<PayrollSettings> get copyWith => _$PayrollSettingsCopyWithImpl<PayrollSettings>(this as PayrollSettings, _$identity);

  /// Serializes this PayrollSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayrollSettings&&(identical(other.inssEmployeeBp, inssEmployeeBp) || other.inssEmployeeBp == inssEmployeeBp)&&(identical(other.inssEmployerBp, inssEmployerBp) || other.inssEmployerBp == inssEmployerBp)&&(identical(other.vacationDaysPerYear, vacationDaysPerYear) || other.vacationDaysPerYear == vacationDaysPerYear)&&(identical(other.workingDaysPerMonth, workingDaysPerMonth) || other.workingDaysPerMonth == workingDaysPerMonth)&&const DeepCollectionEquality().equals(other.irtBrackets, irtBrackets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inssEmployeeBp,inssEmployerBp,vacationDaysPerYear,workingDaysPerMonth,const DeepCollectionEquality().hash(irtBrackets));

@override
String toString() {
  return 'PayrollSettings(inssEmployeeBp: $inssEmployeeBp, inssEmployerBp: $inssEmployerBp, vacationDaysPerYear: $vacationDaysPerYear, workingDaysPerMonth: $workingDaysPerMonth, irtBrackets: $irtBrackets)';
}


}

/// @nodoc
abstract mixin class $PayrollSettingsCopyWith<$Res>  {
  factory $PayrollSettingsCopyWith(PayrollSettings value, $Res Function(PayrollSettings) _then) = _$PayrollSettingsCopyWithImpl;
@useResult
$Res call({
 int inssEmployeeBp, int inssEmployerBp, int vacationDaysPerYear, int workingDaysPerMonth, List<IrtBracket> irtBrackets
});




}
/// @nodoc
class _$PayrollSettingsCopyWithImpl<$Res>
    implements $PayrollSettingsCopyWith<$Res> {
  _$PayrollSettingsCopyWithImpl(this._self, this._then);

  final PayrollSettings _self;
  final $Res Function(PayrollSettings) _then;

/// Create a copy of PayrollSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inssEmployeeBp = null,Object? inssEmployerBp = null,Object? vacationDaysPerYear = null,Object? workingDaysPerMonth = null,Object? irtBrackets = null,}) {
  return _then(PayrollSettings(
inssEmployeeBp: null == inssEmployeeBp ? _self.inssEmployeeBp : inssEmployeeBp // ignore: cast_nullable_to_non_nullable
as int,inssEmployerBp: null == inssEmployerBp ? _self.inssEmployerBp : inssEmployerBp // ignore: cast_nullable_to_non_nullable
as int,vacationDaysPerYear: null == vacationDaysPerYear ? _self.vacationDaysPerYear : vacationDaysPerYear // ignore: cast_nullable_to_non_nullable
as int,workingDaysPerMonth: null == workingDaysPerMonth ? _self.workingDaysPerMonth : workingDaysPerMonth // ignore: cast_nullable_to_non_nullable
as int,irtBrackets: null == irtBrackets ? _self.irtBrackets : irtBrackets // ignore: cast_nullable_to_non_nullable
as List<IrtBracket>,
  ));
}

}


/// Adds pattern-matching-related methods to [PayrollSettings].
extension PayrollSettingsPatterns on PayrollSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayrollSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PayrollSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayrollSettings value)  $default,){
final _that = this;
switch (_that) {
case _PayrollSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayrollSettings value)?  $default,){
final _that = this;
switch (_that) {
case _PayrollSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int inssEmployeeBp,  int inssEmployerBp,  int vacationDaysPerYear,  int workingDaysPerMonth,  List<IrtBracket> irtBrackets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PayrollSettings() when $default != null:
return $default(_that.inssEmployeeBp,_that.inssEmployerBp,_that.vacationDaysPerYear,_that.workingDaysPerMonth,_that.irtBrackets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int inssEmployeeBp,  int inssEmployerBp,  int vacationDaysPerYear,  int workingDaysPerMonth,  List<IrtBracket> irtBrackets)  $default,) {final _that = this;
switch (_that) {
case _PayrollSettings():
return $default(_that.inssEmployeeBp,_that.inssEmployerBp,_that.vacationDaysPerYear,_that.workingDaysPerMonth,_that.irtBrackets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int inssEmployeeBp,  int inssEmployerBp,  int vacationDaysPerYear,  int workingDaysPerMonth,  List<IrtBracket> irtBrackets)?  $default,) {final _that = this;
switch (_that) {
case _PayrollSettings() when $default != null:
return $default(_that.inssEmployeeBp,_that.inssEmployerBp,_that.vacationDaysPerYear,_that.workingDaysPerMonth,_that.irtBrackets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PayrollSettings implements PayrollSettings {
  const _PayrollSettings({this.inssEmployeeBp = 300, this.inssEmployerBp = 800, this.vacationDaysPerYear = 22, this.workingDaysPerMonth = 22,  List<IrtBracket> irtBrackets = defaultIrtBrackets}): _irtBrackets = irtBrackets;
  factory _PayrollSettings.fromJson(Map<String, dynamic> json) => _$PayrollSettingsFromJson(json);

/// INSS a cargo do trabalhador, em pontos base (300 = 3%).
@override@JsonKey() final  int inssEmployeeBp;
/// INSS a cargo da entidade patronal, em pontos base.
@override@JsonKey() final  int inssEmployerBp;
@override@JsonKey() final  int vacationDaysPerYear;
/// Divisor do salário para o desconto de faltas.
@override@JsonKey() final  int workingDaysPerMonth;
 final  List<IrtBracket> _irtBrackets;
@override@JsonKey() List<IrtBracket> get irtBrackets {
  if (_irtBrackets is EqualUnmodifiableListView) return _irtBrackets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_irtBrackets);
}


/// Create a copy of PayrollSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayrollSettingsCopyWith<_PayrollSettings> get copyWith => __$PayrollSettingsCopyWithImpl<_PayrollSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PayrollSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayrollSettings&&(identical(other.inssEmployeeBp, inssEmployeeBp) || other.inssEmployeeBp == inssEmployeeBp)&&(identical(other.inssEmployerBp, inssEmployerBp) || other.inssEmployerBp == inssEmployerBp)&&(identical(other.vacationDaysPerYear, vacationDaysPerYear) || other.vacationDaysPerYear == vacationDaysPerYear)&&(identical(other.workingDaysPerMonth, workingDaysPerMonth) || other.workingDaysPerMonth == workingDaysPerMonth)&&const DeepCollectionEquality().equals(other._irtBrackets, _irtBrackets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inssEmployeeBp,inssEmployerBp,vacationDaysPerYear,workingDaysPerMonth,const DeepCollectionEquality().hash(_irtBrackets));

@override
String toString() {
  return 'PayrollSettings(inssEmployeeBp: $inssEmployeeBp, inssEmployerBp: $inssEmployerBp, vacationDaysPerYear: $vacationDaysPerYear, workingDaysPerMonth: $workingDaysPerMonth, irtBrackets: $irtBrackets)';
}


}

/// @nodoc
abstract mixin class _$PayrollSettingsCopyWith<$Res> implements $PayrollSettingsCopyWith<$Res> {
  factory _$PayrollSettingsCopyWith(_PayrollSettings value, $Res Function(_PayrollSettings) _then) = __$PayrollSettingsCopyWithImpl;
@override @useResult
$Res call({
 int inssEmployeeBp, int inssEmployerBp, int vacationDaysPerYear, int workingDaysPerMonth, List<IrtBracket> irtBrackets
});




}
/// @nodoc
class __$PayrollSettingsCopyWithImpl<$Res>
    implements _$PayrollSettingsCopyWith<$Res> {
  __$PayrollSettingsCopyWithImpl(this._self, this._then);

  final _PayrollSettings _self;
  final $Res Function(_PayrollSettings) _then;

/// Create a copy of PayrollSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inssEmployeeBp = null,Object? inssEmployerBp = null,Object? vacationDaysPerYear = null,Object? workingDaysPerMonth = null,Object? irtBrackets = null,}) {
  return _then(_PayrollSettings(
inssEmployeeBp: null == inssEmployeeBp ? _self.inssEmployeeBp : inssEmployeeBp // ignore: cast_nullable_to_non_nullable
as int,inssEmployerBp: null == inssEmployerBp ? _self.inssEmployerBp : inssEmployerBp // ignore: cast_nullable_to_non_nullable
as int,vacationDaysPerYear: null == vacationDaysPerYear ? _self.vacationDaysPerYear : vacationDaysPerYear // ignore: cast_nullable_to_non_nullable
as int,workingDaysPerMonth: null == workingDaysPerMonth ? _self.workingDaysPerMonth : workingDaysPerMonth // ignore: cast_nullable_to_non_nullable
as int,irtBrackets: null == irtBrackets ? _self._irtBrackets : irtBrackets // ignore: cast_nullable_to_non_nullable
as List<IrtBracket>,
  ));
}


}


/// @nodoc
mixin _$Payslip {

 String get id; String get employeeId;/// `AAAA-MM`.
 String get month; int get baseSalary; int get absenceDays; int get absenceDeduction; int get grossPay; int get inssEmployee; int get inssEmployer; int get irt; int get netPay;
/// Create a copy of Payslip
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayslipCopyWith<Payslip> get copyWith => _$PayslipCopyWithImpl<Payslip>(this as Payslip, _$identity);

  /// Serializes this Payslip to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Payslip&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.month, month) || other.month == month)&&(identical(other.baseSalary, baseSalary) || other.baseSalary == baseSalary)&&(identical(other.absenceDays, absenceDays) || other.absenceDays == absenceDays)&&(identical(other.absenceDeduction, absenceDeduction) || other.absenceDeduction == absenceDeduction)&&(identical(other.grossPay, grossPay) || other.grossPay == grossPay)&&(identical(other.inssEmployee, inssEmployee) || other.inssEmployee == inssEmployee)&&(identical(other.inssEmployer, inssEmployer) || other.inssEmployer == inssEmployer)&&(identical(other.irt, irt) || other.irt == irt)&&(identical(other.netPay, netPay) || other.netPay == netPay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeId,month,baseSalary,absenceDays,absenceDeduction,grossPay,inssEmployee,inssEmployer,irt,netPay);

@override
String toString() {
  return 'Payslip(id: $id, employeeId: $employeeId, month: $month, baseSalary: $baseSalary, absenceDays: $absenceDays, absenceDeduction: $absenceDeduction, grossPay: $grossPay, inssEmployee: $inssEmployee, inssEmployer: $inssEmployer, irt: $irt, netPay: $netPay)';
}


}

/// @nodoc
abstract mixin class $PayslipCopyWith<$Res>  {
  factory $PayslipCopyWith(Payslip value, $Res Function(Payslip) _then) = _$PayslipCopyWithImpl;
@useResult
$Res call({
 String id, String employeeId, String month, int baseSalary, int absenceDays, int absenceDeduction, int grossPay, int inssEmployee, int inssEmployer, int irt, int netPay
});




}
/// @nodoc
class _$PayslipCopyWithImpl<$Res>
    implements $PayslipCopyWith<$Res> {
  _$PayslipCopyWithImpl(this._self, this._then);

  final Payslip _self;
  final $Res Function(Payslip) _then;

/// Create a copy of Payslip
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? employeeId = null,Object? month = null,Object? baseSalary = null,Object? absenceDays = null,Object? absenceDeduction = null,Object? grossPay = null,Object? inssEmployee = null,Object? inssEmployer = null,Object? irt = null,Object? netPay = null,}) {
  return _then(Payslip(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,baseSalary: null == baseSalary ? _self.baseSalary : baseSalary // ignore: cast_nullable_to_non_nullable
as int,absenceDays: null == absenceDays ? _self.absenceDays : absenceDays // ignore: cast_nullable_to_non_nullable
as int,absenceDeduction: null == absenceDeduction ? _self.absenceDeduction : absenceDeduction // ignore: cast_nullable_to_non_nullable
as int,grossPay: null == grossPay ? _self.grossPay : grossPay // ignore: cast_nullable_to_non_nullable
as int,inssEmployee: null == inssEmployee ? _self.inssEmployee : inssEmployee // ignore: cast_nullable_to_non_nullable
as int,inssEmployer: null == inssEmployer ? _self.inssEmployer : inssEmployer // ignore: cast_nullable_to_non_nullable
as int,irt: null == irt ? _self.irt : irt // ignore: cast_nullable_to_non_nullable
as int,netPay: null == netPay ? _self.netPay : netPay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Payslip].
extension PayslipPatterns on Payslip {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Payslip value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Payslip() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Payslip value)  $default,){
final _that = this;
switch (_that) {
case _Payslip():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Payslip value)?  $default,){
final _that = this;
switch (_that) {
case _Payslip() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String employeeId,  String month,  int baseSalary,  int absenceDays,  int absenceDeduction,  int grossPay,  int inssEmployee,  int inssEmployer,  int irt,  int netPay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Payslip() when $default != null:
return $default(_that.id,_that.employeeId,_that.month,_that.baseSalary,_that.absenceDays,_that.absenceDeduction,_that.grossPay,_that.inssEmployee,_that.inssEmployer,_that.irt,_that.netPay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String employeeId,  String month,  int baseSalary,  int absenceDays,  int absenceDeduction,  int grossPay,  int inssEmployee,  int inssEmployer,  int irt,  int netPay)  $default,) {final _that = this;
switch (_that) {
case _Payslip():
return $default(_that.id,_that.employeeId,_that.month,_that.baseSalary,_that.absenceDays,_that.absenceDeduction,_that.grossPay,_that.inssEmployee,_that.inssEmployer,_that.irt,_that.netPay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String employeeId,  String month,  int baseSalary,  int absenceDays,  int absenceDeduction,  int grossPay,  int inssEmployee,  int inssEmployer,  int irt,  int netPay)?  $default,) {final _that = this;
switch (_that) {
case _Payslip() when $default != null:
return $default(_that.id,_that.employeeId,_that.month,_that.baseSalary,_that.absenceDays,_that.absenceDeduction,_that.grossPay,_that.inssEmployee,_that.inssEmployer,_that.irt,_that.netPay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Payslip implements Payslip {
  const _Payslip({required this.id, required this.employeeId, required this.month, required this.baseSalary, this.absenceDays = 0, this.absenceDeduction = 0, required this.grossPay, required this.inssEmployee, required this.inssEmployer, required this.irt, required this.netPay});
  factory _Payslip.fromJson(Map<String, dynamic> json) => _$PayslipFromJson(json);

@override final  String id;
@override final  String employeeId;
/// `AAAA-MM`.
@override final  String month;
@override final  int baseSalary;
@override@JsonKey() final  int absenceDays;
@override@JsonKey() final  int absenceDeduction;
@override final  int grossPay;
@override final  int inssEmployee;
@override final  int inssEmployer;
@override final  int irt;
@override final  int netPay;

/// Create a copy of Payslip
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayslipCopyWith<_Payslip> get copyWith => __$PayslipCopyWithImpl<_Payslip>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PayslipToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Payslip&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.month, month) || other.month == month)&&(identical(other.baseSalary, baseSalary) || other.baseSalary == baseSalary)&&(identical(other.absenceDays, absenceDays) || other.absenceDays == absenceDays)&&(identical(other.absenceDeduction, absenceDeduction) || other.absenceDeduction == absenceDeduction)&&(identical(other.grossPay, grossPay) || other.grossPay == grossPay)&&(identical(other.inssEmployee, inssEmployee) || other.inssEmployee == inssEmployee)&&(identical(other.inssEmployer, inssEmployer) || other.inssEmployer == inssEmployer)&&(identical(other.irt, irt) || other.irt == irt)&&(identical(other.netPay, netPay) || other.netPay == netPay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeId,month,baseSalary,absenceDays,absenceDeduction,grossPay,inssEmployee,inssEmployer,irt,netPay);

@override
String toString() {
  return 'Payslip(id: $id, employeeId: $employeeId, month: $month, baseSalary: $baseSalary, absenceDays: $absenceDays, absenceDeduction: $absenceDeduction, grossPay: $grossPay, inssEmployee: $inssEmployee, inssEmployer: $inssEmployer, irt: $irt, netPay: $netPay)';
}


}

/// @nodoc
abstract mixin class _$PayslipCopyWith<$Res> implements $PayslipCopyWith<$Res> {
  factory _$PayslipCopyWith(_Payslip value, $Res Function(_Payslip) _then) = __$PayslipCopyWithImpl;
@override @useResult
$Res call({
 String id, String employeeId, String month, int baseSalary, int absenceDays, int absenceDeduction, int grossPay, int inssEmployee, int inssEmployer, int irt, int netPay
});




}
/// @nodoc
class __$PayslipCopyWithImpl<$Res>
    implements _$PayslipCopyWith<$Res> {
  __$PayslipCopyWithImpl(this._self, this._then);

  final _Payslip _self;
  final $Res Function(_Payslip) _then;

/// Create a copy of Payslip
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? employeeId = null,Object? month = null,Object? baseSalary = null,Object? absenceDays = null,Object? absenceDeduction = null,Object? grossPay = null,Object? inssEmployee = null,Object? inssEmployer = null,Object? irt = null,Object? netPay = null,}) {
  return _then(_Payslip(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,baseSalary: null == baseSalary ? _self.baseSalary : baseSalary // ignore: cast_nullable_to_non_nullable
as int,absenceDays: null == absenceDays ? _self.absenceDays : absenceDays // ignore: cast_nullable_to_non_nullable
as int,absenceDeduction: null == absenceDeduction ? _self.absenceDeduction : absenceDeduction // ignore: cast_nullable_to_non_nullable
as int,grossPay: null == grossPay ? _self.grossPay : grossPay // ignore: cast_nullable_to_non_nullable
as int,inssEmployee: null == inssEmployee ? _self.inssEmployee : inssEmployee // ignore: cast_nullable_to_non_nullable
as int,inssEmployer: null == inssEmployer ? _self.inssEmployer : inssEmployer // ignore: cast_nullable_to_non_nullable
as int,irt: null == irt ? _self.irt : irt // ignore: cast_nullable_to_non_nullable
as int,netPay: null == netPay ? _self.netPay : netPay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PayrollRunSummary {

 String get month; int get count; int get totalGross; int get totalNet;
/// Create a copy of PayrollRunSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayrollRunSummaryCopyWith<PayrollRunSummary> get copyWith => _$PayrollRunSummaryCopyWithImpl<PayrollRunSummary>(this as PayrollRunSummary, _$identity);

  /// Serializes this PayrollRunSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayrollRunSummary&&(identical(other.month, month) || other.month == month)&&(identical(other.count, count) || other.count == count)&&(identical(other.totalGross, totalGross) || other.totalGross == totalGross)&&(identical(other.totalNet, totalNet) || other.totalNet == totalNet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,count,totalGross,totalNet);

@override
String toString() {
  return 'PayrollRunSummary(month: $month, count: $count, totalGross: $totalGross, totalNet: $totalNet)';
}


}

/// @nodoc
abstract mixin class $PayrollRunSummaryCopyWith<$Res>  {
  factory $PayrollRunSummaryCopyWith(PayrollRunSummary value, $Res Function(PayrollRunSummary) _then) = _$PayrollRunSummaryCopyWithImpl;
@useResult
$Res call({
 String month, int count, int totalGross, int totalNet
});




}
/// @nodoc
class _$PayrollRunSummaryCopyWithImpl<$Res>
    implements $PayrollRunSummaryCopyWith<$Res> {
  _$PayrollRunSummaryCopyWithImpl(this._self, this._then);

  final PayrollRunSummary _self;
  final $Res Function(PayrollRunSummary) _then;

/// Create a copy of PayrollRunSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? count = null,Object? totalGross = null,Object? totalNet = null,}) {
  return _then(PayrollRunSummary(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,totalGross: null == totalGross ? _self.totalGross : totalGross // ignore: cast_nullable_to_non_nullable
as int,totalNet: null == totalNet ? _self.totalNet : totalNet // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PayrollRunSummary].
extension PayrollRunSummaryPatterns on PayrollRunSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayrollRunSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PayrollRunSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayrollRunSummary value)  $default,){
final _that = this;
switch (_that) {
case _PayrollRunSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayrollRunSummary value)?  $default,){
final _that = this;
switch (_that) {
case _PayrollRunSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String month,  int count,  int totalGross,  int totalNet)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PayrollRunSummary() when $default != null:
return $default(_that.month,_that.count,_that.totalGross,_that.totalNet);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String month,  int count,  int totalGross,  int totalNet)  $default,) {final _that = this;
switch (_that) {
case _PayrollRunSummary():
return $default(_that.month,_that.count,_that.totalGross,_that.totalNet);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String month,  int count,  int totalGross,  int totalNet)?  $default,) {final _that = this;
switch (_that) {
case _PayrollRunSummary() when $default != null:
return $default(_that.month,_that.count,_that.totalGross,_that.totalNet);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PayrollRunSummary implements PayrollRunSummary {
  const _PayrollRunSummary({required this.month, required this.count, required this.totalGross, required this.totalNet});
  factory _PayrollRunSummary.fromJson(Map<String, dynamic> json) => _$PayrollRunSummaryFromJson(json);

@override final  String month;
@override final  int count;
@override final  int totalGross;
@override final  int totalNet;

/// Create a copy of PayrollRunSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayrollRunSummaryCopyWith<_PayrollRunSummary> get copyWith => __$PayrollRunSummaryCopyWithImpl<_PayrollRunSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PayrollRunSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayrollRunSummary&&(identical(other.month, month) || other.month == month)&&(identical(other.count, count) || other.count == count)&&(identical(other.totalGross, totalGross) || other.totalGross == totalGross)&&(identical(other.totalNet, totalNet) || other.totalNet == totalNet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,count,totalGross,totalNet);

@override
String toString() {
  return 'PayrollRunSummary(month: $month, count: $count, totalGross: $totalGross, totalNet: $totalNet)';
}


}

/// @nodoc
abstract mixin class _$PayrollRunSummaryCopyWith<$Res> implements $PayrollRunSummaryCopyWith<$Res> {
  factory _$PayrollRunSummaryCopyWith(_PayrollRunSummary value, $Res Function(_PayrollRunSummary) _then) = __$PayrollRunSummaryCopyWithImpl;
@override @useResult
$Res call({
 String month, int count, int totalGross, int totalNet
});




}
/// @nodoc
class __$PayrollRunSummaryCopyWithImpl<$Res>
    implements _$PayrollRunSummaryCopyWith<$Res> {
  __$PayrollRunSummaryCopyWithImpl(this._self, this._then);

  final _PayrollRunSummary _self;
  final $Res Function(_PayrollRunSummary) _then;

/// Create a copy of PayrollRunSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? count = null,Object? totalGross = null,Object? totalNet = null,}) {
  return _then(_PayrollRunSummary(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,totalGross: null == totalGross ? _self.totalGross : totalGross // ignore: cast_nullable_to_non_nullable
as int,totalNet: null == totalNet ? _self.totalNet : totalNet // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
