import 'package:flutter_base/util/base_guide.dart';
import 'package:flutter_base/util/common_imports.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjection.init();

  await PushNotifications.localNotificationInit();
  await PushNotifications().requestNotificationPermission();

  Get.put(NetworkController(), permanent: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: BaseGuide(),
    );
  }
}
