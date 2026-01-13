import 'package:flutter_base/util/common_imports.dart';
import 'package:fluttertoast/fluttertoast.dart';


class CustomToast {
  static void showToast({
    required String message,
    Toast toastLength = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
    int timeInSecForIosWeb = 1,
    Color backgroundColor = Colors.red,
    Color textColor = Colors.white,
    double fontSize = 16.0,
    bool isSuccess = false,
  }) {
    if (message == "null" || message.isEmpty) {
      return;
    }
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: timeInSecForIosWeb,
      backgroundColor: Colors.orange,
      textColor: textColor,
      fontSize: fontSize,
    );
  }
}
