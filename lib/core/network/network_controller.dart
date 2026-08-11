
import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }


  void _updateConnectionStatus(List<ConnectivityResult> connectivityResult) {
    final context =
        Get.overlayContext ??
        Get.context ??
        Globals.navigatorKey.currentState?.context;

    if (connectivityResult.contains(ConnectivityResult.none)) {
      if (context != null) {
        DynamicOverlay.show(context: context, isProgressLoader: true);
      } else {
        debugPrint("Context is null, cannot show overlay");
      }
    } else {
      DynamicOverlay.hide();
    }
  }

  @override
  void onClose() {
    DynamicOverlay.hide();
    super.onClose();
  }
}
