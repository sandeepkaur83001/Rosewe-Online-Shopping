import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_base/util/common_imports.dart';
import 'package:intl/intl.dart';

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
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  void hideLoader() {
    Get.back();
  }
}
