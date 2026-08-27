import 'package:flutter/material.dart';
import 'package:weather_app/model/daily_weather.dart';
import 'package:weather_app/utils/weather_calc.dart';
import 'package:weather_app/utils/weather_description.dart';
import 'package:weather_app/utils/weather_images.dart';
import 'package:weather_app/utils/weather_theme.dart';

class WeeklyDetailPage extends StatelessWidget {
  final DailyWeather day;
  final int isDay; // We'll assume day for the forecast detail theme

  const WeeklyDetailPage({super.key, required this.day, this.isDay = 1});

  @override
  Widget build(BuildContext context) {
    final theme = getWeatherTheme(day.weatherCode, isDay);
    final screenWidth = MediaQuery.of(context).size.width;

    final metrics = <_Metric>[
      _Metric(
        icon: Icons.thermostat,
        title: 'Max Feels Like',
        value: '${day.maxFeelsLike.round()}°',
      ),
      _Metric(
        icon: Icons.thermostat_outlined,
        title: 'Min Feels Like',
        value: '${day.minFeelsLike.round()}°',
      ),
      _Metric(
        icon: Icons.water_drop,
        title: 'Precipitation Prob.',
        value: '${day.precipitationProbability.round()}%',
      ),
      _Metric(
        icon: Icons.grain,
        title: 'Total Rain',
        value: '${day.precipitationSum.toStringAsFixed(1)} mm',
      ),
      _Metric(
        icon: Icons.wb_sunny_outlined,
        title: 'UV Index',
        value: day.uvIndexMax.toStringAsFixed(1),
      ),
      _Metric(
        icon: Icons.air,
        title: 'Max Wind Speed',
        value: '${day.windSpeedMax.toStringAsFixed(1)} km/h',
      ),
      _Metric(
        icon: Icons.wb_twilight,
        title: 'Sunrise',
        value: formatClockTime(day.sunrise),
      ),
      _Metric(
        icon: Icons.nights_stay_outlined,
        title: 'Sunset',
        value: formatClockTime(day.sunset),
      ),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.onGradient),
        title: Text(
          dayLabel(day.date, isToday: false),
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
            padding: EdgeInsets.fromLTRB(screenWidth * 0.05, 10, screenWidth * 0.05, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    getWeatherImage(day.weatherCode),
                    width: screenWidth * 0.2,
                    height: screenWidth * 0.2,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${day.maxTemp.round()}° / ${day.minTemp.round()}°',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w300,
                    color: theme.onGradient,
                  ),
                ),
                Text(
                  weatherDescription(day.weatherCode),
                  style: TextStyle(
                    fontSize: 18,
                    color: theme.onGradientMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 25),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: screenWidth > 600 ? 3 : 2,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(metric.icon, color: accent, size: 20),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              metric.title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            metric.value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
