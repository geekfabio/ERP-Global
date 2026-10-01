// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudentAccount {

 String get id; String get institutionId; String? get campusId;@UtcDateTimeConverter() DateTime get createdAt;@UtcDateTimeConverter() DateTime get updatedAt;@UtcDateTimeConverter() DateTime? get deletedAt; String get syncState; String get studentId;@MinorUnitConverter() int get balanceMinor; List<LedgerEntry> get entries;
/// Create a copy of StudentAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentAccountCopyWith<StudentAccount> get copyWith => _$StudentAccountCopyWithImpl<StudentAccount>(this as StudentAccount, _$identity);

  /// Serializes this StudentAccount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.balanceMinor, balanceMinor) || other.balanceMinor == balanceMinor)&&const DeepCollectionEquality().equals(other.entries, entries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,campusId,createdAt,updatedAt,deletedAt,syncState,studentId,balanceMinor,const DeepCollectionEquality().hash(entries));

@override
String toString() {
  return 'StudentAccount(id: $id, institutionId: $institutionId, campusId: $campusId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, studentId: $studentId, balanceMinor: $balanceMinor, entries: $entries)';
}


}

/// @nodoc
abstract mixin class $StudentAccountCopyWith<$Res>  {
  factory $StudentAccountCopyWith(StudentAccount value, $Res Function(StudentAccount) _then) = _$StudentAccountCopyWithImpl;
@useResult
$Res call({
 String id, String institutionId, String? campusId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String studentId,@MinorUnitConverter() int balanceMinor, List<LedgerEntry> entries
});




}
/// @nodoc
class _$StudentAccountCopyWithImpl<$Res>
    implements $StudentAccountCopyWith<$Res> {
  _$StudentAccountCopyWithImpl(this._self, this._then);

  final StudentAccount _self;
  final $Res Function(StudentAccount) _then;

/// Create a copy of StudentAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? institutionId = null,Object? campusId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? studentId = null,Object? balanceMinor = null,Object? entries = null,}) {
  return _then(StudentAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,balanceMinor: null == balanceMinor ? _self.balanceMinor : balanceMinor // ignore: cast_nullable_to_non_nullable
as int,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<LedgerEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentAccount].
extension StudentAccountPatterns on StudentAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentAccount value)  $default,){
final _that = this;
switch (_that) {
case _StudentAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentAccount value)?  $default,){
final _that = this;
switch (_that) {
case _StudentAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId, @MinorUnitConverter()  int balanceMinor,  List<LedgerEntry> entries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentAccount() when $default != null:
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.balanceMinor,_that.entries);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId, @MinorUnitConverter()  int balanceMinor,  List<LedgerEntry> entries)  $default,) {final _that = this;
switch (_that) {
case _StudentAccount():
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.balanceMinor,_that.entries);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String institutionId,  String? campusId, @UtcDateTimeConverter()  DateTime createdAt, @UtcDateTimeConverter()  DateTime updatedAt, @UtcDateTimeConverter()  DateTime? deletedAt,  String syncState,  String studentId, @MinorUnitConverter()  int balanceMinor,  List<LedgerEntry> entries)?  $default,) {final _that = this;
switch (_that) {
case _StudentAccount() when $default != null:
return $default(_that.id,_that.institutionId,_that.campusId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.syncState,_that.studentId,_that.balanceMinor,_that.entries);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _StudentAccount implements StudentAccount {
  const _StudentAccount({required this.id, required this.institutionId, this.campusId, @UtcDateTimeConverter() required this.createdAt, @UtcDateTimeConverter() required this.updatedAt, @UtcDateTimeConverter() this.deletedAt, this.syncState = 'synced', required this.studentId, @MinorUnitConverter() required this.balanceMinor,  List<LedgerEntry> entries = const <LedgerEntry>[]}): _entries = entries;
  factory _StudentAccount.fromJson(Map<String, dynamic> json) => _$StudentAccountFromJson(json);

@override final  String id;
@override final  String institutionId;
@override final  String? campusId;
@override@UtcDateTimeConverter() final  DateTime createdAt;
@override@UtcDateTimeConverter() final  DateTime updatedAt;
@override@UtcDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  String syncState;
@override final  String studentId;
@override@MinorUnitConverter() final  int balanceMinor;
 final  List<LedgerEntry> _entries;
@override@JsonKey() List<LedgerEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}


/// Create a copy of StudentAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentAccountCopyWith<_StudentAccount> get copyWith => __$StudentAccountCopyWithImpl<_StudentAccount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentAccountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.institutionId, institutionId) || other.institutionId == institutionId)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.balanceMinor, balanceMinor) || other.balanceMinor == balanceMinor)&&const DeepCollectionEquality().equals(other._entries, _entries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,institutionId,campusId,createdAt,updatedAt,deletedAt,syncState,studentId,balanceMinor,const DeepCollectionEquality().hash(_entries));

@override
String toString() {
  return 'StudentAccount(id: $id, institutionId: $institutionId, campusId: $campusId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncState: $syncState, studentId: $studentId, balanceMinor: $balanceMinor, entries: $entries)';
}


}

/// @nodoc
abstract mixin class _$StudentAccountCopyWith<$Res> implements $StudentAccountCopyWith<$Res> {
  factory _$StudentAccountCopyWith(_StudentAccount value, $Res Function(_StudentAccount) _then) = __$StudentAccountCopyWithImpl;
@override @useResult
$Res call({
 String id, String institutionId, String? campusId,@UtcDateTimeConverter() DateTime createdAt,@UtcDateTimeConverter() DateTime updatedAt,@UtcDateTimeConverter() DateTime? deletedAt, String syncState, String studentId,@MinorUnitConverter() int balanceMinor, List<LedgerEntry> entries
});




}
/// @nodoc
class __$StudentAccountCopyWithImpl<$Res>
    implements _$StudentAccountCopyWith<$Res> {
  __$StudentAccountCopyWithImpl(this._self, this._then);

  final _StudentAccount _self;
  final $Res Function(_StudentAccount) _then;

/// Create a copy of StudentAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? institutionId = null,Object? campusId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncState = null,Object? studentId = null,Object? balanceMinor = null,Object? entries = null,}) {
  return _then(_StudentAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,institutionId: null == institutionId ? _self.institutionId : institutionId // ignore: cast_nullable_to_non_nullable
as String,campusId: freezed == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,balanceMinor: null == balanceMinor ? _self.balanceMinor : balanceMinor // ignore: cast_nullable_to_non_nullable
as int,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<LedgerEntry>,
  ));
}


}


