import "package:geocoding/geocoding.dart";

class LocationName {
  Future <String> getLocationName(
      double latitude,double longitude
      ) async
  {
    List<Placemark> placemarks=await placemarkFromCoordinates(latitude, longitude);

    Placemark place=placemarks.first;

    return "${place.locality},${place.country}";
  }

}