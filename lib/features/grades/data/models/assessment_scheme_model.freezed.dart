// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assessment_scheme_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssessmentComponentModel {

 String get code; String get name;/// Peso inteiro em percentagem (1–100); a soma do esquema é 100.
 int get weight;
/// Create a copy of AssessmentComponentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssessmentComponentModelCopyWith<AssessmentComponentModel> get copyWith => _$AssessmentComponentModelCopyWithImpl<AssessmentComponentModel>(this as AssessmentComponentModel, _$identity);

  /// Serializes this AssessmentComponentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssessmentComponentModel&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.weight, weight) || other.weight == weight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,name,weight);

@override
String toString() {
  return 'AssessmentComponentModel(code: $code, name: $name, weight: $weight)';
}


}

/// @nodoc
abstract mixin class $AssessmentComponentModelCopyWith<$Res>  {
  factory $AssessmentComponentModelCopyWith(AssessmentComponentModel value, $Res Function(AssessmentComponentModel) _then) = _$AssessmentComponentModelCopyWithImpl;
@useResult
$Res call({
 String code, String name, int weight
});




}
/// @nodoc
class _$AssessmentComponentModelCopyWithImpl<$Res>
    implements $AssessmentComponentModelCopyWith<$Res> {
  _$AssessmentComponentModelCopyWithImpl(this._self, this._then);

  final AssessmentComponentModel _self;
  final $Res Function(AssessmentComponentModel) _then;

/// Create a copy of AssessmentComponentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? name = null,Object? weight = null,}) {
  return _then(AssessmentComponentModel(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AssessmentComponentModel].
extension AssessmentComponentModelPatterns on AssessmentComponentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssessmentComponentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssessmentComponentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssessmentComponentModel value)  $default,){
final _that = this;
switch (_that) {
case _AssessmentComponentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssessmentComponentModel value)?  $default,){
final _that = this;
switch (_that) {
case _AssessmentComponentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String name,  int weight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssessmentComponentModel() when $default != null:
return $default(_that.code,_that.name,_that.weight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String name,  int weight)  $default,) {final _that = this;
switch (_that) {
case _AssessmentComponentModel():
return $default(_that.code,_that.name,_that.weight);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String name,  int weight)?  $default,) {final _that = this;
switch (_that) {
case _AssessmentComponentModel() when $default != null:
return $default(_that.code,_that.name,_that.weight);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssessmentComponentModel implements AssessmentComponentModel {
  const _AssessmentComponentModel({required this.code, required this.name, required this.weight});
  factory _AssessmentComponentModel.fromJson(Map<String, dynamic> json) => _$AssessmentComponentModelFromJson(json);

@override final  String code;
@override final  String name;
/// Peso inteiro em percentagem (1–100); a soma do esquema é 100.
@override final  int weight;

/// Create a copy of AssessmentComponentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssessmentComponentModelCopyWith<_AssessmentComponentModel> get copyWith => __$AssessmentComponentModelCopyWithImpl<_AssessmentComponentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssessmentComponentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssessmentComponentModel&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.weight, weight) || other.weight == weight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,name,weight);

@override
String toString() {
  return 'AssessmentComponentModel(code: $code, name: $name, weight: $weight)';
}


}

/// @nodoc
abstract mixin class _$AssessmentComponentModelCopyWith<$Res> implements $AssessmentComponentModelCopyWith<$Res> {
  factory _$AssessmentComponentModelCopyWith(_AssessmentComponentModel value, $Res Function(_AssessmentComponentModel) _then) = __$AssessmentComponentModelCopyWithImpl;
@override @useResult
$Res call({
 String code, String name, int weight
});




}
/// @nodoc
class __$AssessmentComponentModelCopyWithImpl<$Res>
    implements _$AssessmentComponentModelCopyWith<$Res> {
  __$AssessmentComponentModelCopyWithImpl(this._self, this._then);

  final _AssessmentComponentModel _self;
  final $Res Function(_AssessmentComponentModel) _then;

/// Create a copy of AssessmentComponentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? name = null,Object? weight = null,}) {
  return _then(_AssessmentComponentModel(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AssessmentSchemeModel {

 String get id; String get name; String? get gradeId; String? get courseId; int get scaleMax; int get minPassing; RoundingMode get rounding;/// Casas decimais do arredondamento (0–2).
 int get decimals;/// Arredonda a `MT` antes de calcular a `MF`.
 bool get roundTerm; List<AssessmentComponentModel> get components;/// Pesos (%) de cada trimestre na `MF`; vazio = média simples.
 List<int> get termWeights;
/// Create a copy of AssessmentSchemeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssessmentSchemeModelCopyWith<AssessmentSchemeModel> get copyWith => _$AssessmentSchemeModelCopyWithImpl<AssessmentSchemeModel>(this as AssessmentSchemeModel, _$identity);

  /// Serializes this AssessmentSchemeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssessmentSchemeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.gradeId, gradeId) || other.gradeId == gradeId)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.scaleMax, scaleMax) || other.scaleMax == scaleMax)&&(identical(other.minPassing, minPassing) || other.minPassing == minPassing)&&(identical(other.rounding, rounding) || other.rounding == rounding)&&(identical(other.decimals, decimals) || other.decimals == decimals)&&(identical(other.roundTerm, roundTerm) || other.roundTerm == roundTerm)&&const DeepCollectionEquality().equals(other.components, components)&&const DeepCollectionEquality().equals(other.termWeights, termWeights));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,gradeId,courseId,scaleMax,minPassing,rounding,decimals,roundTerm,const DeepCollectionEquality().hash(components),const DeepCollectionEquality().hash(termWeights));

@override
String toString() {
  return 'AssessmentSchemeModel(id: $id, name: $name, gradeId: $gradeId, courseId: $courseId, scaleMax: $scaleMax, minPassing: $minPassing, rounding: $rounding, decimals: $decimals, roundTerm: $roundTerm, components: $components, termWeights: $termWeights)';
}


}

/// @nodoc
abstract mixin class $AssessmentSchemeModelCopyWith<$Res>  {
  factory $AssessmentSchemeModelCopyWith(AssessmentSchemeModel value, $Res Function(AssessmentSchemeModel) _then) = _$AssessmentSchemeModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? gradeId, String? courseId, int scaleMax, int minPassing, RoundingMode rounding, int decimals, bool roundTerm, List<AssessmentComponentModel> components, List<int> termWeights
});




}
/// @nodoc
class _$AssessmentSchemeModelCopyWithImpl<$Res>
    implements $AssessmentSchemeModelCopyWith<$Res> {
  _$AssessmentSchemeModelCopyWithImpl(this._self, this._then);

  final AssessmentSchemeModel _self;
  final $Res Function(AssessmentSchemeModel) _then;

/// Create a copy of AssessmentSchemeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? gradeId = freezed,Object? courseId = freezed,Object? scaleMax = null,Object? minPassing = null,Object? rounding = null,Object? decimals = null,Object? roundTerm = null,Object? components = null,Object? termWeights = null,}) {
  return _then(AssessmentSchemeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gradeId: freezed == gradeId ? _self.gradeId : gradeId // ignore: cast_nullable_to_non_nullable
as String?,courseId: freezed == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String?,scaleMax: null == scaleMax ? _self.scaleMax : scaleMax // ignore: cast_nullable_to_non_nullable
as int,minPassing: null == minPassing ? _self.minPassing : minPassing // ignore: cast_nullable_to_non_nullable
as int,rounding: null == rounding ? _self.rounding : rounding // ignore: cast_nullable_to_non_nullable
as RoundingMode,decimals: null == decimals ? _self.decimals : decimals // ignore: cast_nullable_to_non_nullable
as int,roundTerm: null == roundTerm ? _self.roundTerm : roundTerm // ignore: cast_nullable_to_non_nullable
as bool,components: null == components ? _self.components : components // ignore: cast_nullable_to_non_nullable
as List<AssessmentComponentModel>,termWeights: null == termWeights ? _self.termWeights : termWeights // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [AssessmentSchemeModel].
extension AssessmentSchemeModelPatterns on AssessmentSchemeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssessmentSchemeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssessmentSchemeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssessmentSchemeModel value)  $default,){
final _that = this;
switch (_that) {
case _AssessmentSchemeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssessmentSchemeModel value)?  $default,){
final _that = this;
switch (_that) {
case _AssessmentSchemeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? gradeId,  String? courseId,  int scaleMax,  int minPassing,  RoundingMode rounding,  int decimals,  bool roundTerm,  List<AssessmentComponentModel> components,  List<int> termWeights)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssessmentSchemeModel() when $default != null:
return $default(_that.id,_that.name,_that.gradeId,_that.courseId,_that.scaleMax,_that.minPassing,_that.rounding,_that.decimals,_that.roundTerm,_that.components,_that.termWeights);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? gradeId,  String? courseId,  int scaleMax,  int minPassing,  RoundingMode rounding,  int decimals,  bool roundTerm,  List<AssessmentComponentModel> components,  List<int> termWeights)  $default,) {final _that = this;
switch (_that) {
case _AssessmentSchemeModel():
return $default(_that.id,_that.name,_that.gradeId,_that.courseId,_that.scaleMax,_that.minPassing,_that.rounding,_that.decimals,_that.roundTerm,_that.components,_that.termWeights);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? gradeId,  String? courseId,  int scaleMax,  int minPassing,  RoundingMode rounding,  int decimals,  bool roundTerm,  List<AssessmentComponentModel> components,  List<int> termWeights)?  $default,) {final _that = this;
switch (_that) {
case _AssessmentSchemeModel() when $default != null:
return $default(_that.id,_that.name,_that.gradeId,_that.courseId,_that.scaleMax,_that.minPassing,_that.rounding,_that.decimals,_that.roundTerm,_that.components,_that.termWeights);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AssessmentSchemeModel implements AssessmentSchemeModel {
  const _AssessmentSchemeModel({required this.id, required this.name, this.gradeId, this.courseId, this.scaleMax = 20, this.minPassing = 10, this.rounding = RoundingMode.nearest, this.decimals = 0, this.roundTerm = true,  List<AssessmentComponentModel> components = const <AssessmentComponentModel>[],  List<int> termWeights = const <int>[]}): _components = components,_termWeights = termWeights;
  factory _AssessmentSchemeModel.fromJson(Map<String, dynamic> json) => _$AssessmentSchemeModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? gradeId;
@override final  String? courseId;
@override@JsonKey() final  int scaleMax;
@override@JsonKey() final  int minPassing;
@override@JsonKey() final  RoundingMode rounding;
/// Casas decimais do arredondamento (0–2).
@override@JsonKey() final  int decimals;
/// Arredonda a `MT` antes de calcular a `MF`.
@override@JsonKey() final  bool roundTerm;
 final  List<AssessmentComponentModel> _components;
@override@JsonKey() List<AssessmentComponentModel> get components {
  if (_components is EqualUnmodifiableListView) return _components;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_components);
}

/// Pesos (%) de cada trimestre na `MF`; vazio = média simples.
 final  List<int> _termWeights;
/// Pesos (%) de cada trimestre na `MF`; vazio = média simples.
@override@JsonKey() List<int> get termWeights {
  if (_termWeights is EqualUnmodifiableListView) return _termWeights;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_termWeights);
}


/// Create a copy of AssessmentSchemeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssessmentSchemeModelCopyWith<_AssessmentSchemeModel> get copyWith => __$AssessmentSchemeModelCopyWithImpl<_AssessmentSchemeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssessmentSchemeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssessmentSchemeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.gradeId, gradeId) || other.gradeId == gradeId)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.scaleMax, scaleMax) || other.scaleMax == scaleMax)&&(identical(other.minPassing, minPassing) || other.minPassing == minPassing)&&(identical(other.rounding, rounding) || other.rounding == rounding)&&(identical(other.decimals, decimals) || other.decimals == decimals)&&(identical(other.roundTerm, roundTerm) || other.roundTerm == roundTerm)&&const DeepCollectionEquality().equals(other._components, _components)&&const DeepCollectionEquality().equals(other._termWeights, _termWeights));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,gradeId,courseId,scaleMax,minPassing,rounding,decimals,roundTerm,const DeepCollectionEquality().hash(_components),const DeepCollectionEquality().hash(_termWeights));

@override
String toString() {
  return 'AssessmentSchemeModel(id: $id, name: $name, gradeId: $gradeId, courseId: $courseId, scaleMax: $scaleMax, minPassing: $minPassing, rounding: $rounding, decimals: $decimals, roundTerm: $roundTerm, components: $components, termWeights: $termWeights)';
}


}

/// @nodoc
abstract mixin class _$AssessmentSchemeModelCopyWith<$Res> implements $AssessmentSchemeModelCopyWith<$Res> {
  factory _$AssessmentSchemeModelCopyWith(_AssessmentSchemeModel value, $Res Function(_AssessmentSchemeModel) _then) = __$AssessmentSchemeModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? gradeId, String? courseId, int scaleMax, int minPassing, RoundingMode rounding, int decimals, bool roundTerm, List<AssessmentComponentModel> components, List<int> termWeights
});




}
/// @nodoc
class __$AssessmentSchemeModelCopyWithImpl<$Res>
    implements _$AssessmentSchemeModelCopyWith<$Res> {
  __$AssessmentSchemeModelCopyWithImpl(this._self, this._then);

  final _AssessmentSchemeModel _self;
  final $Res Function(_AssessmentSchemeModel) _then;

/// Create a copy of AssessmentSchemeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? gradeId = freezed,Object? courseId = freezed,Object? scaleMax = null,Object? minPassing = null,Object? rounding = null,Object? decimals = null,Object? roundTerm = null,Object? components = null,Object? termWeights = null,}) {
  return _then(_AssessmentSchemeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gradeId: freezed == gradeId ? _self.gradeId : gradeId // ignore: cast_nullable_to_non_nullable
as String?,courseId: freezed == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String?,scaleMax: null == scaleMax ? _self.scaleMax : scaleMax // ignore: cast_nullable_to_non_nullable
as int,minPassing: null == minPassing ? _self.minPassing : minPassing // ignore: cast_nullable_to_non_nullable
as int,rounding: null == rounding ? _self.rounding : rounding // ignore: cast_nullable_to_non_nullable
as RoundingMode,decimals: null == decimals ? _self.decimals : decimals // ignore: cast_nullable_to_non_nullable
as int,roundTerm: null == roundTerm ? _self.roundTerm : roundTerm // ignore: cast_nullable_to_non_nullable
as bool,components: null == components ? _self._components : components // ignore: cast_nullable_to_non_nullable
as List<AssessmentComponentModel>,termWeights: null == termWeights ? _self._termWeights : termWeights // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
