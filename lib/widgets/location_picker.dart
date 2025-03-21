import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as coordinates;

typedef Location = List<double> Function(dynamic data);

class LocationPicker extends StatefulWidget {
  /// Sets the initial location - latitude that the map must be centered on.
  final double initialLatitude;

  /// Sets initial location - longitude that the map must be centered on.
  final double initialLongitude;

  final Function(double, double) onPicked;

  /// Sets the map zoom level.
  final double zoomLevel;

  /// Sets the mode of the picker.
  /// if true: enables DisplayOnly mode to display a marker on the map at a location only, no selection
  /// if false: enabled Picker mode allows to tap on the map to pick a location
  final bool displayOnly;

  /// Sets the appbar background color for the picker screen.
  final Color appBarColor;

  /// Sets the map marker icon background color.
  final Color markerColor;

  /// Sets the appbar text color.
  final Color appBarTextColor;

  /// Sets the appbar text color.
  final String appBarTitle;

  const LocationPicker({
    super.key,
    required this.onPicked,
    this.initialLatitude = 28.45306253513271,
    this.initialLongitude = 81.47338277012638,
    this.zoomLevel = 12.0,
    this.displayOnly = false,
    this.appBarColor = Colors.blueAccent,
    this.appBarTextColor = Colors.white,
    this.appBarTitle = "Select Location",
    this.markerColor = Colors.blueAccent,
  });

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  // Holds the value of the picked location.
  late SimpleLocationResult _selectedLocation;

  void getlocation() {
    double latitude = _selectedLocation.latitude;
    double longitude = _selectedLocation.longitude;
    var coordinates = [latitude, longitude];
    print(coordinates);
  }

  @override
  void initState() {
    super.initState();
    _selectedLocation =
        SimpleLocationResult(widget.initialLatitude, widget.initialLongitude);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: _selectedLocation.getLatLng(),
        initialZoom: widget.zoomLevel,
        onTap: (tapLoc, position) {
          if (!widget.displayOnly) {
            setState(() {
              _selectedLocation =
                  SimpleLocationResult(position.latitude, position.longitude);
              widget.onPicked(position.latitude, position.longitude);
            });
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        ),
        MarkerLayer(markers: [
          Marker(
            width: 80.0,
            height: 80.0,
            point: _selectedLocation.getLatLng(),
            child: const Icon(
              Icons.location_on,
              color: Color.fromARGB(255, 255, 7, 7),
            ),
          ),
        ])
      ],
    );
  }
}

class SimpleLocationResult {
  /// The latitude of the result.
  final double latitude;

  /// The longitude of the result.
  final double longitude;

  /// Construct the result with a latitude and longitude.
  SimpleLocationResult(this.latitude, this.longitude);

  /// returns the SimpleLocationResult location as a LatLng object
  getLatLng() => coordinates.LatLng(latitude, longitude);
}