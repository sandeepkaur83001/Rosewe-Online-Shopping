import 'package:flutter_base/core/common_imports.dart';



class Globals {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static String? BearerToken;

  static double height = 0.0;
  static double width = 0.0;
    static void screenDimensions(BuildContext context) {
    if (height == 0.0) {
      width = MediaQuery.of(context).size.width;

      height = MediaQuery.of(context).size.height;
    } else if (width == 0.0) {
      width = MediaQuery.of(context).size.width;

      height = MediaQuery.of(context).size.height;
    }
  }

}
