import 'package:geolocator/geolocator.dart';
import 'package:flutter_base/core/common_imports.dart';

class LocationPermissionClass {
  // Check and request location permissions
  static Future<bool> requestLocationPermission() async {
    PermissionStatus fineStatus = await Permission.location.status;

    if (fineStatus.isDenied || fineStatus.isPermanentlyDenied) {
      fineStatus = await Permission.location.request();
    }

    return fineStatus.isGranted;
  }

  // Check if GPS is enabled and prompt user to turn it on
  static Future<bool> enableGPS() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      await Geolocator.openLocationSettings();
      return false;
    }

    return true;
  }

  static Future<bool> initializeLocationService(BuildContext context) async {
    // Step 1: Check location permission
    bool hasPermission = await requestLocationPermission();
    if (!hasPermission) {
      CommonApiClass().normalPrintJson("PERMISSION_LOCATION  => APP PERMISSION NOT TAKEN ");
      LocationPermissionClass().showPermissionDialog(context, () async {
        await openAppSettings();
      });
      return false;
    }
    bool gpsEnabled = await enableGPS();
    if (!gpsEnabled) {
      CommonApiClass().normalPrintJson("PERMISSION_LOCATION  => NO GPS ENABLE  ");
      await Geolocator.openLocationSettings();
      return false;
    }
    return true;
  }

  // Example to get current position
  static Future<bool> getCurrentPosition(BuildContext context) async {
    bool ready = await initializeLocationService(context);
    if (!ready) {
      return false;
    } else {
      return true;
    }
  }

  static bool isDialogBox = false;

  Future<void> showPermissionDialog(BuildContext contextTop, Function onTap) async {
    isDialogBox = true;
    showDialog(
      barrierDismissible: false,
      context: contextTop,
      builder: (context) {
        return PopScope(
          canPop:  false,
          child: AlertDialog(
            backgroundColor: AppColors.backgroundColor,
            title: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [Color(0xff9667D7), Color(0xffF83466)], // Your Gradient Colors
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: CustomText(
                text: "Permission Required",
                fontWeight: FontWeight.w600,
                fontSize: 18,
                textColor: AppColors.whiteColor,
              ),
            ),
            content: CustomText(
              text: "Location permission is required to use this feature. Please enable it in your device settings.",
              fontWeight: FontWeight.w500,
              fontSize: 16,
              textColor: AppColors.register_text_color,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                     
                      isDialogBox = false;

                      Navigator.of(contextTop).pop();
                      onTap();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(color: AppColors.secondaryColor, borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: CustomText(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          text: "Open Settings",
                          textColor: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
