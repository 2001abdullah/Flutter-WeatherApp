import 'package:geolocator/geolocator.dart';


class LocationService {
  Future<Position> getLocation() async
  {
    bool enabled= await Geolocator.isLocationServiceEnabled();
    print("Service enabled: $enabled");
    if(!enabled)
      {
        throw Exception("Location Services are disabled.");
      }
     LocationPermission permission=await Geolocator.checkPermission();
    print("Permission: $permission");
    if (permission==LocationPermission.denied)
      {
        permission=await Geolocator.requestPermission();
      }
    if(permission==LocationPermission.denied)
      {
        throw Exception("Permission is denied.");
      }
    if(permission==LocationPermission.deniedForever)
      {
        throw Exception("Location permission denied forever");
      }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 10),
      ),
    );
  }

}