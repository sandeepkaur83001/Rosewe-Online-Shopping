import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/home/controller/home_controller.dart';
import 'package:rosewe_online_shopping/features/profile/controller/profile_controller.dart';
import 'package:get/get.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
    Get.put(DialogService(), permanent: true);
    
    // Feature Controllers
    Get.put(HomeController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
  }
}
