import 'package:flutter/material.dart';
import 'package:weather_app/model/daily_weather.dart';
import 'package:weather_app/utils/weather_calc.dart';
import 'package:weather_app/utils/weather_images.dart';

class WeeklyInfoSlide extends StatelessWidget {
  final List<DailyWeather> weeklydata;
  final Color accent;

  const WeeklyInfoSlide({
    super.key,
    required this.weeklydata,
    this.accent = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    if (weeklydata.isEmpty) return const SizedBox.shrink();

    final globalMin =
        weeklydata.map((d) => d.minTemp).reduce((a, b) => a < b ? a : b);
    final globalMax =
        weeklydata.map((d) => d.maxTemp).reduce((a, b) => a > b ? a : b);
    final range = (globalMax - globalMin).abs() < 0.01
        ? 1.0
        : globalMax - globalMin;

    final now = DateTime.now();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        children: List.generate(weeklydata.length, (index) {
          final day = weeklydata[index];
          final isToday = day.date.year == now.year &&
              day.date.month == now.month &&
              day.date.day == now.day;

          final startFraction = (day.minTemp - globalMin) / range;
          final widthFraction = (day.maxTemp - day.minTemp) / range;

          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/weekly-detail',
                arguments: day,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: index == weeklydata.length - 1
                  ? null
                  : BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade100),
                      ),
                    ),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: Text(
                      dayLabel(day.date, isToday: isToday),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      getWeatherImage(day.weatherCode),
                      width: 26,
                      height: 26,
                    ),
                  ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 32,
                  child: Text(
                    '${day.minTemp.round()}°',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final trackWidth = constraints.maxWidth;
                      return Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            height: 4,
                            width: trackWidth,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Positioned(
                            left: trackWidth * startFraction.clamp(0.0, 1.0),
                            child: Container(
                              height: 4,
                              width: (trackWidth * widthFraction)
                                  .clamp(4.0, trackWidth),
                              decoration: BoxDecoration(
                                color: accent,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                  SizedBox(
                    width: 32,
                    child: Text(
                      '${day.maxTemp.round()}°',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
