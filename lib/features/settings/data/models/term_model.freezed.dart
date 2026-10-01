// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'term_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TermModel {

 String get id; String get academicYearId; String get name; int get order;@DateOnlyConverter() DateTime get startDate;@DateOnlyConverter() DateTime get endDate;/// Último dia para lançar notas neste período.
@DateOnlyConverter() DateTime get gradesDeadline; TermStatus get status;/// Quando foi fechado pela última vez; `null` se nunca foi aberto/fechado
/// (abrir um período já fechado é uma reabertura e exige `approve`).
@UtcDateTimeConverter() DateTime? get closedAt;
/// Create a copy of TermModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TermModelCopyWith<TermModel> get copyWith => _$TermModelCopyWithImpl<TermModel>(this as TermModel, _$identity);

  /// Serializes this TermModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TermModel&&(identical(other.id, id) || other.id == id)&&(identical(other.academicYearId, academicYearId) || other.academicYearId == academicYearId)&&(identical(other.name, name) || other.name == name)&&(identical(other.order, order) || other.order == order)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.gradesDeadline, gradesDeadline) || other.gradesDeadline == gradesDeadline)&&(identical(other.status, status) || other.status == status)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,academicYearId,name,order,startDate,endDate,gradesDeadline,status,closedAt);

@override
String toString() {
  return 'TermModel(id: $id, academicYearId: $academicYearId, name: $name, order: $order, startDate: $startDate, endDate: $endDate, gradesDeadline: $gradesDeadline, status: $status, closedAt: $closedAt)';
}


}

/// @nodoc
abstract mixin class $TermModelCopyWith<$Res>  {
  factory $TermModelCopyWith(TermModel value, $Res Function(TermModel) _then) = _$TermModelCopyWithImpl;
@useResult
$Res call({
 String id, String academicYearId, String name, int order,@DateOnlyConverter() DateTime startDate,@DateOnlyConverter() DateTime endDate,@DateOnlyConverter() DateTime gradesDeadline, TermStatus status,@UtcDateTimeConverter() DateTime? closedAt
});




}
/// @nodoc
class _$TermModelCopyWithImpl<$Res>
    implements $TermModelCopyWith<$Res> {
  _$TermModelCopyWithImpl(this._self, this._then);

  final TermModel _self;
  final $Res Function(TermModel) _then;

/// Create a copy of TermModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? academicYearId = null,Object? name = null,Object? order = null,Object? startDate = null,Object? endDate = null,Object? gradesDeadline = null,Object? status = null,Object? closedAt = freezed,}) {
  return _then(TermModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,academicYearId: null == academicYearId ? _self.academicYearId : academicYearId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,gradesDeadline: null == gradesDeadline ? _self.gradesDeadline : gradesDeadline // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TermStatus,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TermModel].
extension TermModelPatterns on TermModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TermModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TermModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TermModel value)  $default,){
final _that = this;
switch (_that) {
case _TermModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TermModel value)?  $default,){
final _that = this;
switch (_that) {
case _TermModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String academicYearId,  String name,  int order, @DateOnlyConverter()  DateTime startDate, @DateOnlyConverter()  DateTime endDate, @DateOnlyConverter()  DateTime gradesDeadline,  TermStatus status, @UtcDateTimeConverter()  DateTime? closedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TermModel() when $default != null:
return $default(_that.id,_that.academicYearId,_that.name,_that.order,_that.startDate,_that.endDate,_that.gradesDeadline,_that.status,_that.closedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String academicYearId,  String name,  int order, @DateOnlyConverter()  DateTime startDate, @DateOnlyConverter()  DateTime endDate, @DateOnlyConverter()  DateTime gradesDeadline,  TermStatus status, @UtcDateTimeConverter()  DateTime? closedAt)  $default,) {final _that = this;
switch (_that) {
case _TermModel():
return $default(_that.id,_that.academicYearId,_that.name,_that.order,_that.startDate,_that.endDate,_that.gradesDeadline,_that.status,_that.closedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String academicYearId,  String name,  int order, @DateOnlyConverter()  DateTime startDate, @DateOnlyConverter()  DateTime endDate, @DateOnlyConverter()  DateTime gradesDeadline,  TermStatus status, @UtcDateTimeConverter()  DateTime? closedAt)?  $default,) {final _that = this;
switch (_that) {
case _TermModel() when $default != null:
return $default(_that.id,_that.academicYearId,_that.name,_that.order,_that.startDate,_that.endDate,_that.gradesDeadline,_that.status,_that.closedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TermModel implements TermModel {
  const _TermModel({required this.id, required this.academicYearId, required this.name, required this.order, @DateOnlyConverter() required this.startDate, @DateOnlyConverter() required this.endDate, @DateOnlyConverter() required this.gradesDeadline, required this.status, @UtcDateTimeConverter() this.closedAt});
  factory _TermModel.fromJson(Map<String, dynamic> json) => _$TermModelFromJson(json);

@override final  String id;
@override final  String academicYearId;
@override final  String name;
@override final  int order;
@override@DateOnlyConverter() final  DateTime startDate;
@override@DateOnlyConverter() final  DateTime endDate;
/// Último dia para lançar notas neste período.
@override@DateOnlyConverter() final  DateTime gradesDeadline;
@override final  TermStatus status;
/// Quando foi fechado pela última vez; `null` se nunca foi aberto/fechado
/// (abrir um período já fechado é uma reabertura e exige `approve`).
@override@UtcDateTimeConverter() final  DateTime? closedAt;

/// Create a copy of TermModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TermModelCopyWith<_TermModel> get copyWith => __$TermModelCopyWithImpl<_TermModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TermModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TermModel&&(identical(other.id, id) || other.id == id)&&(identical(other.academicYearId, academicYearId) || other.academicYearId == academicYearId)&&(identical(other.name, name) || other.name == name)&&(identical(other.order, order) || other.order == order)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.gradesDeadline, gradesDeadline) || other.gradesDeadline == gradesDeadline)&&(identical(other.status, status) || other.status == status)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,academicYearId,name,order,startDate,endDate,gradesDeadline,status,closedAt);

@override
String toString() {
  return 'TermModel(id: $id, academicYearId: $academicYearId, name: $name, order: $order, startDate: $startDate, endDate: $endDate, gradesDeadline: $gradesDeadline, status: $status, closedAt: $closedAt)';
}


}

/// @nodoc
abstract mixin class _$TermModelCopyWith<$Res> implements $TermModelCopyWith<$Res> {
  factory _$TermModelCopyWith(_TermModel value, $Res Function(_TermModel) _then) = __$TermModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String academicYearId, String name, int order,@DateOnlyConverter() DateTime startDate,@DateOnlyConverter() DateTime endDate,@DateOnlyConverter() DateTime gradesDeadline, TermStatus status,@UtcDateTimeConverter() DateTime? closedAt
});




}
/// @nodoc
class __$TermModelCopyWithImpl<$Res>
    implements _$TermModelCopyWith<$Res> {
  __$TermModelCopyWithImpl(this._self, this._then);

  final _TermModel _self;
  final $Res Function(_TermModel) _then;

/// Create a copy of TermModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? academicYearId = null,Object? name = null,Object? order = null,Object? startDate = null,Object? endDate = null,Object? gradesDeadline = null,Object? status = null,Object? closedAt = freezed,}) {
  return _then(_TermModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,academicYearId: null == academicYearId ? _self.academicYearId : academicYearId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,gradesDeadline: null == gradesDeadline ? _self.gradesDeadline : gradesDeadline // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TermStatus,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
