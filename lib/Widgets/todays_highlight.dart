import 'package:flutter/material.dart';

class TodaysHighlight extends StatelessWidget {
  final int humidity;
  final double windSpeed;
  final double precipitation;
  final Color accent;

  final VoidCallback onSeeMore;

  const TodaysHighlight({
    super.key,
    required this.humidity,
    required this.windSpeed,
    required this.precipitation,
    required this.onSeeMore,
    this.accent = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's Highlight",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: onSeeMore,
                child: Text(
                  "See more →",
                  style: TextStyle(
                    color: accent,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _highlight(
            icon: Icons.water_drop,
            title: "Humidity",
            value: "$humidity%",
            accent: accent,
          ),
          const SizedBox(height: 15),
          _highlight(
            icon: Icons.air,
            title: "Wind Speed",
            value: "${windSpeed.toStringAsFixed(1)} km/h",
            accent: accent,
          ),
          const SizedBox(height: 15),
          _highlight(
            icon: Icons.water,
            title: "Precipitation",
            value: "${precipitation.toStringAsFixed(1)} mm",
            accent: accent,
          ),
        ],
      ),
    );
  }

  Widget _highlight({
    required IconData icon,
    required String title,
    required String value,
    required Color accent,
  }) {
    return Row(
      children: [
        Icon(icon, size: 22, color: accent),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
