import 'package:flutter_base/util/common_imports.dart';



class SharedManager {
  static Future<String?> getStringSharePreferences(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<int?> getIntSharePreferences(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static Future<double?> getDoubleSharePreferences(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  static Future<bool?> getBoolSharePreferences(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<void> setStringSharePreferences(String key, String? value) async {
    if (value != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } else {
      await deleteSpecificSharePreference(key);
    }
  }

  static Future<void> setIntSharePreferences(String key, int? value) async {
    if (value != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(key, value);
    } else {
      await deleteSpecificSharePreference(key);
    }
  }

  static Future<void> setDoubleSharePreferences(String key, double? value) async {
    if (value != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(key, value);
    } else {
      await deleteSpecificSharePreference(key);
    }
  }

  static Future<void> setBoolSharePreferences(String key, bool? value) async {
    if (value != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
    } else {
      await deleteSpecificSharePreference(key);
    }
  }

  static Future<bool> deleteSpecificSharePreference(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = await prefs.remove(key);
    return result;
  }

  static Future<bool> deleteAllSharePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = await prefs.clear();

    return result;
  }

  // static Future<LoginModel?> getLoginData() async {
  //   String? data = await getStringSharePreferences(SharedConstants.LOGIN_MODEL);
  //   Globals.BearerToken = data != null ? (LoginModel.fromJson(jsonDecode(data)).data!.token ?? "") : null;
  //   return data != null ? LoginModel.fromJson(jsonDecode(data)) : null;
  // }

  static Future<bool?> getToken() async {
    // return true;
    if (Globals.BearerToken != null && Globals.BearerToken!.isNotEmpty) {
      CommonApiClass().normalPrintJson("USER_BEARER_TOKEN  ${Globals.BearerToken}");
      return true;
    } else {
      String? data = await getStringSharePreferences(SharedConstants.LOGIN_MODEL);
      // Globals.BearerToken = data != null ? (LoginModel.fromJson(jsonDecode(data)).data!.token ?? "") : null;
      // Globals.userIdRegister = data != null ? (LoginModel.fromJson(jsonDecode(data)).data?.user?.sId ?? "") : null;
      CommonApiClass().normalPrintJson("USER_BEARER_TOKEN  ${Globals.BearerToken}");

      return (Globals.BearerToken != null && Globals.BearerToken!.isNotEmpty) ? true : false;
    }
  }
}
