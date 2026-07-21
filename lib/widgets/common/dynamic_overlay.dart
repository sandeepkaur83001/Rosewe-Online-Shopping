import 'package:flutter_base/core/common_imports.dart';
import 'package:get/get.dart';

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
                        duration: const Duration(seconds: 2),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: const SpinKitWave(
                                color: AppColors.backgroundColor,
                                size: 50.0,
                                itemCount: 5,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      const CustomText(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        textColor: AppColors.backgroundColor,
                        text: 'No Internet Connection',
                      ),
                      const CustomText(
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
              : const Center(
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
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  static bool isShowing() => _isShowing;
}
