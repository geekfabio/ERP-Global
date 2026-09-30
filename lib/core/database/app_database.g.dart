// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $StudentsTable extends Students
    with TableInfo<$StudentsTable, StudentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 26,
      maxTextLength: 26,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _institutionIdMeta = const VerificationMeta(
    'institutionId',
  );
  @override
  late final GeneratedColumn<String> institutionId = GeneratedColumn<String>(
    'institution_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _campusIdMeta = const VerificationMeta(
    'campusId',
  );
  @override
  late final GeneratedColumn<String> campusId = GeneratedColumn<String>(
    'campus_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _processNumberMeta = const VerificationMeta(
    'processNumber',
  );
  @override
  late final GeneratedColumn<String> processNumber = GeneratedColumn<String>(
    'process_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _searchTextMeta = const VerificationMeta(
    'searchText',
  );
  @override
  late final GeneratedColumn<String> searchText = GeneratedColumn<String>(
    'search_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoUrlMeta = const VerificationMeta(
    'photoUrl',
  );
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
    'photo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthPlaceMeta = const VerificationMeta(
    'birthPlace',
  );
  @override
  late final GeneratedColumn<String> birthPlace = GeneratedColumn<String>(
    'birth_place',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nationalityMeta = const VerificationMeta(
    'nationality',
  );
  @override
  late final GeneratedColumn<String> nationality = GeneratedColumn<String>(
    'nationality',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Angolana'),
  );
  static const VerificationMeta _idNumberMeta = const VerificationMeta(
    'idNumber',
  );
  @override
  late final GeneratedColumn<String> idNumber = GeneratedColumn<String>(
    'id_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nifMeta = const VerificationMeta('nif');
  @override
  late final GeneratedColumn<String> nif = GeneratedColumn<String>(
    'nif',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originSchoolMeta = const VerificationMeta(
    'originSchool',
  );
  @override
  late final GeneratedColumn<String> originSchool = GeneratedColumn<String>(
    'origin_school',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _healthJsonMeta = const VerificationMeta(
    'healthJson',
  );
  @override
  late final GeneratedColumn<String> healthJson = GeneratedColumn<String>(
    'health_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    institutionId,
    campusId,
    createdAt,
    updatedAt,
    deletedAt,
    syncState,
    processNumber,
    fullName,
    searchText,
    photoUrl,
    birthDate,
    birthPlace,
    gender,
    nationality,
    idNumber,
    nif,
    address,
    phone,
    email,
    originSchool,
    status,
    healthJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('institution_id')) {
      context.handle(
        _institutionIdMeta,
        institutionId.isAcceptableOrUnknown(
          data['institution_id']!,
          _institutionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_institutionIdMeta);
    }
    if (data.containsKey('campus_id')) {
      context.handle(
        _campusIdMeta,
        campusId.isAcceptableOrUnknown(data['campus_id']!, _campusIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('process_number')) {
      context.handle(
        _processNumberMeta,
        processNumber.isAcceptableOrUnknown(
          data['process_number']!,
          _processNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_processNumberMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('search_text')) {
      context.handle(
        _searchTextMeta,
        searchText.isAcceptableOrUnknown(data['search_text']!, _searchTextMeta),
      );
    } else if (isInserting) {
      context.missing(_searchTextMeta);
    }
    if (data.containsKey('photo_url')) {
      context.handle(
        _photoUrlMeta,
        photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    } else if (isInserting) {
      context.missing(_birthDateMeta);
    }
    if (data.containsKey('birth_place')) {
      context.handle(
        _birthPlaceMeta,
        birthPlace.isAcceptableOrUnknown(data['birth_place']!, _birthPlaceMeta),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('nationality')) {
      context.handle(
        _nationalityMeta,
        nationality.isAcceptableOrUnknown(
          data['nationality']!,
          _nationalityMeta,
        ),
      );
    }
    if (data.containsKey('id_number')) {
      context.handle(
        _idNumberMeta,
        idNumber.isAcceptableOrUnknown(data['id_number']!, _idNumberMeta),
      );
    }
    if (data.containsKey('nif')) {
      context.handle(
        _nifMeta,
        nif.isAcceptableOrUnknown(data['nif']!, _nifMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('origin_school')) {
      context.handle(
        _originSchoolMeta,
        originSchool.isAcceptableOrUnknown(
          data['origin_school']!,
          _originSchoolMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('health_json')) {
      context.handle(
        _healthJsonMeta,
        healthJson.isAcceptableOrUnknown(data['health_json']!, _healthJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      institutionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}institution_id'],
      )!,
      campusId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}campus_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      processNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}process_number'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      searchText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}search_text'],
      )!,
      photoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_url'],
      ),
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      )!,
      birthPlace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_place'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      )!,
      nationality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nationality'],
      )!,
      idNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_number'],
      ),
      nif: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nif'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      originSchool: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_school'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      healthJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}health_json'],
      )!,
    );
  }

  @override
  $StudentsTable createAlias(String alias) {
    return $StudentsTable(attachedDatabase, alias);
  }
}

class StudentRow extends DataClass implements Insertable<StudentRow> {
  final String id;
  final String institutionId;
  final String? campusId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncState;
  final String processNumber;
  final String fullName;

  /// `fullName` sem acentos/maiúsculas, para pesquisa e ordenação.
  final String searchText;
  final String? photoUrl;
  final DateTime birthDate;
  final String? birthPlace;
  final String gender;
  final String nationality;
  final String? idNumber;
  final String? nif;
  final String? address;
  final String? phone;
  final String? email;
  final String? originSchool;
  final String status;
  final String healthJson;
  const StudentRow({
    required this.id,
    required this.institutionId,
    this.campusId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncState,
    required this.processNumber,
    required this.fullName,
    required this.searchText,
    this.photoUrl,
    required this.birthDate,
    this.birthPlace,
    required this.gender,
    required this.nationality,
    this.idNumber,
    this.nif,
    this.address,
    this.phone,
    this.email,
    this.originSchool,
    required this.status,
    required this.healthJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['institution_id'] = Variable<String>(institutionId);
    if (!nullToAbsent || campusId != null) {
      map['campus_id'] = Variable<String>(campusId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_state'] = Variable<String>(syncState);
    map['process_number'] = Variable<String>(processNumber);
    map['full_name'] = Variable<String>(fullName);
    map['search_text'] = Variable<String>(searchText);
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    map['birth_date'] = Variable<DateTime>(birthDate);
    if (!nullToAbsent || birthPlace != null) {
      map['birth_place'] = Variable<String>(birthPlace);
    }
    map['gender'] = Variable<String>(gender);
    map['nationality'] = Variable<String>(nationality);
    if (!nullToAbsent || idNumber != null) {
      map['id_number'] = Variable<String>(idNumber);
    }
    if (!nullToAbsent || nif != null) {
      map['nif'] = Variable<String>(nif);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || originSchool != null) {
      map['origin_school'] = Variable<String>(originSchool);
    }
    map['status'] = Variable<String>(status);
    map['health_json'] = Variable<String>(healthJson);
    return map;
  }

  StudentsCompanion toCompanion(bool nullToAbsent) {
    return StudentsCompanion(
      id: Value(id),
      institutionId: Value(institutionId),
      campusId: campusId == null && nullToAbsent
          ? const Value.absent()
          : Value(campusId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncState: Value(syncState),
      processNumber: Value(processNumber),
      fullName: Value(fullName),
      searchText: Value(searchText),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      birthDate: Value(birthDate),
      birthPlace: birthPlace == null && nullToAbsent
          ? const Value.absent()
          : Value(birthPlace),
      gender: Value(gender),
      nationality: Value(nationality),
      idNumber: idNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(idNumber),
      nif: nif == null && nullToAbsent ? const Value.absent() : Value(nif),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      originSchool: originSchool == null && nullToAbsent
          ? const Value.absent()
          : Value(originSchool),
      status: Value(status),
      healthJson: Value(healthJson),
    );
  }

  factory StudentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentRow(
      id: serializer.fromJson<String>(json['id']),
      institutionId: serializer.fromJson<String>(json['institutionId']),
      campusId: serializer.fromJson<String?>(json['campusId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncState: serializer.fromJson<String>(json['syncState']),
      processNumber: serializer.fromJson<String>(json['processNumber']),
      fullName: serializer.fromJson<String>(json['fullName']),
      searchText: serializer.fromJson<String>(json['searchText']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      birthDate: serializer.fromJson<DateTime>(json['birthDate']),
      birthPlace: serializer.fromJson<String?>(json['birthPlace']),
      gender: serializer.fromJson<String>(json['gender']),
      nationality: serializer.fromJson<String>(json['nationality']),
      idNumber: serializer.fromJson<String?>(json['idNumber']),
      nif: serializer.fromJson<String?>(json['nif']),
      address: serializer.fromJson<String?>(json['address']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      originSchool: serializer.fromJson<String?>(json['originSchool']),
      status: serializer.fromJson<String>(json['status']),
      healthJson: serializer.fromJson<String>(json['healthJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'institutionId': serializer.toJson<String>(institutionId),
      'campusId': serializer.toJson<String?>(campusId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncState': serializer.toJson<String>(syncState),
      'processNumber': serializer.toJson<String>(processNumber),
      'fullName': serializer.toJson<String>(fullName),
      'searchText': serializer.toJson<String>(searchText),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'birthDate': serializer.toJson<DateTime>(birthDate),
      'birthPlace': serializer.toJson<String?>(birthPlace),
      'gender': serializer.toJson<String>(gender),
      'nationality': serializer.toJson<String>(nationality),
      'idNumber': serializer.toJson<String?>(idNumber),
      'nif': serializer.toJson<String?>(nif),
      'address': serializer.toJson<String?>(address),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'originSchool': serializer.toJson<String?>(originSchool),
      'status': serializer.toJson<String>(status),
      'healthJson': serializer.toJson<String>(healthJson),
    };
  }

  StudentRow copyWith({
    String? id,
    String? institutionId,
    Value<String?> campusId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncState,
    String? processNumber,
    String? fullName,
    String? searchText,
    Value<String?> photoUrl = const Value.absent(),
    DateTime? birthDate,
    Value<String?> birthPlace = const Value.absent(),
    String? gender,
    String? nationality,
    Value<String?> idNumber = const Value.absent(),
    Value<String?> nif = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> originSchool = const Value.absent(),
    String? status,
    String? healthJson,
  }) => StudentRow(
    id: id ?? this.id,
    institutionId: institutionId ?? this.institutionId,
    campusId: campusId.present ? campusId.value : this.campusId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncState: syncState ?? this.syncState,
    processNumber: processNumber ?? this.processNumber,
    fullName: fullName ?? this.fullName,
    searchText: searchText ?? this.searchText,
    photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
    birthDate: birthDate ?? this.birthDate,
    birthPlace: birthPlace.present ? birthPlace.value : this.birthPlace,
    gender: gender ?? this.gender,
    nationality: nationality ?? this.nationality,
    idNumber: idNumber.present ? idNumber.value : this.idNumber,
    nif: nif.present ? nif.value : this.nif,
    address: address.present ? address.value : this.address,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    originSchool: originSchool.present ? originSchool.value : this.originSchool,
    status: status ?? this.status,
    healthJson: healthJson ?? this.healthJson,
  );
  StudentRow copyWithCompanion(StudentsCompanion data) {
    return StudentRow(
      id: data.id.present ? data.id.value : this.id,
      institutionId: data.institutionId.present
          ? data.institutionId.value
          : this.institutionId,
      campusId: data.campusId.present ? data.campusId.value : this.campusId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      processNumber: data.processNumber.present
          ? data.processNumber.value
          : this.processNumber,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      searchText: data.searchText.present
          ? data.searchText.value
          : this.searchText,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      birthPlace: data.birthPlace.present
          ? data.birthPlace.value
          : this.birthPlace,
      gender: data.gender.present ? data.gender.value : this.gender,
      nationality: data.nationality.present
          ? data.nationality.value
          : this.nationality,
      idNumber: data.idNumber.present ? data.idNumber.value : this.idNumber,
      nif: data.nif.present ? data.nif.value : this.nif,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      originSchool: data.originSchool.present
          ? data.originSchool.value
          : this.originSchool,
      status: data.status.present ? data.status.value : this.status,
      healthJson: data.healthJson.present
          ? data.healthJson.value
          : this.healthJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudentRow(')
          ..write('id: $id, ')
          ..write('institutionId: $institutionId, ')
          ..write('campusId: $campusId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncState: $syncState, ')
          ..write('processNumber: $processNumber, ')
          ..write('fullName: $fullName, ')
          ..write('searchText: $searchText, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('birthDate: $birthDate, ')
          ..write('birthPlace: $birthPlace, ')
          ..write('gender: $gender, ')
          ..write('nationality: $nationality, ')
          ..write('idNumber: $idNumber, ')
          ..write('nif: $nif, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('originSchool: $originSchool, ')
          ..write('status: $status, ')
          ..write('healthJson: $healthJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    institutionId,
    campusId,
    createdAt,
    updatedAt,
    deletedAt,
    syncState,
    processNumber,
    fullName,
    searchText,
    photoUrl,
    birthDate,
    birthPlace,
    gender,
    nationality,
    idNumber,
    nif,
    address,
    phone,
    email,
    originSchool,
    status,
    healthJson,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentRow &&
          other.id == this.id &&
          other.institutionId == this.institutionId &&
          other.campusId == this.campusId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncState == this.syncState &&
          other.processNumber == this.processNumber &&
          other.fullName == this.fullName &&
          other.searchText == this.searchText &&
          other.photoUrl == this.photoUrl &&
          other.birthDate == this.birthDate &&
          other.birthPlace == this.birthPlace &&
          other.gender == this.gender &&
          other.nationality == this.nationality &&
          other.idNumber == this.idNumber &&
          other.nif == this.nif &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.originSchool == this.originSchool &&
          other.status == this.status &&
          other.healthJson == this.healthJson);
}

class StudentsCompanion extends UpdateCompanion<StudentRow> {
  final Value<String> id;
  final Value<String> institutionId;
  final Value<String?> campusId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncState;
  final Value<String> processNumber;
  final Value<String> fullName;
  final Value<String> searchText;
  final Value<String?> photoUrl;
  final Value<DateTime> birthDate;
  final Value<String?> birthPlace;
  final Value<String> gender;
  final Value<String> nationality;
  final Value<String?> idNumber;
  final Value<String?> nif;
  final Value<String?> address;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> originSchool;
  final Value<String> status;
  final Value<String> healthJson;
  final Value<int> rowid;
  const StudentsCompanion({
    this.id = const Value.absent(),
    this.institutionId = const Value.absent(),
    this.campusId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.processNumber = const Value.absent(),
    this.fullName = const Value.absent(),
    this.searchText = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.birthPlace = const Value.absent(),
    this.gender = const Value.absent(),
    this.nationality = const Value.absent(),
    this.idNumber = const Value.absent(),
    this.nif = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.originSchool = const Value.absent(),
    this.status = const Value.absent(),
    this.healthJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentsCompanion.insert({
    required String id,
    required String institutionId,
    this.campusId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    required String processNumber,
    required String fullName,
    required String searchText,
    this.photoUrl = const Value.absent(),
    required DateTime birthDate,
    this.birthPlace = const Value.absent(),
    required String gender,
    this.nationality = const Value.absent(),
    this.idNumber = const Value.absent(),
    this.nif = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.originSchool = const Value.absent(),
    this.status = const Value.absent(),
    this.healthJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       institutionId = Value(institutionId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       processNumber = Value(processNumber),
       fullName = Value(fullName),
       searchText = Value(searchText),
       birthDate = Value(birthDate),
       gender = Value(gender);
  static Insertable<StudentRow> custom({
    Expression<String>? id,
    Expression<String>? institutionId,
    Expression<String>? campusId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncState,
    Expression<String>? processNumber,
    Expression<String>? fullName,
    Expression<String>? searchText,
    Expression<String>? photoUrl,
    Expression<DateTime>? birthDate,
    Expression<String>? birthPlace,
    Expression<String>? gender,
    Expression<String>? nationality,
    Expression<String>? idNumber,
    Expression<String>? nif,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? originSchool,
    Expression<String>? status,
    Expression<String>? healthJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (institutionId != null) 'institution_id': institutionId,
      if (campusId != null) 'campus_id': campusId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncState != null) 'sync_state': syncState,
      if (processNumber != null) 'process_number': processNumber,
      if (fullName != null) 'full_name': fullName,
      if (searchText != null) 'search_text': searchText,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (birthDate != null) 'birth_date': birthDate,
      if (birthPlace != null) 'birth_place': birthPlace,
      if (gender != null) 'gender': gender,
      if (nationality != null) 'nationality': nationality,
      if (idNumber != null) 'id_number': idNumber,
      if (nif != null) 'nif': nif,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (originSchool != null) 'origin_school': originSchool,
      if (status != null) 'status': status,
      if (healthJson != null) 'health_json': healthJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentsCompanion copyWith({
    Value<String>? id,
    Value<String>? institutionId,
    Value<String?>? campusId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? syncState,
    Value<String>? processNumber,
    Value<String>? fullName,
    Value<String>? searchText,
    Value<String?>? photoUrl,
    Value<DateTime>? birthDate,
    Value<String?>? birthPlace,
    Value<String>? gender,
    Value<String>? nationality,
    Value<String?>? idNumber,
    Value<String?>? nif,
    Value<String?>? address,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String?>? originSchool,
    Value<String>? status,
    Value<String>? healthJson,
    Value<int>? rowid,
  }) {
    return StudentsCompanion(
      id: id ?? this.id,
      institutionId: institutionId ?? this.institutionId,
      campusId: campusId ?? this.campusId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncState: syncState ?? this.syncState,
      processNumber: processNumber ?? this.processNumber,
      fullName: fullName ?? this.fullName,
      searchText: searchText ?? this.searchText,
      photoUrl: photoUrl ?? this.photoUrl,
      birthDate: birthDate ?? this.birthDate,
      birthPlace: birthPlace ?? this.birthPlace,
      gender: gender ?? this.gender,
      nationality: nationality ?? this.nationality,
      idNumber: idNumber ?? this.idNumber,
      nif: nif ?? this.nif,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      originSchool: originSchool ?? this.originSchool,
      status: status ?? this.status,
      healthJson: healthJson ?? this.healthJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (institutionId.present) {
      map['institution_id'] = Variable<String>(institutionId.value);
    }
    if (campusId.present) {
      map['campus_id'] = Variable<String>(campusId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (processNumber.present) {
      map['process_number'] = Variable<String>(processNumber.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (searchText.present) {
      map['search_text'] = Variable<String>(searchText.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (birthPlace.present) {
      map['birth_place'] = Variable<String>(birthPlace.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (nationality.present) {
      map['nationality'] = Variable<String>(nationality.value);
    }
    if (idNumber.present) {
      map['id_number'] = Variable<String>(idNumber.value);
    }
    if (nif.present) {
      map['nif'] = Variable<String>(nif.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (originSchool.present) {
      map['origin_school'] = Variable<String>(originSchool.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (healthJson.present) {
      map['health_json'] = Variable<String>(healthJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsCompanion(')
          ..write('id: $id, ')
          ..write('institutionId: $institutionId, ')
          ..write('campusId: $campusId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncState: $syncState, ')
          ..write('processNumber: $processNumber, ')
          ..write('fullName: $fullName, ')
          ..write('searchText: $searchText, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('birthDate: $birthDate, ')
          ..write('birthPlace: $birthPlace, ')
          ..write('gender: $gender, ')
          ..write('nationality: $nationality, ')
          ..write('idNumber: $idNumber, ')
          ..write('nif: $nif, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('originSchool: $originSchool, ')
          ..write('status: $status, ')
          ..write('healthJson: $healthJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOutboxTable extends SyncOutbox
    with TableInfo<$SyncOutboxTable, OutboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    seq,
    entity,
    entityId,
    operation,
    payload,
    createdAt,
    attempts,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    }
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {seq};
  @override
  OutboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxRow(
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }
}

class OutboxRow extends DataClass implements Insertable<OutboxRow> {
  final int seq;
  final String entity;
  final String entityId;

  /// `create` | `update` | `delete`.
  final String operation;
  final String payload;
  final DateTime createdAt;
  final int attempts;
  const OutboxRow({
    required this.seq,
    required this.entity,
    required this.entityId,
    required this.operation,
    required this.payload,
    required this.createdAt,
    required this.attempts,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['seq'] = Variable<int>(seq);
    map['entity'] = Variable<String>(entity);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempts'] = Variable<int>(attempts);
    return map;
  }

  SyncOutboxCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxCompanion(
      seq: Value(seq),
      entity: Value(entity),
      entityId: Value(entityId),
      operation: Value(operation),
      payload: Value(payload),
      createdAt: Value(createdAt),
      attempts: Value(attempts),
    );
  }

  factory OutboxRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxRow(
      seq: serializer.fromJson<int>(json['seq']),
      entity: serializer.fromJson<String>(json['entity']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seq': serializer.toJson<int>(seq),
      'entity': serializer.toJson<String>(entity),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attempts': serializer.toJson<int>(attempts),
    };
  }

  OutboxRow copyWith({
    int? seq,
    String? entity,
    String? entityId,
    String? operation,
    String? payload,
    DateTime? createdAt,
    int? attempts,
  }) => OutboxRow(
    seq: seq ?? this.seq,
    entity: entity ?? this.entity,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    attempts: attempts ?? this.attempts,
  );
  OutboxRow copyWithCompanion(SyncOutboxCompanion data) {
    return OutboxRow(
      seq: data.seq.present ? data.seq.value : this.seq,
      entity: data.entity.present ? data.entity.value : this.entity,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxRow(')
          ..write('seq: $seq, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    seq,
    entity,
    entityId,
    operation,
    payload,
    createdAt,
    attempts,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxRow &&
          other.seq == this.seq &&
          other.entity == this.entity &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.attempts == this.attempts);
}

class SyncOutboxCompanion extends UpdateCompanion<OutboxRow> {
  final Value<int> seq;
  final Value<String> entity;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<int> attempts;
  const SyncOutboxCompanion({
    this.seq = const Value.absent(),
    this.entity = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attempts = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    this.seq = const Value.absent(),
    required String entity,
    required String entityId,
    required String operation,
    this.payload = const Value.absent(),
    required DateTime createdAt,
    this.attempts = const Value.absent(),
  }) : entity = Value(entity),
       entityId = Value(entityId),
       operation = Value(operation),
       createdAt = Value(createdAt);
  static Insertable<OutboxRow> custom({
    Expression<int>? seq,
    Expression<String>? entity,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? attempts,
  }) {
    return RawValuesInsertable({
      if (seq != null) 'seq': seq,
      if (entity != null) 'entity': entity,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (attempts != null) 'attempts': attempts,
    });
  }

  SyncOutboxCompanion copyWith({
    Value<int>? seq,
    Value<String>? entity,
    Value<String>? entityId,
    Value<String>? operation,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<int>? attempts,
  }) {
    return SyncOutboxCompanion(
      seq: seq ?? this.seq,
      entity: entity ?? this.entity,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      attempts: attempts ?? this.attempts,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxCompanion(')
          ..write('seq: $seq, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StudentsTable students = $StudentsTable(this);
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [students, syncOutbox];
}

typedef $$StudentsTableCreateCompanionBuilder =
    StudentsCompanion Function({
      required String id,
      required String institutionId,
      Value<String?> campusId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncState,
      required String processNumber,
      required String fullName,
      required String searchText,
      Value<String?> photoUrl,
      required DateTime birthDate,
      Value<String?> birthPlace,
      required String gender,
      Value<String> nationality,
      Value<String?> idNumber,
      Value<String?> nif,
      Value<String?> address,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> originSchool,
      Value<String> status,
      Value<String> healthJson,
      Value<int> rowid,
    });
typedef $$StudentsTableUpdateCompanionBuilder =
    StudentsCompanion Function({
      Value<String> id,
      Value<String> institutionId,
      Value<String?> campusId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncState,
      Value<String> processNumber,
      Value<String> fullName,
      Value<String> searchText,
      Value<String?> photoUrl,
      Value<DateTime> birthDate,
      Value<String?> birthPlace,
      Value<String> gender,
      Value<String> nationality,
      Value<String?> idNumber,
      Value<String?> nif,
      Value<String?> address,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> originSchool,
      Value<String> status,
      Value<String> healthJson,
      Value<int> rowid,
    });

class $$StudentsTableFilterComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get institutionId => $composableBuilder(
    column: $table.institutionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get campusId => $composableBuilder(
    column: $table.campusId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get processNumber => $composableBuilder(
    column: $table.processNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get searchText => $composableBuilder(
    column: $table.searchText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get birthPlace => $composableBuilder(
    column: $table.birthPlace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nationality => $composableBuilder(
    column: $table.nationality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idNumber => $composableBuilder(
    column: $table.idNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nif => $composableBuilder(
    column: $table.nif,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originSchool => $composableBuilder(
    column: $table.originSchool,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get healthJson => $composableBuilder(
    column: $table.healthJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get institutionId => $composableBuilder(
    column: $table.institutionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get campusId => $composableBuilder(
    column: $table.campusId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get processNumber => $composableBuilder(
    column: $table.processNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get searchText => $composableBuilder(
    column: $table.searchText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthPlace => $composableBuilder(
    column: $table.birthPlace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nationality => $composableBuilder(
    column: $table.nationality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idNumber => $composableBuilder(
    column: $table.idNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nif => $composableBuilder(
    column: $table.nif,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originSchool => $composableBuilder(
    column: $table.originSchool,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get healthJson => $composableBuilder(
    column: $table.healthJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get institutionId => $composableBuilder(
    column: $table.institutionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get campusId =>
      $composableBuilder(column: $table.campusId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<String> get processNumber => $composableBuilder(
    column: $table.processNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get searchText => $composableBuilder(
    column: $table.searchText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get birthPlace => $composableBuilder(
    column: $table.birthPlace,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get nationality => $composableBuilder(
    column: $table.nationality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get idNumber =>
      $composableBuilder(column: $table.idNumber, builder: (column) => column);

  GeneratedColumn<String> get nif =>
      $composableBuilder(column: $table.nif, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get originSchool => $composableBuilder(
    column: $table.originSchool,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get healthJson => $composableBuilder(
    column: $table.healthJson,
    builder: (column) => column,
  );
}

class $$StudentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudentsTable,
          StudentRow,
          $$StudentsTableFilterComposer,
          $$StudentsTableOrderingComposer,
          $$StudentsTableAnnotationComposer,
          $$StudentsTableCreateCompanionBuilder,
          $$StudentsTableUpdateCompanionBuilder,
          (
            StudentRow,
            BaseReferences<_$AppDatabase, $StudentsTable, StudentRow>,
          ),
          StudentRow,
          PrefetchHooks Function()
        > {
  $$StudentsTableTableManager(_$AppDatabase db, $StudentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> institutionId = const Value.absent(),
                Value<String?> campusId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncState = const Value.absent(),
                Value<String> processNumber = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> searchText = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<DateTime> birthDate = const Value.absent(),
                Value<String?> birthPlace = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<String> nationality = const Value.absent(),
                Value<String?> idNumber = const Value.absent(),
                Value<String?> nif = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> originSchool = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> healthJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentsCompanion(
                id: id,
                institutionId: institutionId,
                campusId: campusId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncState: syncState,
                processNumber: processNumber,
                fullName: fullName,
                searchText: searchText,
                photoUrl: photoUrl,
                birthDate: birthDate,
                birthPlace: birthPlace,
                gender: gender,
                nationality: nationality,
                idNumber: idNumber,
                nif: nif,
                address: address,
                phone: phone,
                email: email,
                originSchool: originSchool,
                status: status,
                healthJson: healthJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String institutionId,
                Value<String?> campusId = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncState = const Value.absent(),
                required String processNumber,
                required String fullName,
                required String searchText,
                Value<String?> photoUrl = const Value.absent(),
                required DateTime birthDate,
                Value<String?> birthPlace = const Value.absent(),
                required String gender,
                Value<String> nationality = const Value.absent(),
                Value<String?> idNumber = const Value.absent(),
                Value<String?> nif = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> originSchool = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> healthJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentsCompanion.insert(
                id: id,
                institutionId: institutionId,
                campusId: campusId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncState: syncState,
                processNumber: processNumber,
                fullName: fullName,
                searchText: searchText,
                photoUrl: photoUrl,
                birthDate: birthDate,
                birthPlace: birthPlace,
                gender: gender,
                nationality: nationality,
                idNumber: idNumber,
                nif: nif,
                address: address,
                phone: phone,
                email: email,
                originSchool: originSchool,
                status: status,
                healthJson: healthJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StudentsTable, StudentRow>(table),
                  BaseReferences<_$AppDatabase, $StudentsTable, StudentRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudentsTable,
      StudentRow,
      $$StudentsTableFilterComposer,
      $$StudentsTableOrderingComposer,
      $$StudentsTableAnnotationComposer,
      $$StudentsTableCreateCompanionBuilder,
      $$StudentsTableUpdateCompanionBuilder,
      (StudentRow, BaseReferences<_$AppDatabase, $StudentsTable, StudentRow>),
      StudentRow,
      PrefetchHooks Function()
    >;
typedef $$SyncOutboxTableCreateCompanionBuilder =
    SyncOutboxCompanion Function({
      Value<int> seq,
      required String entity,
      required String entityId,
      required String operation,
      Value<String> payload,
      required DateTime createdAt,
      Value<int> attempts,
    });
typedef $$SyncOutboxTableUpdateCompanionBuilder =
    SyncOutboxCompanion Function({
      Value<int> seq,
      Value<String> entity,
      Value<String> entityId,
      Value<String> operation,
      Value<String> payload,
      Value<DateTime> createdAt,
      Value<int> attempts,
    });

class $$SyncOutboxTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);
}

class $$SyncOutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOutboxTable,
          OutboxRow,
          $$SyncOutboxTableFilterComposer,
          $$SyncOutboxTableOrderingComposer,
          $$SyncOutboxTableAnnotationComposer,
          $$SyncOutboxTableCreateCompanionBuilder,
          $$SyncOutboxTableUpdateCompanionBuilder,
          (
            OutboxRow,
            BaseReferences<_$AppDatabase, $SyncOutboxTable, OutboxRow>,
          ),
          OutboxRow,
          PrefetchHooks Function()
        > {
  $$SyncOutboxTableTableManager(_$AppDatabase db, $SyncOutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                Value<String> entity = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
              }) => SyncOutboxCompanion(
                seq: seq,
                entity: entity,
                entityId: entityId,
                operation: operation,
                payload: payload,
                createdAt: createdAt,
                attempts: attempts,
              ),
          createCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                required String entity,
                required String entityId,
                required String operation,
                Value<String> payload = const Value.absent(),
                required DateTime createdAt,
                Value<int> attempts = const Value.absent(),
              }) => SyncOutboxCompanion.insert(
                seq: seq,
                entity: entity,
                entityId: entityId,
                operation: operation,
                payload: payload,
                createdAt: createdAt,
                attempts: attempts,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncOutboxTable, OutboxRow>(table),
                  BaseReferences<_$AppDatabase, $SyncOutboxTable, OutboxRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOutboxTable,
      OutboxRow,
      $$SyncOutboxTableFilterComposer,
      $$SyncOutboxTableOrderingComposer,
      $$SyncOutboxTableAnnotationComposer,
      $$SyncOutboxTableCreateCompanionBuilder,
      $$SyncOutboxTableUpdateCompanionBuilder,
      (OutboxRow, BaseReferences<_$AppDatabase, $SyncOutboxTable, OutboxRow>),
      OutboxRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db, _db.students);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
}
