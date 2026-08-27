String getWeatherImage(int code) {
  if (code == 0) {
    return 'assets/icons/sunny.png';
  } else if (code <= 3) {
    return 'assets/icons/clear&clouds.jpg';
  } else if (code == 45 || code == 48) {
    return 'assets/icons/mist&fog.jpg';
  } else if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
    return 'assets/icons/drizzle&rain.jpg';
  } else if (code >= 71 && code <= 77) {
    return 'assets/icons/snow.jpg';
  } else if (code == 85 || code == 86) {
    return 'assets/icons/snow.jpg';
  } else if (code >= 95) {
    return 'assets/icons/storm.jpg';
  }

  return 'assets/icons/clear&clouds.jpg';
}