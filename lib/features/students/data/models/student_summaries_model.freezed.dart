// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_summaries_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubjectGrades {

 String get subject; double? get term1; double? get term2; double? get term3;
/// Create a copy of SubjectGrades
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubjectGradesCopyWith<SubjectGrades> get copyWith => _$SubjectGradesCopyWithImpl<SubjectGrades>(this as SubjectGrades, _$identity);

  /// Serializes this SubjectGrades to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubjectGrades&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.term1, term1) || other.term1 == term1)&&(identical(other.term2, term2) || other.term2 == term2)&&(identical(other.term3, term3) || other.term3 == term3));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subject,term1,term2,term3);

@override
String toString() {
  return 'SubjectGrades(subject: $subject, term1: $term1, term2: $term2, term3: $term3)';
}


}

/// @nodoc
abstract mixin class $SubjectGradesCopyWith<$Res>  {
  factory $SubjectGradesCopyWith(SubjectGrades value, $Res Function(SubjectGrades) _then) = _$SubjectGradesCopyWithImpl;
@useResult
$Res call({
 String subject, double? term1, double? term2, double? term3
});




}
/// @nodoc
class _$SubjectGradesCopyWithImpl<$Res>
    implements $SubjectGradesCopyWith<$Res> {
  _$SubjectGradesCopyWithImpl(this._self, this._then);

  final SubjectGrades _self;
  final $Res Function(SubjectGrades) _then;

/// Create a copy of SubjectGrades
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subject = null,Object? term1 = freezed,Object? term2 = freezed,Object? term3 = freezed,}) {
  return _then(SubjectGrades(
subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,term1: freezed == term1 ? _self.term1 : term1 // ignore: cast_nullable_to_non_nullable
as double?,term2: freezed == term2 ? _self.term2 : term2 // ignore: cast_nullable_to_non_nullable
as double?,term3: freezed == term3 ? _self.term3 : term3 // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubjectGrades].
extension SubjectGradesPatterns on SubjectGrades {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubjectGrades value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubjectGrades() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubjectGrades value)  $default,){
final _that = this;
switch (_that) {
case _SubjectGrades():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubjectGrades value)?  $default,){
final _that = this;
switch (_that) {
case _SubjectGrades() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subject,  double? term1,  double? term2,  double? term3)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubjectGrades() when $default != null:
return $default(_that.subject,_that.term1,_that.term2,_that.term3);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subject,  double? term1,  double? term2,  double? term3)  $default,) {final _that = this;
switch (_that) {
case _SubjectGrades():
return $default(_that.subject,_that.term1,_that.term2,_that.term3);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subject,  double? term1,  double? term2,  double? term3)?  $default,) {final _that = this;
switch (_that) {
case _SubjectGrades() when $default != null:
return $default(_that.subject,_that.term1,_that.term2,_that.term3);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubjectGrades implements SubjectGrades {
  const _SubjectGrades({required this.subject, this.term1, this.term2, this.term3});
  factory _SubjectGrades.fromJson(Map<String, dynamic> json) => _$SubjectGradesFromJson(json);

@override final  String subject;
@override final  double? term1;
@override final  double? term2;
@override final  double? term3;

/// Create a copy of SubjectGrades
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubjectGradesCopyWith<_SubjectGrades> get copyWith => __$SubjectGradesCopyWithImpl<_SubjectGrades>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubjectGradesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubjectGrades&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.term1, term1) || other.term1 == term1)&&(identical(other.term2, term2) || other.term2 == term2)&&(identical(other.term3, term3) || other.term3 == term3));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subject,term1,term2,term3);

@override
String toString() {
  return 'SubjectGrades(subject: $subject, term1: $term1, term2: $term2, term3: $term3)';
}


}

