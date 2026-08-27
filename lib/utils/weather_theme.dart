import 'package:flutter/material.dart';

/// A small bundle of colors derived from the current weather condition,
/// used to theme the background gradient, accents, and text across the app.
class WeatherTheme {
  final List<Color> gradient;
  final Color accent;
  final Brightness brightness;

  const WeatherTheme({
    required this.gradient,
    required this.accent,
    required this.brightness,
  });

  /// Text color that reads well against [gradient].
  Color get onGradient =>
      brightness == Brightness.dark ? Colors.white : Colors.white;

  /// Slightly muted variant of [onGradient] for secondary text.
  Color get onGradientMuted => onGradient.withOpacity(0.75);
}

/// Resolves a [WeatherTheme] from a WMO weather code and the `is_day` flag
/// returned by Open-Meteo (1 = day, 0 = night).
WeatherTheme getWeatherTheme(int code, int isDay) {
  final bool isNight = isDay == 0;

  if (isNight) {
    return const WeatherTheme(
      gradient: [Color(0xFF0F1A3C), Color(0xFF2B3B6B)],
      accent: Color(0xFF7C93FF),
      brightness: Brightness.dark,
    );
  }

  // Thunderstorm
  if (code >= 95) {
    return const WeatherTheme(
      gradient: [Color(0xFF2C2E43), Color(0xFF565480)],
      accent: Color(0xFF4B4878),
      brightness: Brightness.dark,
    );
  }

  // Snow
  if (code >= 71 && code <= 86 && code != 80 && code != 81 && code != 82) {
    return const WeatherTheme(
      gradient: [Color(0xFF7E93AE), Color(0xFFC7D6E5)],
      accent: Color(0xFF54687F),
      brightness: Brightness.light,
    );
  }

  // Rain / drizzle / rain showers
  if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
    return const WeatherTheme(
      gradient: [Color(0xFF3E4E63), Color(0xFF6E829A)],
      accent: Color(0xFF2E3D4E),
      brightness: Brightness.dark,
    );
  }

  // Fog / mist
  if (code >= 45 && code <= 48) {
    return const WeatherTheme(
      gradient: [Color(0xFF8E99A3), Color(0xFFC6CFD6)],
      accent: Color(0xFF667079),
      brightness: Brightness.light,
    );
  }

  // Partly cloudy / overcast
  if (code >= 1 && code <= 3) {
    return const WeatherTheme(
      gradient: [Color(0xFF6E8CAE), Color(0xFFA9C1D9)],
      accent: Color(0xFF4A688A),
      brightness: Brightness.light,
    );
  }

  // Clear sky (code == 0), default
  return const WeatherTheme(
    gradient: [Color(0xFF4A90D9), Color(0xFF8EC5FC)],
    accent: Color(0xFF2E6FB0),
    brightness: Brightness.light,
  );
}
