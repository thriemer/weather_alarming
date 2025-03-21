// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlarmDefinition _$AlarmDefinitionFromJson(Map<String, dynamic> json) =>
    AlarmDefinition(json['name'] as String)
      ..id = json['id'] as String
      ..description = json['description'] as String
      ..lon = (json['lon'] as num).toDouble()
      ..lat = (json['lat'] as num).toDouble()
      ..rules =
          (json['rules'] as List<dynamic>)
              .map((e) => AlarmRule.fromJson(e as Map<String, dynamic>))
              .toList();

Map<String, dynamic> _$AlarmDefinitionToJson(AlarmDefinition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'lon': instance.lon,
      'lat': instance.lat,
      'rules': instance.rules,
    };
