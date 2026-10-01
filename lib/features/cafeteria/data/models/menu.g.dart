// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MealType _$MealTypeFromJson(Map<String, dynamic> json) => _MealType(
  id: json['id'] as String,
  name: json['name'] as String,
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
  priceMinor: (json['priceMinor'] as num?)?.toInt() ?? 0,
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$MealTypeToJson(_MealType instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'priceMinor': instance.priceMinor,
  'isActive': instance.isActive,
};

_MealItem _$MealItemFromJson(Map<String, dynamic> json) => _MealItem(
  id: json['id'] as String,
  name: json['name'] as String,
  mealTypeId: json['mealTypeId'] as String,
  priceMinor: (json['priceMinor'] as num?)?.toInt() ?? 0,
  allergens:
      (json['allergens'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$AllergenEnumMap, e))
          .toList() ??
      const <Allergen>[],
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$MealItemToJson(_MealItem instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'mealTypeId': instance.mealTypeId,
  'priceMinor': instance.priceMinor,
  'allergens': instance.allergens.map((e) => _$AllergenEnumMap[e]!).toList(),
  'isActive': instance.isActive,
};

const _$AllergenEnumMap = {
  Allergen.gluten: 'gluten',
  Allergen.lactose: 'lactose',
  Allergen.eggs: 'eggs',
  Allergen.fish: 'fish',
  Allergen.shellfish: 'shellfish',
  Allergen.peanuts: 'peanuts',
  Allergen.nuts: 'nuts',
  Allergen.soy: 'soy',
  Allergen.celery: 'celery',
  Allergen.sesame: 'sesame',
};

_MealMenu _$MealMenuFromJson(Map<String, dynamic> json) => _MealMenu(
  id: json['id'] as String,
  date: json['date'] as String,
  mealTypeId: json['mealTypeId'] as String,
  itemIds:
      (json['itemIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$MealMenuToJson(_MealMenu instance) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date,
  'mealTypeId': instance.mealTypeId,
  'itemIds': instance.itemIds,
};
