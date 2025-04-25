import 'dart:math';

import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:weather_alarming/models/models.dart';

import '../models/weather_forecast.dart';

class WeatherForecastRow extends StatelessWidget {
  final List<WeatherForecast> forecasts;
  final Map<DateTime, AlarmState>? alarmState;
  final ScrollController? scrollController;

  const WeatherForecastRow({
    super.key,
    required this.forecasts,
    this.alarmState,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (forecasts.isEmpty) {
      return Center(child: Text('No forecast data available.'));
    }

    var group = groupBy(forecasts, (f) => f.time.day);
    List<int> sortedKeys = group.keys.toList().sorted(
      (i1, i2) => i1.compareTo(i2),
    );
    return SizedBox(
      height: 160,
      child: Row(
        children: [
          // Label
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.access_time_outlined),
              SizedBox(height: 8),
              Text('°C'),
              Text('Wind km/h'),
              Icon(Icons.wind_power),
              Text('Gusts km/h'),
              if (alarmState != null) Text("Alarm"),
            ],
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: group.length,
              itemBuilder:
                  (context, index) =>
                      displayDayGroup(group[sortedKeys[index]]!, alarmState),
            ),
          ),
        ],
      ),
    );
  }

  static const List<String> WEEKDAY_LOOKUP = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Son",
  ];

  Widget displayDayGroup(
    List<WeatherForecast> forecast,
    Map<DateTime, AlarmState>? alarmState,
  ) {
    var date = forecast.first.time;

    return Column(
      children: [
        Text(
          "${WEEKDAY_LOOKUP[date.weekday - 1]}  ${"${date.day}".padLeft(2, "0")}-${"${date.month}".padLeft(2, "0")}-${date.year}",
        ),
        Row(
          children: [
            ...forecast.map(
              (forecast) => Container(
                color:
                    forecast.isNightTime()
                        ? Color.fromRGBO(100, 100, 100, 0.3)
                        : Color.fromRGBO(0, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${forecast.time.hour}'.padLeft(2, "0"),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('${forecast.temperature2m.round()}'),
                    Text('${forecast.windSpeed10m.round()}'),
                    Transform.rotate(
                      angle: forecast.windDirection10 * pi / 180.0,
                      child: Icon(Icons.arrow_upward),
                    ),
                    Text('${forecast.windGusts10m.round()}'),
                    if (alarmState != null && alarmState[date]!.triggered)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: SizedBox(height: 20, width: 20),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
