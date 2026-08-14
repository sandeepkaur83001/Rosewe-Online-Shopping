import 'dart:async';
import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position?> getCurrentLocationLangLong() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        CommonApiClass().normalPrintJson(
          "LOCATION_SERVICES_CLASS_LOG   Location services are disabled.",
        );
        return null;
      }

      // Check for location permissions quickly
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

      // Use a shorter timeout (3s) as login doesn't need high precision
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      ).timeout(const Duration(seconds: 3));
    } catch (e) {
      CommonApiClass().normalPrintJson(
        "LOCATION_SERVICES_CLASS_LOG  Error/Timeout getting location: $e",
      );
      return null;
    }
  }
}
