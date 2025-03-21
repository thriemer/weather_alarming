import 'package:flutter/material.dart';

class WindDirectionPicker extends StatefulWidget {
  final Function(List<String>) onDirectionSelected;
  final List<String> initialDirections;

  const WindDirectionPicker({
    required this.onDirectionSelected,
    this.initialDirections = const [],
  });

  @override
  _WindDirectionPickerState createState() => _WindDirectionPickerState();
}

class _WindDirectionPickerState extends State<WindDirectionPicker> {
  final List<String> _directions = [
    'NW',
    'N',
    'NE',
    'W',
    'Center',
    'E',
    'SW',
    'S',
    'SE',
  ];
  List<bool> _isSelected = List.filled(9, false);

  void publishSelectedDirections() {
    List<String> selectedDirections = [];
    for (int i = 0; i < 9; i++) {
      if (i == 4) continue; // this is the center button
      if (_isSelected[i]) {
        selectedDirections.add(_directions[i]);
      }
    }
    widget.onDirectionSelected(selectedDirections);
  }

  @override
  void initState() {
    super.initState();
    for (final v in widget.initialDirections) {
      _isSelected[_directions.indexOf(v)] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var counter = 0;
    return SizedBox(
      width: 150,
      height: 150,
      child: GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 3,
        children:
        [
          Icon(Icons.north_west),
          Icon(Icons.north),
          Icon(Icons.north_east),
          Icon(Icons.west),
          Icon(Icons.wind_power),
          Icon(Icons.east),
          Icon(Icons.south_west),
          Icon(Icons.south),
          Icon(Icons.south_east),
        ].map((widget) {
          final index = counter++;
          return ToggleButtons(
            selectedColor: Colors.deepPurpleAccent,
            isSelected: [_isSelected[index]],
            onPressed: (_) {
              setState(() {
                _isSelected[index] = !_isSelected[index];
              });
              publishSelectedDirections();
            },
            children: [widget],
          );
        }).toList(),
      ),
    );
  }
}