import 'package:json_annotation/json_annotation.dart';
import 'package:weather_alarming/models/weather_forecast.dart';


part 'alarm_rules.g.dart';

abstract class AlarmRule {
  final String type;

  AlarmRule(this.type);

  bool isFulfilled(WeatherForecast forecast);

  factory AlarmRule.fromJson(Map<String, dynamic> json) {
    switch (json["type"] as String) {
      case WindDirectionAlarmRule.WIND_DIRECTION_ALARM_RULE_TYPE:
        return WindDirectionAlarmRule.fromJson(json);
      case TemperatureAlarmRule.TEMPERATURE_ALARM_RULE_TYPE:
        return TemperatureAlarmRule.fromJson(json);
      default:
        throw StateError(
          "Unknown type ${json['type']} when deserializing type AlarmRule",
        );
    }
  }

  Map<String, dynamic> toJson() => {"type": type};
}

@JsonSerializable()
class WindDirectionAlarmRule extends AlarmRule {
  // would like to use (WindDirectionAlarmRule).toString()
  static const String WIND_DIRECTION_ALARM_RULE_TYPE = "WindDirectionAlarmRule";

  List<String> allowedDirections;

  WindDirectionAlarmRule({this.allowedDirections = const []})
      : super(WIND_DIRECTION_ALARM_RULE_TYPE);

  @override
  bool isFulfilled(WeatherForecast forecast) {
    return true;
  }

  factory WindDirectionAlarmRule.fromJson(Map<String, dynamic> json) =>
      _$WindDirectionAlarmRuleFromJson(json);

  @override
  Map<String, dynamic> toJson() {
    var map = super.toJson();
    map.addAll(_$WindDirectionAlarmRuleToJson(this));
    return map;
  }
}

@JsonSerializable()
class TemperatureAlarmRule extends AlarmRule {
  static const String TEMPERATURE_ALARM_RULE_TYPE = "TemperatureAlarmRule";

  double minTemperature;
  double maxTemperature;

  TemperatureAlarmRule({
    this.minTemperature = 10,
    this.maxTemperature = 30,
  }) : super((TemperatureAlarmRule).toString());

  @override
  bool isFulfilled(WeatherForecast forecast) {
    double currentTemperature = forecast.temperature2m;
    return currentTemperature >= minTemperature &&
        currentTemperature <= maxTemperature;
  }

  factory TemperatureAlarmRule.fromJson(Map<String, dynamic> json) =>
      _$TemperatureAlarmRuleFromJson(json);

  @override
  Map<String, dynamic> toJson() {
    var map = super.toJson();
    map.addAll(_$TemperatureAlarmRuleToJson(this));
    return map;
  }
}
