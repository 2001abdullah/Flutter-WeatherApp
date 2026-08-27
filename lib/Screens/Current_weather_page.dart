import 'package:flutter/material.dart';
import 'package:weather_app/model/daily_weather.dart';
import 'package:weather_app/model/weather_response.dart';
import 'package:weather_app/utils/weather_calc.dart';
import 'package:weather_app/utils/weather_description.dart';
import 'package:weather_app/utils/weather_images.dart';
import 'package:weather_app/utils/weather_theme.dart';

class CurrentWeatherPage extends StatelessWidget {
  final WeatherResponse weather;

  const CurrentWeatherPage({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final current = weather.current;
    final theme = getWeatherTheme(current.weatherCode, current.isDay);
    final DailyWeather? today = weather.daily.isNotEmpty ? weather.daily.first : null;

    final dewPoint = calculateDewPoint(current.temperature, current.humidity.toDouble());
    final visibilityKm = current.visibility / 1000;

    final metrics = <_Metric>[
      _Metric(
        icon: Icons.thermostat,
        title: 'Feels Like',
        value: '${current.feelsLike.round()}°',
      ),
      _Metric(
        icon: Icons.water_drop,
        title: 'Humidity',
        value: '${current.humidity}%',
      ),
      _Metric(
        icon: Icons.air,
        title: 'Wind Speed',
        value: '${current.windSpeed.toStringAsFixed(1)} km/h',
      ),
      _Metric(
        icon: Icons.explore_outlined,
        title: 'Wind Direction',
        value: compassDirection(current.windDirection),
      ),
      _Metric(
        icon: Icons.speed,
        title: 'Pressure',
        value: '${current.pressure.toStringAsFixed(0)} hPa',
      ),
      _Metric(
        icon: Icons.cloud_outlined,
        title: 'Cloud Cover',
        value: '${current.cloudCover}%',
      ),
      _Metric(
        icon: Icons.visibility_outlined,
        title: 'Visibility',
        value: '${visibilityKm.toStringAsFixed(1)} km',
      ),
      _Metric(
        icon: Icons.grain,
        title: 'Rain',
        value: '${current.precipitation.toStringAsFixed(1)} mm',
      ),
      _Metric(
        icon: Icons.opacity,
        title: 'Dew Point',
        value: '${dewPoint.round()}°',
      ),
      if (today != null)
        _Metric(
          icon: Icons.wb_sunny_outlined,
          title: 'UV Index',
          value: today.uvIndexMax.toStringAsFixed(1),
        ),
      if (today != null)
        _Metric(
          icon: Icons.wb_twilight,
          title: 'Sunrise',
          value: formatClockTime(today.sunrise),
        ),
      if (today != null)
        _Metric(
          icon: Icons.nights_stay_outlined,
          title: 'Sunset',
          value: formatClockTime(today.sunset),
        ),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.onGradient),
        title: Text(
          'Weather Details',
          style: TextStyle(color: theme.onGradient, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: theme.gradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    getWeatherImage(current.weatherCode),
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${current.temperature.round()}°',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w300,
                    color: theme.onGradient,
                  ),
                ),
                Text(
                  weatherDescription(current.weatherCode),
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.onGradientMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 25),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = MediaQuery.of(context).size.width > 600 ? 3 : 2;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: metrics.length,
                      itemBuilder: (context, index) {
                        return _MetricCard(metric: metrics[index], accent: theme.accent);
                      },
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Metric {
  final IconData icon;
  final String title;
  final String value;

  _Metric({required this.icon, required this.title, required this.value});
}

class _MetricCard extends StatelessWidget {
  final _Metric metric;
  final Color accent;

  const _MetricCard({required this.metric, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(metric.icon, color: accent, size: 22),
          const SizedBox(height: 10),
          Text(
            metric.title,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            metric.value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
