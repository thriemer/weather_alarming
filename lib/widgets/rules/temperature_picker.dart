import 'package:flutter/material.dart';

class TemperaturePicker extends StatefulWidget {
  final Function(double, double) onRangeSelected;
  final RangeValues initialValues;

  const TemperaturePicker({
    required this.onRangeSelected,
    this.initialValues = const RangeValues(10, 30),
  });

  @override
  _TemperaturePickerState createState() => _TemperaturePickerState();
}

class _TemperaturePickerState extends State<TemperaturePicker> {
  late RangeValues _currentRangeValues;

  @override
  void initState() {
    super.initState();
    _currentRangeValues = widget.initialValues;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Temperature'),
        RangeSlider(
          values: _currentRangeValues,
          divisions: 80,
          min: -40,
          max: 40,
          onChanged: (value) {
            setState(() {
              _currentRangeValues = value;
            });
            widget.onRangeSelected(value.start, value.end);
          },
        ),
        Text(
          'Min: ${_currentRangeValues.start} °C, Max: ${_currentRangeValues.end}',
        ),
      ],
    );
  }
}
