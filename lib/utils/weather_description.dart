/// Maps an Open-Meteo / WMO weather code to a short human-readable label.
String weatherDescription(int code) {
  switch (code) {
    case 0:
      return 'Clear Sky';
    case 1:
      return 'Mainly Clear';
    case 2:
      return 'Partly Cloudy';
    case 3:
      return 'Overcast';
    case 45:
      return 'Fog';
    case 48:
      return 'Rime Fog';
    case 51:
      return 'Light Drizzle';
    case 53:
      return 'Drizzle';
    case 55:
      return 'Dense Drizzle';
    case 56:
      return 'Freezing Drizzle';
    case 57:
      return 'Dense Freezing Drizzle';
    case 61:
      return 'Slight Rain';
    case 63:
      return 'Rain';
    case 65:
      return 'Heavy Rain';
    case 66:
      return 'Freezing Rain';
    case 67:
      return 'Heavy Freezing Rain';
    case 71:
      return 'Slight Snow';
    case 73:
      return 'Snow';
    case 75:
      return 'Heavy Snow';
    case 77:
      return 'Snow Grains';
    case 80:
      return 'Light Showers';
    case 81:
      return 'Rain Showers';
    case 82:
      return 'Violent Showers';
    case 85:
      return 'Slight Snow Showers';
    case 86:
      return 'Heavy Snow Showers';
    case 95:
      return 'Thunderstorm';
    case 96:
      return 'Thunderstorm, Hail';
    case 99:
      return 'Severe Thunderstorm';
    default:
      return 'Unknown';
  }
}
