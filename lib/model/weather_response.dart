import 'current_weather.dart';
import 'hourly_weather.dart';
import 'daily_weather.dart';

class WeatherResponse {
  final CurrentWeather current;
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;

  WeatherResponse(
  {
    required this.current,
    required this.hourly,
    required this.daily
}
      );


}