/// @nodoc
mixin _$LedgerEntry {

 String get id; String get referenceId;@UtcDateTimeConverter() DateTime get occurredAt;@MinorUnitConverter() int get debitMinor;@MinorUnitConverter() int get creditMinor;
/// Create a copy of LedgerEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LedgerEntryCopyWith<LedgerEntry> get copyWith => _$LedgerEntryCopyWithImpl<LedgerEntry>(this as LedgerEntry, _$identity);

  /// Serializes this LedgerEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LedgerEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.debitMinor, debitMinor) || other.debitMinor == debitMinor)&&(identical(other.creditMinor, creditMinor) || other.creditMinor == creditMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,referenceId,occurredAt,debitMinor,creditMinor);

@override
String toString() {
  return 'LedgerEntry(id: $id, referenceId: $referenceId, occurredAt: $occurredAt, debitMinor: $debitMinor, creditMinor: $creditMinor)';
}


}

/// @nodoc
abstract mixin class $LedgerEntryCopyWith<$Res>  {
  factory $LedgerEntryCopyWith(LedgerEntry value, $Res Function(LedgerEntry) _then) = _$LedgerEntryCopyWithImpl;
@useResult
$Res call({
 String id, String referenceId,@UtcDateTimeConverter() DateTime occurredAt,@MinorUnitConverter() int debitMinor,@MinorUnitConverter() int creditMinor
});




}
/// @nodoc
class _$LedgerEntryCopyWithImpl<$Res>
    implements $LedgerEntryCopyWith<$Res> {
  _$LedgerEntryCopyWithImpl(this._self, this._then);

  final LedgerEntry _self;
  final $Res Function(LedgerEntry) _then;

/// Create a copy of LedgerEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? referenceId = null,Object? occurredAt = null,Object? debitMinor = null,Object? creditMinor = null,}) {
  return _then(LedgerEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,referenceId: null == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,debitMinor: null == debitMinor ? _self.debitMinor : debitMinor // ignore: cast_nullable_to_non_nullable
as int,creditMinor: null == creditMinor ? _self.creditMinor : creditMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LedgerEntry].
extension LedgerEntryPatterns on LedgerEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LedgerEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LedgerEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LedgerEntry value)  $default,){
final _that = this;
switch (_that) {
case _LedgerEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LedgerEntry value)?  $default,){
final _that = this;
switch (_that) {
case _LedgerEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String referenceId, @UtcDateTimeConverter()  DateTime occurredAt, @MinorUnitConverter()  int debitMinor, @MinorUnitConverter()  int creditMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LedgerEntry() when $default != null:
return $default(_that.id,_that.referenceId,_that.occurredAt,_that.debitMinor,_that.creditMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String referenceId, @UtcDateTimeConverter()  DateTime occurredAt, @MinorUnitConverter()  int debitMinor, @MinorUnitConverter()  int creditMinor)  $default,) {final _that = this;
switch (_that) {
case _LedgerEntry():
return $default(_that.id,_that.referenceId,_that.occurredAt,_that.debitMinor,_that.creditMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String referenceId, @UtcDateTimeConverter()  DateTime occurredAt, @MinorUnitConverter()  int debitMinor, @MinorUnitConverter()  int creditMinor)?  $default,) {final _that = this;
switch (_that) {
case _LedgerEntry() when $default != null:
return $default(_that.id,_that.referenceId,_that.occurredAt,_that.debitMinor,_that.creditMinor);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _LedgerEntry implements LedgerEntry {
  const _LedgerEntry({required this.id, required this.referenceId, @UtcDateTimeConverter() required this.occurredAt, @MinorUnitConverter() required this.debitMinor, @MinorUnitConverter() required this.creditMinor});
  factory _LedgerEntry.fromJson(Map<String, dynamic> json) => _$LedgerEntryFromJson(json);

@override final  String id;
@override final  String referenceId;
@override@UtcDateTimeConverter() final  DateTime occurredAt;
@override@MinorUnitConverter() final  int debitMinor;
@override@MinorUnitConverter() final  int creditMinor;

/// Create a copy of LedgerEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LedgerEntryCopyWith<_LedgerEntry> get copyWith => __$LedgerEntryCopyWithImpl<_LedgerEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LedgerEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LedgerEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.debitMinor, debitMinor) || other.debitMinor == debitMinor)&&(identical(other.creditMinor, creditMinor) || other.creditMinor == creditMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,referenceId,occurredAt,debitMinor,creditMinor);

@override
String toString() {
  return 'LedgerEntry(id: $id, referenceId: $referenceId, occurredAt: $occurredAt, debitMinor: $debitMinor, creditMinor: $creditMinor)';
}


}

/// @nodoc
abstract mixin class _$LedgerEntryCopyWith<$Res> implements $LedgerEntryCopyWith<$Res> {
  factory _$LedgerEntryCopyWith(_LedgerEntry value, $Res Function(_LedgerEntry) _then) = __$LedgerEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String referenceId,@UtcDateTimeConverter() DateTime occurredAt,@MinorUnitConverter() int debitMinor,@MinorUnitConverter() int creditMinor
});




}
/// @nodoc
class __$LedgerEntryCopyWithImpl<$Res>
    implements _$LedgerEntryCopyWith<$Res> {
  __$LedgerEntryCopyWithImpl(this._self, this._then);

  final _LedgerEntry _self;
  final $Res Function(_LedgerEntry) _then;

/// Create a copy of LedgerEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? referenceId = null,Object? occurredAt = null,Object? debitMinor = null,Object? creditMinor = null,}) {
  return _then(_LedgerEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,referenceId: null == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,debitMinor: null == debitMinor ? _self.debitMinor : debitMinor // ignore: cast_nullable_to_non_nullable
as int,creditMinor: null == creditMinor ? _self.creditMinor : creditMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
