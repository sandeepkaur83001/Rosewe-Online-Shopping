import 'package:flutter_base/util/common_api_class.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position?> getCurrentLocationLangLong() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      CommonApiClass().normalPrintJson(
        "LOCATION_SERVICES_CLASS_LOG   Location services are disabled.",
      );
      return null;
    }
    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        CommonApiClass().normalPrintJson(
          "LOCATION_SERVICES_CLASS_LOG   Location permissions are denied.",
        );
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      CommonApiClass().normalPrintJson(
        "LOCATION_SERVICES_CLASS_LOG   Location permissions are permanently denied.",
      );
      return null;
    }
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    CommonApiClass().normalPrintJson(
      "LOCATION_SERVICES_CLASS_LOG  Latitude: ${position.latitude}, Longitude: ${position.longitude}",
    );
    return position;
  }
}
