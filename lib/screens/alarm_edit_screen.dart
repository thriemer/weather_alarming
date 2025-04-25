import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:weather_alarming/models/alarm_rules.dart';
import 'package:weather_alarming/models/models.dart';
import 'package:weather_alarming/widgets/rules/alarm_rule_picker.dart';

import '../widgets/location_picker.dart';

class AlarmEditScreen extends StatefulWidget {
  final AlarmDefinition? alarm;

  const AlarmEditScreen({super.key, this.alarm});

  @override
  _AlarmEditScreenState createState() => _AlarmEditScreenState();
}

class _AlarmEditScreenState extends State<AlarmEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late double _lon;
  late double _lat;
  late List<AlarmRule> _rules;

  @override
  void initState() {
    super.initState();
    if (widget.alarm != null) {
      _title = widget.alarm!.name;
      _description = '';
      _lon = widget.alarm!.lon;
      _lat = widget.alarm!.lat;
      _description = widget.alarm!.description;
      _rules = widget.alarm!.rules;
    } else {
      _title = '';
      _description = '';
      _lon = 0;
      _lat = 0;
      _rules = [];
    }
  }

  // TODO: confirm unsaved exit
  // TODO: confirm deletion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.alarm == null ? 'Add Alarm' : 'Edit Alarm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  if (value == null) {
                    _description = "";
                  } else {
                    _description = value;
                  }
                },
              ),
              SizedBox(
                width: 400,
                height: 400,
                child: LocationPicker(
                  initialLongitude: _lon,
                  initialLatitude: _lat,
                  onPicked: (lat, lon) {
                    _lat = lat;
                    _lon = lon;
                  },
                ),
              ),
              SizedBox(height: 20),
              AlarmRulePicker(
                initialRules: _rules,
                onRulesChanged: (newRules) => _rules = newRules,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (widget.alarm != null) {
                        final alarmProvider = Provider.of<AppState>(
                          context,
                          listen: false,
                        );
                        var uuid = widget.alarm!.id;
                        alarmProvider.removeById(uuid);
                      }
                      Navigator.pop(context);
                    },
                    child: Text("Delete"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final alarmProvider = Provider.of<AppState>(
                          context,
                          listen: false,
                        );
                        var uuid =
                            widget.alarm == null
                                ? Uuid().v4()
                                : widget.alarm!.id;
                        var alarm = AlarmDefinition.full(
                          uuid,
                          _title,
                          _description,
                          _lat,
                          _lon,
                          _rules,
                          []
                        );
                        if (widget.alarm == null) {
                          alarmProvider.add(alarm);
                        } else {
                          alarmProvider.updateAlarm(alarm);
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
