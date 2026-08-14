
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
    if (connectivityResult.contains(ConnectivityResult.none)) {
      DynamicOverlay.show(isNoInternet: true);
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
