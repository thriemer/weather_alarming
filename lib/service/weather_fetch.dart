import 'package:open_meteo/open_meteo.dart';
import 'package:weather_alarming/models/weather_forecast.dart';

Future<List<WeatherForecast>> fetchWeatherForecast(
  double lat,
  double lon,
) async {
  final weather = WeatherApi();
  final response = await weather.request(
    latitude: lat,
    longitude: lon,
    hourly: {
      WeatherHourly.temperature_2m,
      WeatherHourly.wind_direction_10m,
      WeatherHourly.wind_speed_10m,
      WeatherHourly.wind_gusts_10m,
    },
  );
  final temp = response.hourlyData[WeatherHourly.temperature_2m]!.values;
  final windDir = response.hourlyData[WeatherHourly.wind_direction_10m]!.values;
  final windSpeed = response.hourlyData[WeatherHourly.wind_speed_10m]!.values;
  final windGusts = response.hourlyData[WeatherHourly.wind_gusts_10m]!.values;
  List<WeatherForecast> forecast = [];

  for (var date in temp.keys) {
    forecast.add(
      WeatherForecast(
        time: date,
        temperature2m: temp[date]!.toDouble(),
        windDirection10: windDir[date]!.toDouble(),
        windSpeed10m: windSpeed[date]!.toDouble(),
        windGusts10m: windGusts[date]!.toDouble(),
      ),
    );
  }
  forecast.sort((a, b) => a.time.compareTo(b.time));
  print("Fetched ${forecast.length} elements for $lat, $lon");
  return forecast;
}
