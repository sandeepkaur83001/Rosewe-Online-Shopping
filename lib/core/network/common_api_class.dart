import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http show get;

class CommonApiClass {
  CommonApiClass();

  String photoUrlGenerate(String url) {
    if (url.contains("google")) {
      return url;
    } else if (url.contains(ApiService.baseUrlPhoto)) {
      return url;
    } else {
      return ApiService.baseUrlPhoto + removeLeadingSlash(url);
    }
  }

  String removeLeadingSlash(String url) {
    return url.startsWith('/') ? url.substring(1) : url;
  }

  Future<void> prettyJson(String data) async {
    if (kDebugMode) {
      developer.log("<----      API_RESPONSE_JSON_STRING      ---->");
    }
    final jsonObject = json.decode(data);
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    String prettyJson = encoder.convert(jsonObject);
    if (kDebugMode) {
      await printVeryLongJson(prettyJson);
    }
    if (kDebugMode) {
      developer.log("<----      API_RESPONSE_JSON_STRING_END      ---->");
    }
  }

  void normalPrintJson(String data) {
    if (kDebugMode) {
      developer.log(data);
    }
  }

  Future<void> printVeryLongJson(String prettyJson) async {
    prettyJson.split('\n').forEach((line) {
      if (kDebugMode) {
        developer.log(line, name: '');
      }
    });
  }

  /// DEBUGGING TERMINATES STATE

  Future<void> API_CALL_FOR_DEBUGGING(String value) async {
    final dialog = Get.find<DialogService>();
    final url = Uri.parse('http://192.168.18.126:8080/rgurest');
    dialog.showLoader();

    try {
      final response = await http.get(url);
      // final response = await http.post(
      //   url,
      //   headers: {'Content-Type': 'text/plain'},
      //   body: value,
      // );
      if (response.statusCode == 200) {
        printSuccess('Response: ${response.body}');
      } else {
        printError('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      printError('Error: $e');
    }

  dialog.hideLoader();
  }

  /**   DEBUGGING TERMINATES STATE */
}
