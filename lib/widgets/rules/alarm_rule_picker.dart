import 'package:flutter/material.dart';
import 'package:weather_alarming/models/alarm_rules.dart';
import 'package:weather_alarming/widgets/rules/temperature_picker.dart';
import 'package:weather_alarming/widgets/rules/wind_direction_picker.dart';

class AlarmRulePicker extends StatefulWidget {
  final Function(List<AlarmRule>) onRulesChanged;
  final List<AlarmRule> initialRules;

  const AlarmRulePicker({
    required this.onRulesChanged,
    this.initialRules = const [],
  });

  @override
  _AlarmRulePickerState createState() => _AlarmRulePickerState();
}

class _AlarmRulePickerState extends State<AlarmRulePicker> {
  final List<String> allRules = [
    WindDirectionAlarmRule.WIND_DIRECTION_ALARM_RULE_TYPE,
    TemperatureAlarmRule.TEMPERATURE_ALARM_RULE_TYPE,
  ];

  @override
  void initState() {
    super.initState();
    currentRules = widget.initialRules;
  }

  // Current list of selected rules
  List<AlarmRule> currentRules = [];

  // Selected rule from the dropdown
  String? selectedRule;

  AlarmRule getFromType(String type) {
    switch (type) {
      case WindDirectionAlarmRule.WIND_DIRECTION_ALARM_RULE_TYPE:
        return WindDirectionAlarmRule(allowedDirections: []);
      case TemperatureAlarmRule.TEMPERATURE_ALARM_RULE_TYPE:
        return TemperatureAlarmRule();
      default:
        throw StateError("Type ${type} is not a valid Alarm Rule");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter out rules that are already in the currentRules list
    final availableRules =
        allRules.where((rule) {
          for (var r in currentRules) {
            if (r.type == rule) {
              return false;
            }
          }
          return true;
        }).toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dropdown to select a rule
            DropdownButton<String>(
              value: selectedRule,
              hint: Text('Select a rule'),
              items:
                  availableRules.map((rule) {
                    return DropdownMenuItem<String>(
                      value: rule,
                      child: Text(rule),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRule = value;
                });
              },
            ),
            // Button to add the selected rule
            ElevatedButton(
              onPressed: () {
                if (selectedRule != null &&
                    !currentRules.contains(selectedRule)) {
                  setState(() {
                    currentRules.add(getFromType(selectedRule!));
                    selectedRule = null; // Reset the dropdown selection
                  });
                }
              },
              child: Text('Add Rule'),
            ),
          ],
        ),
        SizedBox(height: 20),
        // List to display current rules
        ...currentRules.map((rule) {
          int index = currentRules.indexOf(rule);
          if (rule is WindDirectionAlarmRule) {
            return Card(
              child: Row(
                children: [
                  WindDirectionPicker(
                    initialDirections: rule.allowedDirections,
                    onDirectionSelected: (directions) {
                      setState(() {
                        currentRules[index] = WindDirectionAlarmRule(
                          allowedDirections: directions,
                        );
                      });
                      widget.onRulesChanged(currentRules);
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        currentRules.removeAt(index);
                      });
                      widget.onRulesChanged(currentRules);
                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            );
          } else if (rule is TemperatureAlarmRule) {
            return Card(
              child: Row(
                children: [
                  TemperaturePicker(
                    initialValues: RangeValues(
                      rule.minTemperature,
                      rule.maxTemperature,
                    ),
                    onRangeSelected: (min, max) {
                      setState(() {
                        currentRules[index] = TemperatureAlarmRule(
                          minTemperature: min,
                          maxTemperature: max,
                        );
                      });
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        currentRules.removeAt(index);
                      });
                      widget.onRulesChanged(currentRules);
                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            );
          }
          return SizedBox.shrink();
        }),
      ],
    );
  }
}
