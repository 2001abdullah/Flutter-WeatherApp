import 'package:flutter/material.dart';
import 'package:weather_app/Screens/Current_weather_page.dart';
import 'package:weather_app/Screens/HomePage.dart';
import 'package:weather_app/Screens/WeeklyDetailPage.dart';
import 'package:weather_app/Screens/SetLocationPage.dart';
import 'package:weather_app/Screens/SettingsPage.dart';
import 'package:weather_app/model/weather_response.dart';
import 'package:weather_app/model/daily_weather.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  bool _isDarkMode = false;
  
  // Global location state
  double? _lat;
  double? _lon;
  String? _locationName;

  void _updateLocation(double lat, double lon, String name) {
    setState(() {
      _lat = lat;
      _lon = lon;
      _locationName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        "/": (context) => MainScreen(
              isDarkMode: _isDarkMode,
              onThemeChanged: (val) => setState(() => _isDarkMode = val),
              lat: _lat,
              lon: _lon,
              locationName: _locationName,
              onLocationChanged: _updateLocation,
            ),
        "/current-weather": (context) {
          final weather = ModalRoute.of(context)!.settings.arguments as WeatherResponse;
          return CurrentWeatherPage(weather: weather);
        },
        "/weekly-detail": (context) {
          final day = ModalRoute.of(context)!.settings.arguments as DailyWeather;
          return WeeklyDetailPage(day: day);
        },
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final double? lat;
  final double? lon;
  final String? locationName;
  final Function(double, double, String) onLocationChanged;

  const MainScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    this.lat,
    this.lon,
    this.locationName,
    required this.onLocationChanged,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      Homepage(
        manualLat: widget.lat,
        manualLon: widget.lon,
        manualName: widget.locationName,
      ),
      SetLocationPage(onLocationChanged: (lat, lon, name) {
        widget.onLocationChanged(lat, lon, name);
        setState(() => _currentIndex = 0);
      }),
      SettingsPage(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Set Location'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
