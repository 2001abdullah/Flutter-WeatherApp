import 'package:flutter/material.dart';
import 'package:weather_app/Widgets/hourly_slide.dart';
import 'package:weather_app/Widgets/todays_highlight.dart';
import 'package:weather_app/Widgets/weekly_info_slide.dart';
import 'package:weather_app/model/weather_response.dart';
import 'package:weather_app/services/location_name.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/utils/weather_description.dart';
import 'package:weather_app/utils/weather_images.dart';
import 'package:weather_app/utils/weather_theme.dart';

class Homepage extends StatefulWidget {
  final double? manualLat;
  final double? manualLon;
  final String? manualName;

  const Homepage({
    super.key,
    this.manualLat,
    this.manualLon,
    this.manualName,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  WeatherResponse? weatherData;
  String? errorMessage;

  String lname = 'Loading...';

  Future<void> loadWeather() async {
    setState(() {
      weatherData = null;
      errorMessage = null;
    });

    try {
      double lat, lon;
      String locationName;

      if (widget.manualLat != null && widget.manualLon != null) {
        lat = widget.manualLat!;
        lon = widget.manualLon!;
        locationName = widget.manualName ?? 'Unknown';
      } else {
        final location = await LocationService().getLocation();
        lat = location.latitude;
        lon = location.longitude;
        locationName = await LocationName().getLocationName(lat, lon);
      }

      final data = await WeatherService().getWeather(lat, lon);

      setState(() {
        weatherData = data;
        lname = locationName;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  @override
  void didUpdateWidget(Homepage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.manualLat != oldWidget.manualLat || widget.manualLon != oldWidget.manualLon) {
      loadWeather();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF4A90D9),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 64),
                const SizedBox(height: 16),
                Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: loadWeather,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (weatherData == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF4A90D9),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    final current = weatherData!.current;
    final theme = getWeatherTheme(current.weatherCode, current.isDay);
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'WEATHER',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: screenHeight),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: theme.gradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: loadWeather,
            color: theme.accent,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on_outlined, color: theme.onGradient, size: 20),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          lname,
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            color: theme.onGradient,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      getWeatherImage(current.weatherCode),
                      width: screenWidth * 0.3,
                      height: screenWidth * 0.3,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${current.temperature.round()}°',
                    style: TextStyle(
                      fontSize: screenWidth * 0.18,
                      fontWeight: FontWeight.w300,
                      color: theme.onGradient,
                      height: 1,
                    ),
                  ),
                  Text(
                    weatherDescription(current.weatherCode),
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      color: theme.onGradientMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Feels like ${current.feelsLike.round()}°',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: theme.onGradientMuted,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TodaysHighlight(
                      humidity: current.humidity,
                      windSpeed: current.windSpeed,
                      precipitation: current.precipitation,
                      accent: theme.accent,
                      onSeeMore: () {
                        Navigator.pushNamed(
                          context,
                          '/current-weather',
                          arguments: weatherData!,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: HourlySlide(
                      hourly: weatherData!.hourly,
                      accent: theme.accent,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '7-Day Forecast',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w600,
                          color: theme.onGradient,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: WeeklyInfoSlide(
                      weeklydata: weatherData!.daily,
                      accent: theme.accent,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
