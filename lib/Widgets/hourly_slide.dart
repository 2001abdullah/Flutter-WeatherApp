import 'package:flutter/material.dart';
import 'package:weather_app/model/hourly_weather.dart';
import 'package:weather_app/utils/weather_images.dart';

class HourlySlide extends StatelessWidget {
  final List<HourlyWeather> hourly;
  final Color accent;

  const HourlySlide({
    super.key,
    required this.hourly,
    this.accent = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    // Only show the next 24 hours from now onward.
    final now = DateTime.now();
    final upcoming = hourly.where((h) => !h.time.isBefore(
          DateTime(now.year, now.month, now.day, now.hour),
        )).take(24).toList();
    final display = upcoming.isNotEmpty ? upcoming : hourly;

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
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Hourly Forecast",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 110,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: display.length,
              itemBuilder: (context, index) {
                final hour = display[index];
                final isNow = index == 0 && upcoming.isNotEmpty;
                return Container(
                  width: 60,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          isNow
                              ? 'Now'
                              : '${hour.time.hour.toString().padLeft(2, '0')}:${hour.time.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          getWeatherImage(hour.weatherCode),
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${hour.temperature.round()}°',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
