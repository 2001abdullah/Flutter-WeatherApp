# Weather App

A  responsive weather application built with Flutter that provides real-time updates, detailed hourly and weekly forecasts, and global location search capabilities.

# A quick demo
this is the link to the demo of the application: https://youtube.com/shorts/5W6Z3mhLU60?feature=share

## Features

- **Global Location Search**: Search and set locations worldwide using the Open-Meteo Geocoding API.
- **Dynamic User Interface**: The app theme and color palette adapt automatically based on current weather conditions (e.g., sunny, overcast, rainy).
- **Comprehensive Forecasts**:
  - Real-time "Feels Like" temperature, humidity, wind speed, and precipitation.
  - 24-hour horizontal scrolling forecast.
  - 7-day detailed forecast with daily breakdown.
- **Detailed Metrics**: Access deep-dive data including UV Index, Visibility, Pressure, Dew Point, and Sunrise/Sunset times.
- **Theme Support**: Full integration of Light and Dark modes.
- **Adaptive Design**: Optimized for a consistent experience across all Android screen sizes and orientations.

## Architecture and Tools

- **Framework**: Flutter (Dart)
- **Data Source**: Open-Meteo API (REST)
- **Location Services**: Geolocation and Geocoding for precise local weather data.
- **State Management**: Reactive UI updates using Flutter's native state management patterns.
- **Permissions**: Integrated Android permission handling for Location and Internet access.

## Installation and Setup

### Prerequisites

- Flutter SDK (Stable channel)
- Android Studio / VS Code
- Android Emulator or physical device

### Steps to Run

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/weather_app.git
   ```

2. **Navigate to the project directory**:
   ```bash
   cd weather_app
   ```

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

## APK Generation and Installation

To generate a production-ready Android package (APK), execute the following command:

```bash
flutter build apk --release
```

The resulting file will be located at:
`build/app/outputs/flutter-apk/app-release.apk`

### Installation
1. Transfer the `.apk` file to your Android device.
2. Enable installation from unknown sources in your device settings.
3. Open the file and follow the installation prompts.

## Development and Reliability

The application implements robust error handling and timeout mechanisms for network and location requests, ensuring a smooth user experience even under suboptimal connectivity. The UI is built using modular widgets for high maintainability and scalability.