/// @nodoc
abstract mixin class _$SubjectGradesCopyWith<$Res> implements $SubjectGradesCopyWith<$Res> {
  factory _$SubjectGradesCopyWith(_SubjectGrades value, $Res Function(_SubjectGrades) _then) = __$SubjectGradesCopyWithImpl;
@override @useResult
$Res call({
 String subject, double? term1, double? term2, double? term3
});




}
/// @nodoc
class __$SubjectGradesCopyWithImpl<$Res>
    implements _$SubjectGradesCopyWith<$Res> {
  __$SubjectGradesCopyWithImpl(this._self, this._then);

  final _SubjectGrades _self;
  final $Res Function(_SubjectGrades) _then;

/// Create a copy of SubjectGrades
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subject = null,Object? term1 = freezed,Object? term2 = freezed,Object? term3 = freezed,}) {
  return _then(_SubjectGrades(
subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,term1: freezed == term1 ? _self.term1 : term1 // ignore: cast_nullable_to_non_nullable
as double?,term2: freezed == term2 ? _self.term2 : term2 // ignore: cast_nullable_to_non_nullable
as double?,term3: freezed == term3 ? _self.term3 : term3 // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$BulletinRef {

 String get id; String get label;@DateOnlyConverter() DateTime get issuedOn;
/// Create a copy of BulletinRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulletinRefCopyWith<BulletinRef> get copyWith => _$BulletinRefCopyWithImpl<BulletinRef>(this as BulletinRef, _$identity);

  /// Serializes this BulletinRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulletinRef&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.issuedOn, issuedOn) || other.issuedOn == issuedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,issuedOn);

@override
String toString() {
  return 'BulletinRef(id: $id, label: $label, issuedOn: $issuedOn)';
}


}

/// @nodoc
abstract mixin class $BulletinRefCopyWith<$Res>  {
  factory $BulletinRefCopyWith(BulletinRef value, $Res Function(BulletinRef) _then) = _$BulletinRefCopyWithImpl;
@useResult
$Res call({
 String id, String label,@DateOnlyConverter() DateTime issuedOn
});




}
/// @nodoc
class _$BulletinRefCopyWithImpl<$Res>
    implements $BulletinRefCopyWith<$Res> {
  _$BulletinRefCopyWithImpl(this._self, this._then);

  final BulletinRef _self;
  final $Res Function(BulletinRef) _then;

/// Create a copy of BulletinRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? issuedOn = null,}) {
  return _then(BulletinRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,issuedOn: null == issuedOn ? _self.issuedOn : issuedOn // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [BulletinRef].
extension BulletinRefPatterns on BulletinRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulletinRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulletinRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulletinRef value)  $default,){
final _that = this;
switch (_that) {
case _BulletinRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulletinRef value)?  $default,){
final _that = this;
switch (_that) {
case _BulletinRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label, @DateOnlyConverter()  DateTime issuedOn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulletinRef() when $default != null:
return $default(_that.id,_that.label,_that.issuedOn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label, @DateOnlyConverter()  DateTime issuedOn)  $default,) {final _that = this;
switch (_that) {
case _BulletinRef():
return $default(_that.id,_that.label,_that.issuedOn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label, @DateOnlyConverter()  DateTime issuedOn)?  $default,) {final _that = this;
switch (_that) {
case _BulletinRef() when $default != null:
return $default(_that.id,_that.label,_that.issuedOn);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BulletinRef implements BulletinRef {
  const _BulletinRef({required this.id, required this.label, @DateOnlyConverter() required this.issuedOn});
  factory _BulletinRef.fromJson(Map<String, dynamic> json) => _$BulletinRefFromJson(json);

@override final  String id;
@override final  String label;
@override@DateOnlyConverter() final  DateTime issuedOn;

/// Create a copy of BulletinRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulletinRefCopyWith<_BulletinRef> get copyWith => __$BulletinRefCopyWithImpl<_BulletinRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulletinRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulletinRef&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.issuedOn, issuedOn) || other.issuedOn == issuedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,issuedOn);

@override
String toString() {
  return 'BulletinRef(id: $id, label: $label, issuedOn: $issuedOn)';
}


}

/// @nodoc
abstract mixin class _$BulletinRefCopyWith<$Res> implements $BulletinRefCopyWith<$Res> {
  factory _$BulletinRefCopyWith(_BulletinRef value, $Res Function(_BulletinRef) _then) = __$BulletinRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String label,@DateOnlyConverter() DateTime issuedOn
});




}
/// @nodoc
class __$BulletinRefCopyWithImpl<$Res>
    implements _$BulletinRefCopyWith<$Res> {
  __$BulletinRefCopyWithImpl(this._self, this._then);

  final _BulletinRef _self;
  final $Res Function(_BulletinRef) _then;

/// Create a copy of BulletinRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? issuedOn = null,}) {
  return _then(_BulletinRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,issuedOn: null == issuedOn ? _self.issuedOn : issuedOn // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$StudentGradesSummary {

 List<SubjectGrades> get subjects; List<BulletinRef> get bulletins;
/// Create a copy of StudentGradesSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentGradesSummaryCopyWith<StudentGradesSummary> get copyWith => _$StudentGradesSummaryCopyWithImpl<StudentGradesSummary>(this as StudentGradesSummary, _$identity);

  /// Serializes this StudentGradesSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentGradesSummary&&const DeepCollectionEquality().equals(other.subjects, subjects)&&const DeepCollectionEquality().equals(other.bulletins, bulletins));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(subjects),const DeepCollectionEquality().hash(bulletins));

@override
String toString() {
  return 'StudentGradesSummary(subjects: $subjects, bulletins: $bulletins)';
}


}

/// @nodoc
abstract mixin class $StudentGradesSummaryCopyWith<$Res>  {
  factory $StudentGradesSummaryCopyWith(StudentGradesSummary value, $Res Function(StudentGradesSummary) _then) = _$StudentGradesSummaryCopyWithImpl;
@useResult
$Res call({
 List<SubjectGrades> subjects, List<BulletinRef> bulletins
});




}
/// @nodoc
class _$StudentGradesSummaryCopyWithImpl<$Res>
    implements $StudentGradesSummaryCopyWith<$Res> {
  _$StudentGradesSummaryCopyWithImpl(this._self, this._then);

  final StudentGradesSummary _self;
  final $Res Function(StudentGradesSummary) _then;

/// Create a copy of StudentGradesSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subjects = null,Object? bulletins = null,}) {
  return _then(StudentGradesSummary(
subjects: null == subjects ? _self.subjects : subjects // ignore: cast_nullable_to_non_nullable
as List<SubjectGrades>,bulletins: null == bulletins ? _self.bulletins : bulletins // ignore: cast_nullable_to_non_nullable
as List<BulletinRef>,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentGradesSummary].
extension StudentGradesSummaryPatterns on StudentGradesSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentGradesSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentGradesSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentGradesSummary value)  $default,){
final _that = this;
switch (_that) {
case _StudentGradesSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentGradesSummary value)?  $default,){
final _that = this;
switch (_that) {
case _StudentGradesSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SubjectGrades> subjects,  List<BulletinRef> bulletins)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentGradesSummary() when $default != null:
return $default(_that.subjects,_that.bulletins);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SubjectGrades> subjects,  List<BulletinRef> bulletins)  $default,) {final _that = this;
switch (_that) {
case _StudentGradesSummary():
return $default(_that.subjects,_that.bulletins);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SubjectGrades> subjects,  List<BulletinRef> bulletins)?  $default,) {final _that = this;
switch (_that) {
case _StudentGradesSummary() when $default != null:
return $default(_that.subjects,_that.bulletins);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _StudentGradesSummary implements StudentGradesSummary {
  const _StudentGradesSummary({ List<SubjectGrades> subjects = const <SubjectGrades>[],  List<BulletinRef> bulletins = const <BulletinRef>[]}): _subjects = subjects,_bulletins = bulletins;
  factory _StudentGradesSummary.fromJson(Map<String, dynamic> json) => _$StudentGradesSummaryFromJson(json);

 final  List<SubjectGrades> _subjects;
@override@JsonKey() List<SubjectGrades> get subjects {
  if (_subjects is EqualUnmodifiableListView) return _subjects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subjects);
}

 final  List<BulletinRef> _bulletins;
@override@JsonKey() List<BulletinRef> get bulletins {
  if (_bulletins is EqualUnmodifiableListView) return _bulletins;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bulletins);
}


/// Create a copy of StudentGradesSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentGradesSummaryCopyWith<_StudentGradesSummary> get copyWith => __$StudentGradesSummaryCopyWithImpl<_StudentGradesSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentGradesSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentGradesSummary&&const DeepCollectionEquality().equals(other._subjects, _subjects)&&const DeepCollectionEquality().equals(other._bulletins, _bulletins));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_subjects),const DeepCollectionEquality().hash(_bulletins));

@override
String toString() {
  return 'StudentGradesSummary(subjects: $subjects, bulletins: $bulletins)';
}


}

/// @nodoc
abstract mixin class _$StudentGradesSummaryCopyWith<$Res> implements $StudentGradesSummaryCopyWith<$Res> {
  factory _$StudentGradesSummaryCopyWith(_StudentGradesSummary value, $Res Function(_StudentGradesSummary) _then) = __$StudentGradesSummaryCopyWithImpl;
@override @useResult
$Res call({
 List<SubjectGrades> subjects, List<BulletinRef> bulletins
});




}
/// @nodoc
class __$StudentGradesSummaryCopyWithImpl<$Res>
    implements _$StudentGradesSummaryCopyWith<$Res> {
  __$StudentGradesSummaryCopyWithImpl(this._self, this._then);

  final _StudentGradesSummary _self;
  final $Res Function(_StudentGradesSummary) _then;

/// Create a copy of StudentGradesSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subjects = null,Object? bulletins = null,}) {
  return _then(_StudentGradesSummary(
subjects: null == subjects ? _self._subjects : subjects // ignore: cast_nullable_to_non_nullable
as List<SubjectGrades>,bulletins: null == bulletins ? _self._bulletins : bulletins // ignore: cast_nullable_to_non_nullable
as List<BulletinRef>,
  ));
}


}


/// @nodoc
mixin _$AttendanceRecord {

@DateOnlyConverter() DateTime get date; AttendanceKind get kind; String? get note;
/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceRecordCopyWith<AttendanceRecord> get copyWith => _$AttendanceRecordCopyWithImpl<AttendanceRecord>(this as AttendanceRecord, _$identity);

  /// Serializes this AttendanceRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceRecord&&(identical(other.date, date) || other.date == date)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,kind,note);

@override
String toString() {
  return 'AttendanceRecord(date: $date, kind: $kind, note: $note)';
}


}

/// @nodoc
abstract mixin class $AttendanceRecordCopyWith<$Res>  {
  factory $AttendanceRecordCopyWith(AttendanceRecord value, $Res Function(AttendanceRecord) _then) = _$AttendanceRecordCopyWithImpl;
@useResult
$Res call({
@DateOnlyConverter() DateTime date, AttendanceKind kind, String? note
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
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? kind = null,Object? note = freezed,}) {
  return _then(AttendanceRecord(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as AttendanceKind,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date,  AttendanceKind kind,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
return $default(_that.date,_that.kind,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date,  AttendanceKind kind,  String? note)  $default,) {final _that = this;
switch (_that) {
case _AttendanceRecord():
return $default(_that.date,_that.kind,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DateOnlyConverter()  DateTime date,  AttendanceKind kind,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
return $default(_that.date,_that.kind,_that.note);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AttendanceRecord implements AttendanceRecord {
  const _AttendanceRecord({@DateOnlyConverter() required this.date, required this.kind, this.note});
  factory _AttendanceRecord.fromJson(Map<String, dynamic> json) => _$AttendanceRecordFromJson(json);

@override@DateOnlyConverter() final  DateTime date;
@override final  AttendanceKind kind;
@override final  String? note;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceRecord&&(identical(other.date, date) || other.date == date)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,kind,note);

@override
String toString() {
  return 'AttendanceRecord(date: $date, kind: $kind, note: $note)';
}


}

/// @nodoc
abstract mixin class _$AttendanceRecordCopyWith<$Res> implements $AttendanceRecordCopyWith<$Res> {
  factory _$AttendanceRecordCopyWith(_AttendanceRecord value, $Res Function(_AttendanceRecord) _then) = __$AttendanceRecordCopyWithImpl;
@override @useResult
$Res call({
@DateOnlyConverter() DateTime date, AttendanceKind kind, String? note
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
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? kind = null,Object? note = freezed,}) {
  return _then(_AttendanceRecord(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as AttendanceKind,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StudentAttendanceSummary {

 List<AttendanceRecord> get records;
/// Create a copy of StudentAttendanceSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentAttendanceSummaryCopyWith<StudentAttendanceSummary> get copyWith => _$StudentAttendanceSummaryCopyWithImpl<StudentAttendanceSummary>(this as StudentAttendanceSummary, _$identity);

  /// Serializes this StudentAttendanceSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentAttendanceSummary&&const DeepCollectionEquality().equals(other.records, records));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(records));

@override
String toString() {
  return 'StudentAttendanceSummary(records: $records)';
}


}

/// @nodoc
abstract mixin class $StudentAttendanceSummaryCopyWith<$Res>  {
  factory $StudentAttendanceSummaryCopyWith(StudentAttendanceSummary value, $Res Function(StudentAttendanceSummary) _then) = _$StudentAttendanceSummaryCopyWithImpl;
@useResult
$Res call({
 List<AttendanceRecord> records
});




}
/// @nodoc
class _$StudentAttendanceSummaryCopyWithImpl<$Res>
    implements $StudentAttendanceSummaryCopyWith<$Res> {
  _$StudentAttendanceSummaryCopyWithImpl(this._self, this._then);

  final StudentAttendanceSummary _self;
  final $Res Function(StudentAttendanceSummary) _then;

/// Create a copy of StudentAttendanceSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? records = null,}) {
  return _then(StudentAttendanceSummary(
records: null == records ? _self.records : records // ignore: cast_nullable_to_non_nullable
as List<AttendanceRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentAttendanceSummary].
extension StudentAttendanceSummaryPatterns on StudentAttendanceSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentAttendanceSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentAttendanceSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentAttendanceSummary value)  $default,){
final _that = this;
switch (_that) {
case _StudentAttendanceSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentAttendanceSummary value)?  $default,){
final _that = this;
switch (_that) {
case _StudentAttendanceSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AttendanceRecord> records)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentAttendanceSummary() when $default != null:
return $default(_that.records);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AttendanceRecord> records)  $default,) {final _that = this;
switch (_that) {
case _StudentAttendanceSummary():
return $default(_that.records);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AttendanceRecord> records)?  $default,) {final _that = this;
switch (_that) {
case _StudentAttendanceSummary() when $default != null:
return $default(_that.records);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _StudentAttendanceSummary implements StudentAttendanceSummary {
  const _StudentAttendanceSummary({ List<AttendanceRecord> records = const <AttendanceRecord>[]}): _records = records;
  factory _StudentAttendanceSummary.fromJson(Map<String, dynamic> json) => _$StudentAttendanceSummaryFromJson(json);

 final  List<AttendanceRecord> _records;
@override@JsonKey() List<AttendanceRecord> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}


/// Create a copy of StudentAttendanceSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentAttendanceSummaryCopyWith<_StudentAttendanceSummary> get copyWith => __$StudentAttendanceSummaryCopyWithImpl<_StudentAttendanceSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentAttendanceSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentAttendanceSummary&&const DeepCollectionEquality().equals(other._records, _records));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_records));

@override
String toString() {
  return 'StudentAttendanceSummary(records: $records)';
}


}

/// @nodoc
abstract mixin class _$StudentAttendanceSummaryCopyWith<$Res> implements $StudentAttendanceSummaryCopyWith<$Res> {
  factory _$StudentAttendanceSummaryCopyWith(_StudentAttendanceSummary value, $Res Function(_StudentAttendanceSummary) _then) = __$StudentAttendanceSummaryCopyWithImpl;
@override @useResult
$Res call({
 List<AttendanceRecord> records
});




}
/// @nodoc
class __$StudentAttendanceSummaryCopyWithImpl<$Res>
    implements _$StudentAttendanceSummaryCopyWith<$Res> {
  __$StudentAttendanceSummaryCopyWithImpl(this._self, this._then);

  final _StudentAttendanceSummary _self;
  final $Res Function(_StudentAttendanceSummary) _then;

/// Create a copy of StudentAttendanceSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? records = null,}) {
  return _then(_StudentAttendanceSummary(
records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<AttendanceRecord>,
  ));
}


}


/// @nodoc
mixin _$StudentChargeLine {

 String get id; String get description;@DateOnlyConverter() DateTime get dueOn; int get amountMinor; int get paidMinor; StudentChargeStatus get status;
/// Create a copy of StudentChargeLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentChargeLineCopyWith<StudentChargeLine> get copyWith => _$StudentChargeLineCopyWithImpl<StudentChargeLine>(this as StudentChargeLine, _$identity);

  /// Serializes this StudentChargeLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentChargeLine&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.dueOn, dueOn) || other.dueOn == dueOn)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.paidMinor, paidMinor) || other.paidMinor == paidMinor)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,dueOn,amountMinor,paidMinor,status);

@override
String toString() {
  return 'StudentChargeLine(id: $id, description: $description, dueOn: $dueOn, amountMinor: $amountMinor, paidMinor: $paidMinor, status: $status)';
}


}

/// @nodoc
abstract mixin class $StudentChargeLineCopyWith<$Res>  {
  factory $StudentChargeLineCopyWith(StudentChargeLine value, $Res Function(StudentChargeLine) _then) = _$StudentChargeLineCopyWithImpl;
@useResult
$Res call({
 String id, String description,@DateOnlyConverter() DateTime dueOn, int amountMinor, int paidMinor, StudentChargeStatus status
});




}
/// @nodoc
class _$StudentChargeLineCopyWithImpl<$Res>
    implements $StudentChargeLineCopyWith<$Res> {
  _$StudentChargeLineCopyWithImpl(this._self, this._then);

  final StudentChargeLine _self;
  final $Res Function(StudentChargeLine) _then;

/// Create a copy of StudentChargeLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? description = null,Object? dueOn = null,Object? amountMinor = null,Object? paidMinor = null,Object? status = null,}) {
  return _then(StudentChargeLine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,dueOn: null == dueOn ? _self.dueOn : dueOn // ignore: cast_nullable_to_non_nullable
as DateTime,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,paidMinor: null == paidMinor ? _self.paidMinor : paidMinor // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StudentChargeStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentChargeLine].
extension StudentChargeLinePatterns on StudentChargeLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentChargeLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentChargeLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentChargeLine value)  $default,){
final _that = this;
switch (_that) {
case _StudentChargeLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentChargeLine value)?  $default,){
final _that = this;
switch (_that) {
case _StudentChargeLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String description, @DateOnlyConverter()  DateTime dueOn,  int amountMinor,  int paidMinor,  StudentChargeStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentChargeLine() when $default != null:
return $default(_that.id,_that.description,_that.dueOn,_that.amountMinor,_that.paidMinor,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String description, @DateOnlyConverter()  DateTime dueOn,  int amountMinor,  int paidMinor,  StudentChargeStatus status)  $default,) {final _that = this;
switch (_that) {
case _StudentChargeLine():
return $default(_that.id,_that.description,_that.dueOn,_that.amountMinor,_that.paidMinor,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String description, @DateOnlyConverter()  DateTime dueOn,  int amountMinor,  int paidMinor,  StudentChargeStatus status)?  $default,) {final _that = this;
switch (_that) {
case _StudentChargeLine() when $default != null:
return $default(_that.id,_that.description,_that.dueOn,_that.amountMinor,_that.paidMinor,_that.status);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _StudentChargeLine implements StudentChargeLine {
  const _StudentChargeLine({required this.id, required this.description, @DateOnlyConverter() required this.dueOn, required this.amountMinor, this.paidMinor = 0, required this.status});
  factory _StudentChargeLine.fromJson(Map<String, dynamic> json) => _$StudentChargeLineFromJson(json);

@override final  String id;
@override final  String description;
@override@DateOnlyConverter() final  DateTime dueOn;
@override final  int amountMinor;
@override@JsonKey() final  int paidMinor;
@override final  StudentChargeStatus status;

/// Create a copy of StudentChargeLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentChargeLineCopyWith<_StudentChargeLine> get copyWith => __$StudentChargeLineCopyWithImpl<_StudentChargeLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentChargeLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentChargeLine&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.dueOn, dueOn) || other.dueOn == dueOn)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.paidMinor, paidMinor) || other.paidMinor == paidMinor)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,dueOn,amountMinor,paidMinor,status);

@override
String toString() {
  return 'StudentChargeLine(id: $id, description: $description, dueOn: $dueOn, amountMinor: $amountMinor, paidMinor: $paidMinor, status: $status)';
}


}

/// @nodoc
abstract mixin class _$StudentChargeLineCopyWith<$Res> implements $StudentChargeLineCopyWith<$Res> {
  factory _$StudentChargeLineCopyWith(_StudentChargeLine value, $Res Function(_StudentChargeLine) _then) = __$StudentChargeLineCopyWithImpl;
@override @useResult
$Res call({
 String id, String description,@DateOnlyConverter() DateTime dueOn, int amountMinor, int paidMinor, StudentChargeStatus status
});




}
/// @nodoc
class __$StudentChargeLineCopyWithImpl<$Res>
    implements _$StudentChargeLineCopyWith<$Res> {
  __$StudentChargeLineCopyWithImpl(this._self, this._then);

  final _StudentChargeLine _self;
  final $Res Function(_StudentChargeLine) _then;

/// Create a copy of StudentChargeLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? description = null,Object? dueOn = null,Object? amountMinor = null,Object? paidMinor = null,Object? status = null,}) {
  return _then(_StudentChargeLine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,dueOn: null == dueOn ? _self.dueOn : dueOn // ignore: cast_nullable_to_non_nullable
as DateTime,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,paidMinor: null == paidMinor ? _self.paidMinor : paidMinor // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StudentChargeStatus,
  ));
}


}


/// @nodoc
mixin _$StudentFinanceSummary {

 List<StudentChargeLine> get charges;/// Bolsa/desconto em percentagem (0–100).
 int get discountPercent;
/// Create a copy of StudentFinanceSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentFinanceSummaryCopyWith<StudentFinanceSummary> get copyWith => _$StudentFinanceSummaryCopyWithImpl<StudentFinanceSummary>(this as StudentFinanceSummary, _$identity);

  /// Serializes this StudentFinanceSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentFinanceSummary&&const DeepCollectionEquality().equals(other.charges, charges)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(charges),discountPercent);

@override
String toString() {
  return 'StudentFinanceSummary(charges: $charges, discountPercent: $discountPercent)';
}


}

/// @nodoc
abstract mixin class $StudentFinanceSummaryCopyWith<$Res>  {
  factory $StudentFinanceSummaryCopyWith(StudentFinanceSummary value, $Res Function(StudentFinanceSummary) _then) = _$StudentFinanceSummaryCopyWithImpl;
@useResult
$Res call({
 List<StudentChargeLine> charges, int discountPercent
});




}
/// @nodoc
class _$StudentFinanceSummaryCopyWithImpl<$Res>
    implements $StudentFinanceSummaryCopyWith<$Res> {
  _$StudentFinanceSummaryCopyWithImpl(this._self, this._then);

  final StudentFinanceSummary _self;
  final $Res Function(StudentFinanceSummary) _then;

/// Create a copy of StudentFinanceSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? charges = null,Object? discountPercent = null,}) {
  return _then(StudentFinanceSummary(
charges: null == charges ? _self.charges : charges // ignore: cast_nullable_to_non_nullable
as List<StudentChargeLine>,discountPercent: null == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentFinanceSummary].
extension StudentFinanceSummaryPatterns on StudentFinanceSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentFinanceSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentFinanceSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentFinanceSummary value)  $default,){
final _that = this;
switch (_that) {
case _StudentFinanceSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentFinanceSummary value)?  $default,){
final _that = this;
switch (_that) {
case _StudentFinanceSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<StudentChargeLine> charges,  int discountPercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentFinanceSummary() when $default != null:
return $default(_that.charges,_that.discountPercent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<StudentChargeLine> charges,  int discountPercent)  $default,) {final _that = this;
switch (_that) {
case _StudentFinanceSummary():
return $default(_that.charges,_that.discountPercent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<StudentChargeLine> charges,  int discountPercent)?  $default,) {final _that = this;
switch (_that) {
case _StudentFinanceSummary() when $default != null:
return $default(_that.charges,_that.discountPercent);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _StudentFinanceSummary implements StudentFinanceSummary {
  const _StudentFinanceSummary({ List<StudentChargeLine> charges = const <StudentChargeLine>[], this.discountPercent = 0}): _charges = charges;
  factory _StudentFinanceSummary.fromJson(Map<String, dynamic> json) => _$StudentFinanceSummaryFromJson(json);

 final  List<StudentChargeLine> _charges;
@override@JsonKey() List<StudentChargeLine> get charges {
  if (_charges is EqualUnmodifiableListView) return _charges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_charges);
}

/// Bolsa/desconto em percentagem (0–100).
@override@JsonKey() final  int discountPercent;

/// Create a copy of StudentFinanceSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentFinanceSummaryCopyWith<_StudentFinanceSummary> get copyWith => __$StudentFinanceSummaryCopyWithImpl<_StudentFinanceSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentFinanceSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentFinanceSummary&&const DeepCollectionEquality().equals(other._charges, _charges)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_charges),discountPercent);

@override
String toString() {
  return 'StudentFinanceSummary(charges: $charges, discountPercent: $discountPercent)';
}


}

/// @nodoc
abstract mixin class _$StudentFinanceSummaryCopyWith<$Res> implements $StudentFinanceSummaryCopyWith<$Res> {
  factory _$StudentFinanceSummaryCopyWith(_StudentFinanceSummary value, $Res Function(_StudentFinanceSummary) _then) = __$StudentFinanceSummaryCopyWithImpl;
@override @useResult
$Res call({
 List<StudentChargeLine> charges, int discountPercent
});




}
/// @nodoc
class __$StudentFinanceSummaryCopyWithImpl<$Res>
    implements _$StudentFinanceSummaryCopyWith<$Res> {
  __$StudentFinanceSummaryCopyWithImpl(this._self, this._then);

  final _StudentFinanceSummary _self;
  final $Res Function(_StudentFinanceSummary) _then;

/// Create a copy of StudentFinanceSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? charges = null,Object? discountPercent = null,}) {
  return _then(_StudentFinanceSummary(
charges: null == charges ? _self._charges : charges // ignore: cast_nullable_to_non_nullable
as List<StudentChargeLine>,discountPercent: null == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AccessEvent {

@UtcDateTimeConverter() DateTime get at; AccessDirection get direction; String? get gate;
/// Create a copy of AccessEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccessEventCopyWith<AccessEvent> get copyWith => _$AccessEventCopyWithImpl<AccessEvent>(this as AccessEvent, _$identity);

  /// Serializes this AccessEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccessEvent&&(identical(other.at, at) || other.at == at)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.gate, gate) || other.gate == gate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,at,direction,gate);

@override
String toString() {
  return 'AccessEvent(at: $at, direction: $direction, gate: $gate)';
}


}

/// @nodoc
abstract mixin class $AccessEventCopyWith<$Res>  {
  factory $AccessEventCopyWith(AccessEvent value, $Res Function(AccessEvent) _then) = _$AccessEventCopyWithImpl;
@useResult
$Res call({
@UtcDateTimeConverter() DateTime at, AccessDirection direction, String? gate
});




}
/// @nodoc
class _$AccessEventCopyWithImpl<$Res>
    implements $AccessEventCopyWith<$Res> {
  _$AccessEventCopyWithImpl(this._self, this._then);

  final AccessEvent _self;
  final $Res Function(AccessEvent) _then;

/// Create a copy of AccessEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? at = null,Object? direction = null,Object? gate = freezed,}) {
  return _then(AccessEvent(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as AccessDirection,gate: freezed == gate ? _self.gate : gate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccessEvent].
extension AccessEventPatterns on AccessEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccessEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccessEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccessEvent value)  $default,){
final _that = this;
switch (_that) {
case _AccessEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccessEvent value)?  $default,){
final _that = this;
switch (_that) {
case _AccessEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@UtcDateTimeConverter()  DateTime at,  AccessDirection direction,  String? gate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccessEvent() when $default != null:
return $default(_that.at,_that.direction,_that.gate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@UtcDateTimeConverter()  DateTime at,  AccessDirection direction,  String? gate)  $default,) {final _that = this;
switch (_that) {
case _AccessEvent():
return $default(_that.at,_that.direction,_that.gate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@UtcDateTimeConverter()  DateTime at,  AccessDirection direction,  String? gate)?  $default,) {final _that = this;
switch (_that) {
case _AccessEvent() when $default != null:
return $default(_that.at,_that.direction,_that.gate);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AccessEvent implements AccessEvent {
  const _AccessEvent({@UtcDateTimeConverter() required this.at, required this.direction, this.gate});
  factory _AccessEvent.fromJson(Map<String, dynamic> json) => _$AccessEventFromJson(json);

@override@UtcDateTimeConverter() final  DateTime at;
@override final  AccessDirection direction;
@override final  String? gate;

/// Create a copy of AccessEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccessEventCopyWith<_AccessEvent> get copyWith => __$AccessEventCopyWithImpl<_AccessEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccessEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccessEvent&&(identical(other.at, at) || other.at == at)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.gate, gate) || other.gate == gate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,at,direction,gate);

@override
String toString() {
  return 'AccessEvent(at: $at, direction: $direction, gate: $gate)';
}


}

/// @nodoc
abstract mixin class _$AccessEventCopyWith<$Res> implements $AccessEventCopyWith<$Res> {
  factory _$AccessEventCopyWith(_AccessEvent value, $Res Function(_AccessEvent) _then) = __$AccessEventCopyWithImpl;
@override @useResult
$Res call({
@UtcDateTimeConverter() DateTime at, AccessDirection direction, String? gate
});




}
/// @nodoc
class __$AccessEventCopyWithImpl<$Res>
    implements _$AccessEventCopyWith<$Res> {
  __$AccessEventCopyWithImpl(this._self, this._then);

  final _AccessEvent _self;
  final $Res Function(_AccessEvent) _then;

/// Create a copy of AccessEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? at = null,Object? direction = null,Object? gate = freezed,}) {
  return _then(_AccessEvent(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as AccessDirection,gate: freezed == gate ? _self.gate : gate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StudentCardSummary {

 String? get cardNumber; StudentCardStatus? get status; int get mealBalanceMinor; List<AccessEvent> get recentAccess;
/// Create a copy of StudentCardSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentCardSummaryCopyWith<StudentCardSummary> get copyWith => _$StudentCardSummaryCopyWithImpl<StudentCardSummary>(this as StudentCardSummary, _$identity);

  /// Serializes this StudentCardSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentCardSummary&&(identical(other.cardNumber, cardNumber) || other.cardNumber == cardNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.mealBalanceMinor, mealBalanceMinor) || other.mealBalanceMinor == mealBalanceMinor)&&const DeepCollectionEquality().equals(other.recentAccess, recentAccess));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cardNumber,status,mealBalanceMinor,const DeepCollectionEquality().hash(recentAccess));

@override
String toString() {
  return 'StudentCardSummary(cardNumber: $cardNumber, status: $status, mealBalanceMinor: $mealBalanceMinor, recentAccess: $recentAccess)';
}


}

/// @nodoc
abstract mixin class $StudentCardSummaryCopyWith<$Res>  {
  factory $StudentCardSummaryCopyWith(StudentCardSummary value, $Res Function(StudentCardSummary) _then) = _$StudentCardSummaryCopyWithImpl;
@useResult
$Res call({
 String? cardNumber, StudentCardStatus? status, int mealBalanceMinor, List<AccessEvent> recentAccess
});




}
/// @nodoc
class _$StudentCardSummaryCopyWithImpl<$Res>
    implements $StudentCardSummaryCopyWith<$Res> {
  _$StudentCardSummaryCopyWithImpl(this._self, this._then);

  final StudentCardSummary _self;
  final $Res Function(StudentCardSummary) _then;

/// Create a copy of StudentCardSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cardNumber = freezed,Object? status = freezed,Object? mealBalanceMinor = null,Object? recentAccess = null,}) {
  return _then(StudentCardSummary(
cardNumber: freezed == cardNumber ? _self.cardNumber : cardNumber // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StudentCardStatus?,mealBalanceMinor: null == mealBalanceMinor ? _self.mealBalanceMinor : mealBalanceMinor // ignore: cast_nullable_to_non_nullable
as int,recentAccess: null == recentAccess ? _self.recentAccess : recentAccess // ignore: cast_nullable_to_non_nullable
as List<AccessEvent>,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentCardSummary].
extension StudentCardSummaryPatterns on StudentCardSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentCardSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentCardSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentCardSummary value)  $default,){
final _that = this;
switch (_that) {
case _StudentCardSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentCardSummary value)?  $default,){
final _that = this;
switch (_that) {
case _StudentCardSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? cardNumber,  StudentCardStatus? status,  int mealBalanceMinor,  List<AccessEvent> recentAccess)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentCardSummary() when $default != null:
return $default(_that.cardNumber,_that.status,_that.mealBalanceMinor,_that.recentAccess);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? cardNumber,  StudentCardStatus? status,  int mealBalanceMinor,  List<AccessEvent> recentAccess)  $default,) {final _that = this;
switch (_that) {
case _StudentCardSummary():
return $default(_that.cardNumber,_that.status,_that.mealBalanceMinor,_that.recentAccess);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? cardNumber,  StudentCardStatus? status,  int mealBalanceMinor,  List<AccessEvent> recentAccess)?  $default,) {final _that = this;
switch (_that) {
case _StudentCardSummary() when $default != null:
return $default(_that.cardNumber,_that.status,_that.mealBalanceMinor,_that.recentAccess);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _StudentCardSummary implements StudentCardSummary {
  const _StudentCardSummary({this.cardNumber, this.status, this.mealBalanceMinor = 0,  List<AccessEvent> recentAccess = const <AccessEvent>[]}): _recentAccess = recentAccess;
  factory _StudentCardSummary.fromJson(Map<String, dynamic> json) => _$StudentCardSummaryFromJson(json);

@override final  String? cardNumber;
@override final  StudentCardStatus? status;
@override@JsonKey() final  int mealBalanceMinor;
 final  List<AccessEvent> _recentAccess;
@override@JsonKey() List<AccessEvent> get recentAccess {
  if (_recentAccess is EqualUnmodifiableListView) return _recentAccess;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentAccess);
}


/// Create a copy of StudentCardSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentCardSummaryCopyWith<_StudentCardSummary> get copyWith => __$StudentCardSummaryCopyWithImpl<_StudentCardSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentCardSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentCardSummary&&(identical(other.cardNumber, cardNumber) || other.cardNumber == cardNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.mealBalanceMinor, mealBalanceMinor) || other.mealBalanceMinor == mealBalanceMinor)&&const DeepCollectionEquality().equals(other._recentAccess, _recentAccess));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cardNumber,status,mealBalanceMinor,const DeepCollectionEquality().hash(_recentAccess));

@override
String toString() {
  return 'StudentCardSummary(cardNumber: $cardNumber, status: $status, mealBalanceMinor: $mealBalanceMinor, recentAccess: $recentAccess)';
}


}

/// @nodoc
abstract mixin class _$StudentCardSummaryCopyWith<$Res> implements $StudentCardSummaryCopyWith<$Res> {
  factory _$StudentCardSummaryCopyWith(_StudentCardSummary value, $Res Function(_StudentCardSummary) _then) = __$StudentCardSummaryCopyWithImpl;
@override @useResult
$Res call({
 String? cardNumber, StudentCardStatus? status, int mealBalanceMinor, List<AccessEvent> recentAccess
});




}
/// @nodoc
class __$StudentCardSummaryCopyWithImpl<$Res>
    implements _$StudentCardSummaryCopyWith<$Res> {
  __$StudentCardSummaryCopyWithImpl(this._self, this._then);

  final _StudentCardSummary _self;
  final $Res Function(_StudentCardSummary) _then;

/// Create a copy of StudentCardSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cardNumber = freezed,Object? status = freezed,Object? mealBalanceMinor = null,Object? recentAccess = null,}) {
  return _then(_StudentCardSummary(
cardNumber: freezed == cardNumber ? _self.cardNumber : cardNumber // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StudentCardStatus?,mealBalanceMinor: null == mealBalanceMinor ? _self.mealBalanceMinor : mealBalanceMinor // ignore: cast_nullable_to_non_nullable
as int,recentAccess: null == recentAccess ? _self._recentAccess : recentAccess // ignore: cast_nullable_to_non_nullable
as List<AccessEvent>,
  ));
}


}

// dart format on
