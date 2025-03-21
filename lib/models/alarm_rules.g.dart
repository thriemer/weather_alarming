// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_rules.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WindDirectionAlarmRule _$WindDirectionAlarmRuleFromJson(
  Map<String, dynamic> json,
) => WindDirectionAlarmRule(
  allowedDirections:
      (json['allowedDirections'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$WindDirectionAlarmRuleToJson(
  WindDirectionAlarmRule instance,
) => <String, dynamic>{'allowedDirections': instance.allowedDirections};

TemperatureAlarmRule _$TemperatureAlarmRuleFromJson(
  Map<String, dynamic> json,
) => TemperatureAlarmRule(
  minTemperature: (json['minTemperature'] as num?)?.toDouble() ?? 10,
  maxTemperature: (json['maxTemperature'] as num?)?.toDouble() ?? 30,
);

Map<String, dynamic> _$TemperatureAlarmRuleToJson(
  TemperatureAlarmRule instance,
) => <String, dynamic>{
  'minTemperature': instance.minTemperature,
  'maxTemperature': instance.maxTemperature,
};
