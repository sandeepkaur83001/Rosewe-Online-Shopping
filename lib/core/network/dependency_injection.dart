import 'package:flutter_base/core/common_imports.dart';
import 'package:get/get.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
    Get.put(DialogService(), permanent: true);
  }
}
