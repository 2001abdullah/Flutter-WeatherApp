class DailyWeather {
  final DateTime date;

  final double maxTemp;
  final double minTemp;

  final double maxFeelsLike;
  final double minFeelsLike;

  final int weatherCode;

  final double precipitationProbability;
  final double precipitationSum;

  final DateTime sunrise;
  final DateTime sunset;

  final double uvIndexMax;

  final double windSpeedMax;

  DailyWeather({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.maxFeelsLike,
    required this.minFeelsLike,
    required this.weatherCode,
    required this.precipitationProbability,
    required this.precipitationSum,
    required this.sunrise,
    required this.sunset,
    required this.uvIndexMax,
    required this.windSpeedMax
});

}