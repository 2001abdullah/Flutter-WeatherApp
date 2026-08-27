import 'dart:math' as math;

/// Converts a wind bearing in degrees into a 16-point compass label.
String compassDirection(double degrees) {
  const directions = [
    'N', 'NNE', 'NE', 'ENE',
    'E', 'ESE', 'SE', 'SSE',
    'S', 'SSW', 'SW', 'WSW',
    'W', 'WNW', 'NW', 'NNW',
  ];
  final normalized = degrees % 360;
  final index = ((normalized / 22.5) + 0.5).floor() % 16;
  return directions[index];
}

/// Approximates dew point (°C) from temperature (°C) and relative humidity
/// (%) using the Magnus formula. Open-Meteo doesn't expose dew point on the
/// `current` block directly, so it's derived here.
double calculateDewPoint(double tempC, double humidityPercent) {
  const a = 17.27;
  const b = 237.7;
  final rh = humidityPercent.clamp(1, 100);
  final alpha = ((a * tempC) / (b + tempC)) + math.log(rh / 100);
  return (b * alpha) / (a - alpha);
}

/// Formats a [DateTime] as "h:mm AM/PM".
String formatClockTime(DateTime dt) {
  final hour24 = dt.hour;
  final minute = dt.minute.toString().padLeft(2, '0');
  final period = hour24 >= 12 ? 'PM' : 'AM';
  final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
  return '$hour12:$minute $period';
}

/// Short weekday label, e.g. "Mon".
String weekdayShort(DateTime dt) {
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return days[dt.weekday - 1];
}

/// "Today" for the first entry, otherwise the short weekday name.
String dayLabel(DateTime dt, {required bool isToday}) {
  return isToday ? 'Today' : weekdayShort(dt);
}
