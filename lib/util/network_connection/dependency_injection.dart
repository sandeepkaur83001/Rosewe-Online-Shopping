
import 'package:flutter_base/util/common_methods.dart';
import 'package:flutter_base/util/network_connection/network_controller.dart';
import 'package:get/get.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
    Get.put(DialogService(), permanent: true);
  }
  
}
