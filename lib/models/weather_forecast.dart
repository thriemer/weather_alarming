class WeatherForecast {
  DateTime time;
  double temperature2m;
  double windSpeed10m;
  double windDirection10;
  double windGusts10m;

  WeatherForecast({
    required this.time,
    required this.temperature2m,
    required this.windSpeed10m,
    required this.windDirection10,
    required this.windGusts10m,
  });

  @override
  String toString() {
    return "Weather Forecast{ time: $time, temperature: $temperature2m, windSpeed: $windSpeed10m, windDir: $windDirection10, gusts: $windGusts10m }";
  }

  bool isNightTime() {
    return time.hour < 6 || time.hour > 20;
  }
}
