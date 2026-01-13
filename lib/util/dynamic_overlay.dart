import 'package:get/get.dart';

import 'common_imports.dart';

class DynamicOverlay {
  static bool _isShowing = false;

  // Private constructor
  DynamicOverlay._();

  static void show({
    required BuildContext context,
    bool isProgressLoader = false,
    Color barrierColor = Colors.black54,
    bool barrierDismissible = false,
  }) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_isShowing) {
      hide();
    }
    _isShowing = true;
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) => PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: isProgressLoader
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: Duration(seconds: 2),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: SpinKitWave(
                                color: AppColors.backgroundColor,
                                size: 50.0,
                                itemCount: 5,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      CustomText(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        textColor: AppColors.backgroundColor,
                        text: 'No Internet Connection',
                      ),
                      CustomText(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        textColor: AppColors.backgroundColor,
                        align: TextAlign.center,
                        text:
                            "Please check your internet connection and try again.",
                      ),
                    ],
                  ),
                )
              : Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(Icons.image, size: 40),
                  ),
                ),
        ),
      ),
    );
  }

  static void hide() {
    if (_isShowing) {
      Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
      _isShowing = false;
      // FocusScope.of(Get.overlayContext!).unfocus();
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  static bool isShowing() => _isShowing;
}
