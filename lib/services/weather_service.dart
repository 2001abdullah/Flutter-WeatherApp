import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/current_weather.dart';
import '../model/hourly_weather.dart';
import '../model/daily_weather.dart';
import '../model/weather_response.dart';

class WeatherService {
  Future<List<Map<String, dynamic>>> searchLocations(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search'
      '?name=$query'
      '&count=10'
      '&language=en'
      '&format=json',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'] != null) {
          return List<Map<String, dynamic>>.from(data['results']);
        }
      }
    } catch (e) {
      print('Error searching locations: $e');
    }
    return [];
  }

  Future<WeatherResponse> getWeather(double latitude, double longitude) async
  {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
          '?latitude=$latitude'
          '&longitude=$longitude'
          '&current='
          'temperature_2m,'
          'apparent_temperature,'
          'relative_humidity_2m,'
          'precipitation,'
          'weather_code,'
          'cloud_cover,'
          'surface_pressure,'
          'visibility,'
          'wind_speed_10m,'
          'wind_direction_10m,'
          'is_day'
          '&hourly='
          'temperature_2m,'
          'apparent_temperature,'
          'relative_humidity_2m,'
          'precipitation_probability,'
          'precipitation,'
          'weather_code,'
          'cloud_cover,'
          'wind_speed_10m,'
          'is_day'
          '&daily='
          'weather_code,'
          'temperature_2m_max,'
          'temperature_2m_min,'
          'apparent_temperature_max,'
          'apparent_temperature_min,'
          'precipitation_probability_max,'
          'precipitation_sum,'
          'sunrise,'
          'sunset,'
          'uv_index_max,'
          'wind_speed_10m_max'
          '&timezone=auto',
    );
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if(response.statusCode!=200)
      {
        throw Exception("failed to load weather data");
      }
    final data=jsonDecode(response.body);
    print(data['current']);

    final currentWeather=CurrentWeather.fromJson(data['current']);

    final hourlyData=data['hourly'];
    List <HourlyWeather> hourlyForecast= [];

    for(int i=0; i< hourlyData['time'].length; i++)
      {
        hourlyForecast.add(
         HourlyWeather(
             time: DateTime.parse(
               hourlyData["time"][i],
             ),
             temperature: hourlyData['temperature_2m'][i].toDouble(),
             feelsLike: hourlyData['apparent_temperature'][i].toDouble(),
             humidity: hourlyData['relative_humidity_2m'][i].toInt(),
             weatherCode: hourlyData['weather_code'][i].toInt(),
             precipitationProbability: hourlyData['precipitation_probability'][i].toDouble(),
             precipitation: hourlyData['precipitation'][i].toDouble(),
             windSpeed: hourlyData['wind_speed_10m'][i].toDouble(),
             cloudCover: hourlyData['cloud_cover'][i].toInt(),
             isDay: hourlyData['is_day'][i])
        );
      }
     final dailyData=data['daily'];

    List<DailyWeather> dailyForecast= [];

    for(int i=0; i<dailyData['time'].length; i++)
      {
        dailyForecast.add(
          DailyWeather(
            date: DateTime.parse(
              dailyData['time'][i],
            ),
            maxTemp: dailyData['temperature_2m_max'][i].toDouble(),
            minTemp: dailyData['temperature_2m_min'][i].toDouble(),
            maxFeelsLike:
            dailyData['apparent_temperature_max'][i].toDouble(),
            minFeelsLike:
            dailyData['apparent_temperature_min'][i].toDouble(),
            weatherCode:
            dailyData['weather_code'][i].toInt(),
            precipitationProbability:
            dailyData['precipitation_probability_max'][i].toDouble(),
            precipitationSum:
            dailyData['precipitation_sum'][i].toDouble(),
            sunrise: DateTime.parse(
              dailyData['sunrise'][i],
            ),
            sunset: DateTime.parse(
              dailyData['sunset'][i],
            ),
            uvIndexMax:
            dailyData['uv_index_max'][i].toDouble(),
            windSpeedMax:
            dailyData['wind_speed_10m_max'][i].toDouble(),
          ),
        );
      }

     return WeatherResponse(current: currentWeather,
         hourly: hourlyForecast,
         daily: dailyForecast
     );

  }
}