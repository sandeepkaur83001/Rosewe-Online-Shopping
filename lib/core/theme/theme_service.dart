import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:get/get.dart';

class ThemeService {
  static final _key = 'isDarkMode';

  static void switchTheme() {
    bool isDarkMode = Get.isDarkMode;
    Get.changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
    SharedManager.setBoolSharePreferences(_key, !isDarkMode);
  }

  static void setSystemTheme() {
    Get.changeThemeMode(ThemeMode.system);
    SharedManager.deleteSpecificSharePreference(_key);
  }

  static Future<ThemeMode> getInitialTheme() async {
    bool? isDarkMode = await SharedManager.getBoolSharePreferences(_key);
    if (isDarkMode == null) return ThemeMode.system;
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
}

class AppThemes {
  static final light = ThemeData.light().copyWith(
    primaryColor: AppColors.custom_button_color,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    cardColor: AppColors.textFieldColor,
    dividerColor: AppColors.dividerColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.blackColor),
      titleTextStyle: TextStyle(color: AppColors.blackColor, fontSize: 18, fontWeight: FontWeight.bold),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.custom_button_color,
      secondary: AppColors.secondaryColor,
      surface: AppColors.whiteColor,
      error: AppColors.errorColor,
      onSurface: AppColors.blackColor,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.register_text_color),
      bodyMedium: TextStyle(color: AppColors.register_text_color),
    ),
  );

  static final dark = ThemeData.dark().copyWith(
    primaryColor: AppColors.custom_button_color,
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color(0xFF1E1E1E),
    dividerColor: Colors.white24,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.whiteColor),
      titleTextStyle: TextStyle(color: AppColors.whiteColor, fontSize: 18, fontWeight: FontWeight.bold),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.custom_button_color,
      secondary: AppColors.secondaryColor,
      surface: Color(0xFF1E1E1E),
      error: AppColors.errorColor,
      onSurface: AppColors.whiteColor,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );
}
