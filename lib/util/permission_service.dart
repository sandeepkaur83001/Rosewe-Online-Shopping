import 'dart:io';

import 'package:flutter_base/util/common_imports.dart';

class PermissionService {
  Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
     final context = Globals.navigatorKey.currentContext;
        if (context != null) {
          showPermissionDialog(context);
        }
      return false;
    } else if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    return status.isGranted;
  }

  Future<bool> requestPhotosPermission() async {
    var status = await Permission.photos.status;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      final context = Globals.navigatorKey.currentContext;
        if (context != null) {
          showPermissionDialog(context);
        }
      return false;
    } else if (status.isDenied || status.isRestricted) {
      if (Platform.isAndroid) {
        final plugin = DeviceInfoPlugin();
        final android = await plugin.androidInfo;
        status = android.version.sdkInt < 33
            ? await Permission.storage.request()
            : await Permission.photos.request();
      } else if (Platform.isIOS) {
        status = await Permission.photos.request();
      }
    } else if (!status.isGranted) {
      if (Platform.isAndroid) {
        final plugin = DeviceInfoPlugin();
        final android = await plugin.androidInfo;
        status = android.version.sdkInt < 33
            ? await Permission.storage.request()
            : await Permission.photos.request();
      } else if (Platform.isIOS) {
        status = await Permission.photos.request();
      }
    }
    return status.isGranted;
  }

  
  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final statuses = await [
        Permission.photos,
        Permission.videos,
        Permission.audio,
      ].request();

      if (statuses.values.any((status) => status.isPermanentlyDenied)) {
        await openAppSettings();
        final context = Globals.navigatorKey.currentContext;
        if (context != null) {
          showPermissionDialog(context);
        }

        return false;
      }

      return statuses.values.every((status) => status.isGranted);
    }

    if (Platform.isIOS) {
      final status = await Permission.photos.request();

      if (status.isPermanentlyDenied) {
        await openAppSettings();
         final context = Globals.navigatorKey.currentContext;
        if (context != null) {
          showPermissionDialog(context);
        }
        return false;
      }

      return status.isGranted;
    }

    return false;
  }

  Future<bool> requestPermissions() async {
    bool cameraPermission = await _requestCameraPermission();
    bool photosPermission = await _requestPhotosPermission();
    return cameraPermission && photosPermission;
  }

  Future<bool> _requestPhotosPermission() async {
    var status = await Permission.photos.status;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
 final context = Globals.navigatorKey.currentContext;
        if (context != null) {
          showPermissionDialog(context);
        }
      return false;
    } else if (status.isDenied || status.isRestricted) {
      if (Platform.isAndroid) {
        final plugin = DeviceInfoPlugin();
        final android = await plugin.androidInfo;
        status = android.version.sdkInt < 33
            ? await Permission.storage.request()
            : await Permission.photos.request();
      } else if (Platform.isIOS) {
        status = await Permission.photos.request();
      }
    } else if (!status.isGranted) {
      if (Platform.isAndroid) {
        final plugin = DeviceInfoPlugin();
        final android = await plugin.androidInfo;
        status = android.version.sdkInt < 33
            ? await Permission.storage.request()
            : await Permission.photos.request();
      } else if (Platform.isIOS) {
        status = await Permission.photos.request();
      }
    }

 
    if (status.isGranted || status.isLimited) {
      return true;
    }
    return false;
 
  }

  Future<bool> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
       final context = Globals.navigatorKey.currentContext;
        if (context != null) {
          showPermissionDialog(context);
        }
      return false;
    } else if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    return status.isGranted;
  }

  Future<bool> requestAudioPermission() async {
    var status = await Permission.microphone.status;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      final context = Globals.navigatorKey.currentContext;
        if (context != null) {
          showPermissionDialog(context);
        }
      return false;
    } else if (!status.isGranted) {
      status = await Permission.microphone.request();
    }
    return status.isGranted;
  }

  Future<bool> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isPermanentlyDenied) {
    final context = Globals.navigatorKey.currentContext;
        if (context != null) {
          showPermissionDialog(context);
        }
      return false;
    } else if (!status.isGranted) {
      status = await Permission.notification.request();
    }
    return status.isGranted;
  }

  Future<bool> requestPhonePermission() async {
    var status = await Permission.phone.status;
    if (status.isPermanentlyDenied) {
     final context = Globals.navigatorKey.currentContext;
        if (context != null) {
          showPermissionDialog(context);
        }
      return false;
    } else if (!status.isGranted) {
      status = await Permission.phone.request();
    }
    return status.isGranted;
  }

  void showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundColor,
          title: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [
                  Color(0xff9667D7),
                  Color(0xffF83466),
                ], // Your Gradient Colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: Text(
              "Permission Required",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: AppColors.whiteColor,
              ),
            ),
          ),
          content: Text(
            "Permission is required to access this feature. Please grant permission in settings.",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: AppColors.register_text_color,
            ),
          ),
          actions: [
            Row(
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.red,
                          ),
                          "Cancel",
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    openAppSettings();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.whiteColor,
                        ),
                        "Open Settings",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void dialogCameraGallery(BuildContext context, {required Function getFile}) {
    showDialog(
      context: context,
      builder: (contextShowDialog) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundColor,
          title: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [
                  Color(0xff9667D7),
                  Color(0xffF83466),
                ], // Your Gradient Colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: Text(
              "Choose Media",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: AppColors.whiteColor,
              ),
            ),
          ),
          content: null,
          actions: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final XFile? image = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      RouteNavigate().safePop(contextShowDialog);
                      getFile(image != null ? File(image.path) : null);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      child: Center(
                        child: Text(
                          "Gallery",

                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final XFile? image = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                      );
                      RouteNavigate().safePop(contextShowDialog);
                      getFile(image != null ? File(image.path) : null);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.whiteColor,
                          ),

                          "Camera",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
