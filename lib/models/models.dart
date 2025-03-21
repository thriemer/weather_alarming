import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:weather_alarming/models/weather_forecast.dart';
import 'package:weather_alarming/service/weather_fetch.dart';

import 'alarm_rules.dart';

part 'models.g.dart';

@JsonSerializable()
class AlarmDefinition {
  String id;
  String name;
  String description;
  double lon;
  double lat;
  List<AlarmRule> rules;
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<WeatherForecast> forecast;

  Map<DateTime, AlarmState> calculateAlarmState() {
    return {
      for (var f in forecast)
        f.time: AlarmState(dateTime: f.time, triggered: isTriggered(f)),
    };
  }

  bool isTriggered(WeatherForecast forecast) {
    bool triggered = true;
    for (var r in rules) {
      triggered = triggered && r.isFulfilled(forecast);
    }
    return triggered;
  }

  AlarmDefinition.full(
    this.id,
    this.name,
    this.description,
    this.lat,
    this.lon,
    this.rules,
    this.forecast,
  );

  AlarmDefinition(this.name)
    : id = Uuid().v4(),
      description = "",
      lat = 0.0,
      lon = 0.0,
      rules = [],
      forecast = [];

  factory AlarmDefinition.fromJson(Map<String, dynamic> json) =>
      _$AlarmDefinitionFromJson(json);

  Map<String, dynamic> toJson() => _$AlarmDefinitionToJson(this);
}

class AlarmState {
  DateTime dateTime;
  bool triggered;

  AlarmState({required this.dateTime, required this.triggered});
}

class AppState extends ChangeNotifier {
  static const String ALARM_DEFINITIONS_KEY_NAME = "alarmDefinitions";

  final List<AlarmDefinition> _alarmDefinitions = [];

  UnmodifiableListView<AlarmDefinition> get alarmDefinitions =>
      UnmodifiableListView(_alarmDefinitions);

  void loadFromDisk() {
    SharedPreferences.getInstance().then((sp) {
      List<String>? items = sp.getStringList(ALARM_DEFINITIONS_KEY_NAME);
      if (items == null) return;
      for (var elem in items) {
        var alarmDef = AlarmDefinition.fromJson(jsonDecode(elem));
        updateForecastForAlarm(alarmDef);
        _alarmDefinitions.add(alarmDef);
      }
      notifyListeners();
    });
  }

  void add(AlarmDefinition alarm) {
    updateForecastForAlarm(alarm);
    _alarmDefinitions.add(alarm);
    notifyListeners();
    safeToDisk();
  }

  void remove(AlarmDefinition alarm) {
    _alarmDefinitions.remove(alarm);
    notifyListeners();
    safeToDisk();
  }

  void removeById(String id) {
    _alarmDefinitions.removeWhere((alarm) => alarm.id == id);
    notifyListeners();
    safeToDisk();
  }

  void updateAlarm(AlarmDefinition alarm) {
    final alarmIndex = _alarmDefinitions.indexWhere(
      (alarm) => alarm.id == alarm.id,
    );
    if (alarmIndex >= 0) {
      _alarmDefinitions[alarmIndex] = alarm;
      updateForecastForAlarm(_alarmDefinitions[alarmIndex]);
      notifyListeners();
      safeToDisk();
    }
  }

  void updateForecastForAlarm(AlarmDefinition alarm) {
    fetchWeatherForecast(alarm.lat, alarm.lon).then((forecast) {
      alarm.forecast = forecast;
      notifyListeners();
    });
  }

  Future<void> safeToDisk() async {
    var jsonList =
        _alarmDefinitions.map((alarm) => jsonEncode(alarm.toJson())).toList();
    var sp = await SharedPreferences.getInstance();
    await sp.setStringList(ALARM_DEFINITIONS_KEY_NAME, jsonList);
  }
}
