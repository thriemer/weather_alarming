import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:provider/provider.dart';
import 'package:weather_alarming/models/models.dart';
import 'package:weather_alarming/screens/alarm_edit_screen.dart';
import 'package:weather_alarming/widgets/forecast_row.dart';

class AlarmList extends StatefulWidget {
  const AlarmList({super.key});

  @override
  State<StatefulWidget> createState() => _AlarmListState();
}

class _AlarmListState extends State<AlarmList> {
  late LinkedScrollControllerGroup _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
  }

  @override
  Widget build(BuildContext context) {
    var alarms = context.watch<AppState>();

    return ListView.builder(
      itemCount: alarms.alarmDefinitions.length,
      itemBuilder: (context, index) {
        var alarm = alarms.alarmDefinitions[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              alarm.name, // Display the alarm name as the title
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Icon(Icons.alarm),
                SizedBox(width: 16),
                Expanded(
                  child: WeatherForecastRow(
                    key: UniqueKey(),
                    forecasts: alarm.forecast,
                    alarmState: alarm.calculateAlarmState(),
                    scrollController: _controllers.addAndGet(),
                  ),
                ),
                SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => AlarmEditScreen(
                              alarm: alarms.alarmDefinitions[index],
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
