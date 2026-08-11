import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:async';

void snackBar(String title, {String err = "", bool isError = false}) {
  final snackBar = SnackBar(
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
        if (err.isNotEmpty) ...{
          Text(err, maxLines: 2, overflow: TextOverflow.ellipsis),
        },
      ],
    ),
    backgroundColor: isError ? AppColors.errorColor : null,

    elevation: 10,
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 2),
  );
  ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
}

Future<void> customBottomSheet(
  BuildContext context,
  Widget child, {
  double? height,
  bool? isScrollable = true,
  bool isDismissible = true,
  Function? onDismissed,
}) async {
  showModalBottomSheet<Widget>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    useSafeArea: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(18),
        topRight: Radius.circular(18),
      ),
    ),
    builder: (ctx) {
      return SingleChildScrollView(
        child: Container(
          height: height,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [SingleChildScrollView(child: child)],
          ),
        ),
      );
    },
  ).then((value) => {if (onDismissed != null) onDismissed()});
}

void _coloredPrint(String colorCode, dynamic text) {
  if (kDebugMode) {
    print(
      '$colorCode-------------------------****------------------------------\x1B[0m',
    );
    print('$colorCode$text\x1B[0m');
    print(
      '$colorCode-------------------------****------------------------------\x1B[0m',
    );
  }
}

void logToConsole(dynamic text) {
  if (kDebugMode) print(text);
}

void printWarning(dynamic text) {
  _coloredPrint('\x1B[33m', text);
}

void printError(dynamic text) {
  _coloredPrint('\x1B[31m', text);
}

void printSuccess(dynamic text) {
  _coloredPrint('\x1B[32m', text);
}

String getDateTimeString(DateTime dateTime) {
  final _date = DateFormat("dd MMMM yy").format(dateTime);
  final _hour = ((dateTime.hour / 12) + (dateTime.hour % 12))
      .toInt()
      .toString()
      .padLeft(2, '0');
  final _mins = dateTime.minute.toString().padLeft(2, '0');
  final _amPm = dateTime.hour >= 12 ? "PM" : "AM";

  return "$_date; $_hour:$_mins $_amPm";
}

class DialogService {
  void showLoader({String? text}) {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.dialog(
      PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Get.theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpinKitThreeBounce(
                  color: AppColors.custom_button_color,
                  size: 35.0,
                ),
                if (text != null) ...[
                  const SizedBox(height: 16),
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Get.theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.3),
    );
  }

  void hideLoader() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  void showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(cancelText, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.custom_button_color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(confirmText, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class KeyboardOverlay {
  static OverlayEntry? _overlayEntry;

  static void showOverlay(BuildContext context) {
    if (!Platform.isIOS) return;
    if (_overlayEntry != null) return;

    OverlayState? overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        right: 0.0,
        left: 0.0,
        child: Material(
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F1F2),
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    removeOverlay();
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });

    overlayState.insert(_overlayEntry!);
  }

  static void removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }
}
