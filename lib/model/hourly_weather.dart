class HourlyWeather {
  final DateTime time;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final int weatherCode;
  final double precipitationProbability;
  final double precipitation;
  final double windSpeed;
  final int cloudCover;
  final int isDay;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.weatherCode,
    required this.precipitationProbability,
    required this.precipitation,
    required this.windSpeed,
    required this.cloudCover,
    required this.isDay,
  });
}