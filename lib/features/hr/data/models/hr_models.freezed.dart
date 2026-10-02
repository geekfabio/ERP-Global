// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hr_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PositionModel {

 String get id; String get name; PositionCategory get category;
/// Create a copy of PositionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PositionModelCopyWith<PositionModel> get copyWith => _$PositionModelCopyWithImpl<PositionModel>(this as PositionModel, _$identity);

  /// Serializes this PositionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PositionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category);

@override
String toString() {
  return 'PositionModel(id: $id, name: $name, category: $category)';
}


}

/// @nodoc
abstract mixin class $PositionModelCopyWith<$Res>  {
  factory $PositionModelCopyWith(PositionModel value, $Res Function(PositionModel) _then) = _$PositionModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, PositionCategory category
});




}
/// @nodoc
class _$PositionModelCopyWithImpl<$Res>
    implements $PositionModelCopyWith<$Res> {
  _$PositionModelCopyWithImpl(this._self, this._then);

  final PositionModel _self;
  final $Res Function(PositionModel) _then;

/// Create a copy of PositionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = null,}) {
  return _then(PositionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as PositionCategory,
  ));
}

}


/// Adds pattern-matching-related methods to [PositionModel].
extension PositionModelPatterns on PositionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PositionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PositionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PositionModel value)  $default,){
final _that = this;
switch (_that) {
case _PositionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PositionModel value)?  $default,){
final _that = this;
switch (_that) {
case _PositionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  PositionCategory category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PositionModel() when $default != null:
return $default(_that.id,_that.name,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  PositionCategory category)  $default,) {final _that = this;
switch (_that) {
case _PositionModel():
return $default(_that.id,_that.name,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  PositionCategory category)?  $default,) {final _that = this;
switch (_that) {
case _PositionModel() when $default != null:
return $default(_that.id,_that.name,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PositionModel implements PositionModel {
  const _PositionModel({required this.id, required this.name, this.category = PositionCategory.administrative});
  factory _PositionModel.fromJson(Map<String, dynamic> json) => _$PositionModelFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  PositionCategory category;

/// Create a copy of PositionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PositionModelCopyWith<_PositionModel> get copyWith => __$PositionModelCopyWithImpl<_PositionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PositionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PositionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category);

@override
String toString() {
  return 'PositionModel(id: $id, name: $name, category: $category)';
}


}

/// @nodoc
abstract mixin class _$PositionModelCopyWith<$Res> implements $PositionModelCopyWith<$Res> {
  factory _$PositionModelCopyWith(_PositionModel value, $Res Function(_PositionModel) _then) = __$PositionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, PositionCategory category
});




}
/// @nodoc
class __$PositionModelCopyWithImpl<$Res>
    implements _$PositionModelCopyWith<$Res> {
  __$PositionModelCopyWithImpl(this._self, this._then);

  final _PositionModel _self;
  final $Res Function(_PositionModel) _then;

/// Create a copy of PositionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = null,}) {
  return _then(_PositionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as PositionCategory,
  ));
}


}


/// @nodoc
mixin _$EmployeeModel {

 String get id;/// Atribuído pelo servidor na criação.
 String get employeeNumber; String get fullName; String get email; String get phone; String get positionId;/// Data de admissão (`AAAA-MM-DD`).
 String get hireDate;/// Ligação ao professor do módulo académico (só docentes).
 String? get teacherId; bool get isActive;/// Calculado pelo servidor: existe contrato em vigor hoje.
 bool get hasActiveContract;
/// Create a copy of EmployeeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployeeModelCopyWith<EmployeeModel> get copyWith => _$EmployeeModelCopyWithImpl<EmployeeModel>(this as EmployeeModel, _$identity);

  /// Serializes this EmployeeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmployeeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeNumber, employeeNumber) || other.employeeNumber == employeeNumber)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.positionId, positionId) || other.positionId == positionId)&&(identical(other.hireDate, hireDate) || other.hireDate == hireDate)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.hasActiveContract, hasActiveContract) || other.hasActiveContract == hasActiveContract));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeNumber,fullName,email,phone,positionId,hireDate,teacherId,isActive,hasActiveContract);

@override
String toString() {
  return 'EmployeeModel(id: $id, employeeNumber: $employeeNumber, fullName: $fullName, email: $email, phone: $phone, positionId: $positionId, hireDate: $hireDate, teacherId: $teacherId, isActive: $isActive, hasActiveContract: $hasActiveContract)';
}


}

/// @nodoc
abstract mixin class $EmployeeModelCopyWith<$Res>  {
  factory $EmployeeModelCopyWith(EmployeeModel value, $Res Function(EmployeeModel) _then) = _$EmployeeModelCopyWithImpl;
@useResult
$Res call({
 String id, String employeeNumber, String fullName, String email, String phone, String positionId, String hireDate, String? teacherId, bool isActive, bool hasActiveContract
});




}
/// @nodoc
class _$EmployeeModelCopyWithImpl<$Res>
    implements $EmployeeModelCopyWith<$Res> {
  _$EmployeeModelCopyWithImpl(this._self, this._then);

  final EmployeeModel _self;
  final $Res Function(EmployeeModel) _then;

/// Create a copy of EmployeeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? employeeNumber = null,Object? fullName = null,Object? email = null,Object? phone = null,Object? positionId = null,Object? hireDate = null,Object? teacherId = freezed,Object? isActive = null,Object? hasActiveContract = null,}) {
  return _then(EmployeeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeNumber: null == employeeNumber ? _self.employeeNumber : employeeNumber // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,positionId: null == positionId ? _self.positionId : positionId // ignore: cast_nullable_to_non_nullable
as String,hireDate: null == hireDate ? _self.hireDate : hireDate // ignore: cast_nullable_to_non_nullable
as String,teacherId: freezed == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,hasActiveContract: null == hasActiveContract ? _self.hasActiveContract : hasActiveContract // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EmployeeModel].
extension EmployeeModelPatterns on EmployeeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmployeeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmployeeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmployeeModel value)  $default,){
final _that = this;
switch (_that) {
case _EmployeeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmployeeModel value)?  $default,){
final _that = this;
switch (_that) {
case _EmployeeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String employeeNumber,  String fullName,  String email,  String phone,  String positionId,  String hireDate,  String? teacherId,  bool isActive,  bool hasActiveContract)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmployeeModel() when $default != null:
return $default(_that.id,_that.employeeNumber,_that.fullName,_that.email,_that.phone,_that.positionId,_that.hireDate,_that.teacherId,_that.isActive,_that.hasActiveContract);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String employeeNumber,  String fullName,  String email,  String phone,  String positionId,  String hireDate,  String? teacherId,  bool isActive,  bool hasActiveContract)  $default,) {final _that = this;
switch (_that) {
case _EmployeeModel():
return $default(_that.id,_that.employeeNumber,_that.fullName,_that.email,_that.phone,_that.positionId,_that.hireDate,_that.teacherId,_that.isActive,_that.hasActiveContract);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String employeeNumber,  String fullName,  String email,  String phone,  String positionId,  String hireDate,  String? teacherId,  bool isActive,  bool hasActiveContract)?  $default,) {final _that = this;
switch (_that) {
case _EmployeeModel() when $default != null:
return $default(_that.id,_that.employeeNumber,_that.fullName,_that.email,_that.phone,_that.positionId,_that.hireDate,_that.teacherId,_that.isActive,_that.hasActiveContract);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmployeeModel implements EmployeeModel {
  const _EmployeeModel({required this.id, this.employeeNumber = '', required this.fullName, required this.email, this.phone = '', required this.positionId, required this.hireDate, this.teacherId, this.isActive = true, this.hasActiveContract = false});
  factory _EmployeeModel.fromJson(Map<String, dynamic> json) => _$EmployeeModelFromJson(json);

@override final  String id;
/// Atribuído pelo servidor na criação.
@override@JsonKey() final  String employeeNumber;
@override final  String fullName;
@override final  String email;
@override@JsonKey() final  String phone;
@override final  String positionId;
/// Data de admissão (`AAAA-MM-DD`).
@override final  String hireDate;
/// Ligação ao professor do módulo académico (só docentes).
@override final  String? teacherId;
@override@JsonKey() final  bool isActive;
/// Calculado pelo servidor: existe contrato em vigor hoje.
@override@JsonKey() final  bool hasActiveContract;

/// Create a copy of EmployeeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployeeModelCopyWith<_EmployeeModel> get copyWith => __$EmployeeModelCopyWithImpl<_EmployeeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmployeeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmployeeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeNumber, employeeNumber) || other.employeeNumber == employeeNumber)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.positionId, positionId) || other.positionId == positionId)&&(identical(other.hireDate, hireDate) || other.hireDate == hireDate)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.hasActiveContract, hasActiveContract) || other.hasActiveContract == hasActiveContract));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeNumber,fullName,email,phone,positionId,hireDate,teacherId,isActive,hasActiveContract);

@override
String toString() {
  return 'EmployeeModel(id: $id, employeeNumber: $employeeNumber, fullName: $fullName, email: $email, phone: $phone, positionId: $positionId, hireDate: $hireDate, teacherId: $teacherId, isActive: $isActive, hasActiveContract: $hasActiveContract)';
}


}

/// @nodoc
abstract mixin class _$EmployeeModelCopyWith<$Res> implements $EmployeeModelCopyWith<$Res> {
  factory _$EmployeeModelCopyWith(_EmployeeModel value, $Res Function(_EmployeeModel) _then) = __$EmployeeModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String employeeNumber, String fullName, String email, String phone, String positionId, String hireDate, String? teacherId, bool isActive, bool hasActiveContract
});




}
/// @nodoc
class __$EmployeeModelCopyWithImpl<$Res>
    implements _$EmployeeModelCopyWith<$Res> {
  __$EmployeeModelCopyWithImpl(this._self, this._then);

  final _EmployeeModel _self;
  final $Res Function(_EmployeeModel) _then;

/// Create a copy of EmployeeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? employeeNumber = null,Object? fullName = null,Object? email = null,Object? phone = null,Object? positionId = null,Object? hireDate = null,Object? teacherId = freezed,Object? isActive = null,Object? hasActiveContract = null,}) {
  return _then(_EmployeeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeNumber: null == employeeNumber ? _self.employeeNumber : employeeNumber // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,positionId: null == positionId ? _self.positionId : positionId // ignore: cast_nullable_to_non_nullable
as String,hireDate: null == hireDate ? _self.hireDate : hireDate // ignore: cast_nullable_to_non_nullable
as String,teacherId: freezed == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,hasActiveContract: null == hasActiveContract ? _self.hasActiveContract : hasActiveContract // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ContractModel {

 String get id; String get employeeId; ContractType get type;/// `AAAA-MM-DD`.
 String get startDate;/// `AAAA-MM-DD`; obrigatório nos contratos que não são efectivos.
 String? get endDate;/// Salário base mensal em cêntimos.
 int get baseSalary;
/// Create a copy of ContractModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContractModelCopyWith<ContractModel> get copyWith => _$ContractModelCopyWithImpl<ContractModel>(this as ContractModel, _$identity);

  /// Serializes this ContractModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContractModel&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.type, type) || other.type == type)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.baseSalary, baseSalary) || other.baseSalary == baseSalary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeId,type,startDate,endDate,baseSalary);

@override
String toString() {
  return 'ContractModel(id: $id, employeeId: $employeeId, type: $type, startDate: $startDate, endDate: $endDate, baseSalary: $baseSalary)';
}


}

/// @nodoc
abstract mixin class $ContractModelCopyWith<$Res>  {
  factory $ContractModelCopyWith(ContractModel value, $Res Function(ContractModel) _then) = _$ContractModelCopyWithImpl;
@useResult
$Res call({
 String id, String employeeId, ContractType type, String startDate, String? endDate, int baseSalary
});




}
/// @nodoc
class _$ContractModelCopyWithImpl<$Res>
    implements $ContractModelCopyWith<$Res> {
  _$ContractModelCopyWithImpl(this._self, this._then);

  final ContractModel _self;
  final $Res Function(ContractModel) _then;

/// Create a copy of ContractModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? employeeId = null,Object? type = null,Object? startDate = null,Object? endDate = freezed,Object? baseSalary = null,}) {
  return _then(ContractModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ContractType,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,baseSalary: null == baseSalary ? _self.baseSalary : baseSalary // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ContractModel].
extension ContractModelPatterns on ContractModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContractModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContractModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContractModel value)  $default,){
final _that = this;
switch (_that) {
case _ContractModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContractModel value)?  $default,){
final _that = this;
switch (_that) {
case _ContractModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String employeeId,  ContractType type,  String startDate,  String? endDate,  int baseSalary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContractModel() when $default != null:
return $default(_that.id,_that.employeeId,_that.type,_that.startDate,_that.endDate,_that.baseSalary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String employeeId,  ContractType type,  String startDate,  String? endDate,  int baseSalary)  $default,) {final _that = this;
switch (_that) {
case _ContractModel():
return $default(_that.id,_that.employeeId,_that.type,_that.startDate,_that.endDate,_that.baseSalary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String employeeId,  ContractType type,  String startDate,  String? endDate,  int baseSalary)?  $default,) {final _that = this;
switch (_that) {
case _ContractModel() when $default != null:
return $default(_that.id,_that.employeeId,_that.type,_that.startDate,_that.endDate,_that.baseSalary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContractModel implements ContractModel {
  const _ContractModel({required this.id, required this.employeeId, this.type = ContractType.permanent, required this.startDate, this.endDate, required this.baseSalary});
  factory _ContractModel.fromJson(Map<String, dynamic> json) => _$ContractModelFromJson(json);

@override final  String id;
@override final  String employeeId;
@override@JsonKey() final  ContractType type;
/// `AAAA-MM-DD`.
@override final  String startDate;
/// `AAAA-MM-DD`; obrigatório nos contratos que não são efectivos.
@override final  String? endDate;
/// Salário base mensal em cêntimos.
@override final  int baseSalary;

/// Create a copy of ContractModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContractModelCopyWith<_ContractModel> get copyWith => __$ContractModelCopyWithImpl<_ContractModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContractModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContractModel&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.type, type) || other.type == type)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.baseSalary, baseSalary) || other.baseSalary == baseSalary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeId,type,startDate,endDate,baseSalary);

@override
String toString() {
  return 'ContractModel(id: $id, employeeId: $employeeId, type: $type, startDate: $startDate, endDate: $endDate, baseSalary: $baseSalary)';
}


}

/// @nodoc
abstract mixin class _$ContractModelCopyWith<$Res> implements $ContractModelCopyWith<$Res> {
  factory _$ContractModelCopyWith(_ContractModel value, $Res Function(_ContractModel) _then) = __$ContractModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String employeeId, ContractType type, String startDate, String? endDate, int baseSalary
});




}
/// @nodoc
class __$ContractModelCopyWithImpl<$Res>
    implements _$ContractModelCopyWith<$Res> {
  __$ContractModelCopyWithImpl(this._self, this._then);

  final _ContractModel _self;
  final $Res Function(_ContractModel) _then;

/// Create a copy of ContractModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? employeeId = null,Object? type = null,Object? startDate = null,Object? endDate = freezed,Object? baseSalary = null,}) {
  return _then(_ContractModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ContractType,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,baseSalary: null == baseSalary ? _self.baseSalary : baseSalary // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
