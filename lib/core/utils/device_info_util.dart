import 'dart:io';
import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfoUtil {
  static late PackageInfo _packageInfo;
  static late String deviceId;
  static late String osVersion;
  static late String model;

  static Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
    
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
      osVersion = androidInfo.version.release;
      model = androidInfo.model;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? 'unknown';
      osVersion = iosInfo.systemVersion;
      model = iosInfo.utsname.machine;
    }
  }

  static String get appName => _packageInfo.appName;
  static String get packageName => _packageInfo.packageName;
  static String get version => _packageInfo.version;
  static String get buildNumber => _packageInfo.buildNumber;

  static Map<String, dynamic> get logDetails => {
    'app_version': version,
    'build_number': buildNumber,
    'device_id': deviceId,
    'os_version': osVersion,
    'model': model,
    'platform': Platform.isAndroid ? 'Android' : 'iOS',
  };
}
