import 'package:flutter_base/features/guide/base_guide.dart';
import 'package:flutter_base/core/common_imports.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjection.init();
  await DeviceInfoUtil.init();

  await PushNotifications.localNotificationInit();
  await PushNotifications().requestNotificationPermission();

  ThemeMode initialTheme = await ThemeService.getInitialTheme();
  
  runApp(MyApp(initialTheme: initialTheme));
}

class MyApp extends StatelessWidget {
  final ThemeMode initialTheme;
  const MyApp({super.key, required this.initialTheme});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: initialTheme,
      home: BaseGuide(),
    );
  }
}
