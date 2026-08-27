

class CurrentWeather {
  final double temperature;
  final int humidity;
  final double feelsLike;
  final double windSpeed;
  final double windDirection;
  final int weatherCode;
  final double precipitation;
  final int cloudCover;
  final double pressure;
  final double visibility;
  final int isDay;


  CurrentWeather({
    required this.temperature,
    required this.humidity,
    required this.feelsLike,
    required this.windSpeed,
    required this.windDirection,
    required this.weatherCode,
    required this.precipitation,
    required this.cloudCover,
    required this.pressure,
    required this.visibility,
    required this.isDay
});
  factory CurrentWeather.fromJson(Map<String,dynamic> json)
  {
    return CurrentWeather(temperature: json['temperature_2m'].toDouble(),
        humidity: json['relative_humidity_2m'],
        feelsLike: json['apparent_temperature'].toDouble(),
        windSpeed: json["wind_speed_10m"].toDouble(),
        windDirection: json['wind_direction_10m'].toDouble(),
        weatherCode: json['weather_code'],
        precipitation: json['precipitation'].toDouble(),
        cloudCover: json['cloud_cover'],
        pressure: json['surface_pressure'].toDouble(),
        visibility: json["visibility"].toDouble(),
        isDay: json['is_day']
    );
  }

}