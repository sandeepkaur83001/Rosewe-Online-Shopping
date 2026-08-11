import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rosewe_online_shopping/core/common_imports.dart';

class ApiService {
  // Use EnvConfig for URLs
  static String get _baseUrl => EnvConfig.baseUrl;
  static String get baseUrlPhoto => EnvConfig.baseUrlPhoto;

  ApiService();

  static Map<String, String> get defaultHeaders {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (Globals.BearerToken != null) 'Authorization': 'Bearer ${Globals.BearerToken}',
    };
  }

  static Future<http.Response> get( 
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final dialog = Get.find<DialogService>();
    dialog.showLoader();
    try {
      CommonApiClass().normalPrintJson("API_RESPONSE_URL '$_baseUrl$endpoint");
      CommonApiClass().normalPrintJson("API_HEADER '$headers");
      final response = await http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: headers,
      );
      _handleResponse(response);
      return response;
    } catch (ex) {
      CrashedApiResponse response = CrashedApiResponse(message: ex.toString());
      CommonApiClass().normalPrintJson("API_ERROR_DATA  $ex");
      String jsonResponse = jsonEncode(response);

      var responses = http.Response(
        jsonResponse,
        response.statusCode ?? 500,
        headers: {'Content-Type': 'application/json'},
      );
      _handleResponse(responses);
      return responses;
    } finally {
      dialog.hideLoader();
    }
  }

  static Future<http.Response> put(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final dialog = Get.find<DialogService>();
    dialog.showLoader();
    CommonApiClass().normalPrintJson("API_RESPONSE_URL '$_baseUrl$endpoint");
    CommonApiClass().normalPrintJson("API_HEADER '$headers");
    CommonApiClass().normalPrintJson("API_BODY '${jsonEncode(body)}");
    try {
      final jsonBody = body ?? {};
      final response = await http.put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(jsonBody),
      );
      _handleResponse(response);
      return response;
    } catch (ex) {
      CommonApiClass().normalPrintJson("API_ERROR_DATA  $ex");
      CrashedApiResponse response = CrashedApiResponse(message: ex.toString());
      String jsonResponse = jsonEncode(response);

      var responses = http.Response(
        jsonResponse,
        response.statusCode ?? 500,
        headers: {'Content-Type': 'application/json'},
      );
      _handleResponse(responses);

      return responses;
    } finally {
      dialog.hideLoader();
    }
  }

  static Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final dialog = Get.find<DialogService>();
    dialog.showLoader();
    CommonApiClass().normalPrintJson("API_RESPONSE_URL '$_baseUrl$endpoint");
    CommonApiClass().normalPrintJson("API_HEADER '$headers");
    CommonApiClass().normalPrintJson("API_BODY '${jsonEncode(body)}");
    try {
      final jsonBody = body ?? {};
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(jsonBody),
      );
      _handleResponse(response);
      return response;
    } catch (ex) {
      CommonApiClass().normalPrintJson("API_ERROR_DATA  $ex");
      CrashedApiResponse response = CrashedApiResponse(message: ex.toString());
      String jsonResponse = jsonEncode(response);

      var responses = http.Response(
        jsonResponse,
        response.statusCode ?? 500,
        headers: {'Content-Type': 'application/json'},
      );
      _handleResponse(responses);

      return responses;
    } finally {
      dialog.hideLoader();
    }
  }

  static Future<http.Response> formPost(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
    required List<File> files,
    String fileType = 'file',
  }) async {
    final dialog = Get.find<DialogService>();
    dialog.showLoader();
    CommonApiClass().normalPrintJson("API_RESPONSE_URL '$_baseUrl$endpoint");
    CommonApiClass().normalPrintJson("API_HEADER '$headers");
    CommonApiClass().normalPrintJson("API_BODY '$body");
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl$endpoint'),
      );
      request.headers.addAll(headers ?? {});

      if (body != null) {
        request.fields.addAll(body is Map ? body.cast<String, String>() : {});
      }
      for (int i = 0; i < files.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath(fileType, files[i].path),
        );
      }
      final response = await http.Response.fromStream(await request.send());
      _handleResponse(response);
      return response;
    } catch (ex) {
      CommonApiClass().normalPrintJson("API_ERROR_DATA  $ex");
      CrashedApiResponse response = CrashedApiResponse(message: ex.toString());
      String jsonResponse = jsonEncode(response);
      var responses = http.Response(
        jsonResponse,
        response.statusCode ?? 500,
        headers: {'Content-Type': 'application/json'},
      );
      _handleResponse(responses);

      return responses;
    } finally {
      dialog.hideLoader();
    }
  }

  static Future<http.Response> formPut(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? body,
    required List<File> files,
    required String fileName,
  }) async {
    final dialog = Get.find<DialogService>();
    dialog.showLoader();
    CommonApiClass().normalPrintJson("API_RESPONSE_URL '$_baseUrl$endpoint");
    CommonApiClass().normalPrintJson("API_HEADER '$headers");
    CommonApiClass().normalPrintJson("API_BODY '$body");
    // DateTime startTime = DateTime.now();
    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$_baseUrl$endpoint'),
      );
      request.headers.addAll(headers ?? {});
      if (body != null) {
        request.fields.addAll(body);
      }
      for (int i = 0; i < files.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath(fileName, files[i].path),
        );
      }
      final response = await http.Response.fromStream(await request.send());

      _handleResponse(response);
      return response;
    } catch (ex) {
      CommonApiClass().normalPrintJson("API_ERROR_DATA  $ex");
      CrashedApiResponse response = CrashedApiResponse(message: ex.toString());
      String jsonResponse = jsonEncode(response);
      var responses = http.Response(
        jsonResponse,
        response.statusCode ?? 500,
        headers: {'Content-Type': 'application/json'},
      );
      _handleResponse(responses);

      return responses;
    } finally {
      dialog.hideLoader();
    }
  }

  static Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final dialog = Get.find<DialogService>();
    dialog.showLoader();
    CommonApiClass().normalPrintJson("API_RESPONSE_URL '$_baseUrl$endpoint");
    CommonApiClass().normalPrintJson("API_HEADER '$headers");
    CommonApiClass().normalPrintJson("API_BODY '${jsonEncode(body)}");
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );

      _handleResponse(response);
      return response;
    } catch (ex) {
      CommonApiClass().normalPrintJson("API_ERROR_DATA  $ex");
      CrashedApiResponse response = CrashedApiResponse(message: ex.toString());
      String jsonResponse = jsonEncode(response);
      var responses = http.Response(
        jsonResponse,
        response.statusCode ?? 500,
        headers: {'Content-Type': 'application/json'},
      );
      _handleResponse(responses);

      return responses;
    } finally {
      dialog.hideLoader();
    }
  }

  static void _handleResponse(http.Response response) async {
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        
        CommonApiClass().normalPrintJson(
          "API_STATUS_CODE${response.statusCode}",
        );
        CommonApiClass().prettyJson(response.body);
      } else {
     
        if (response.statusCode == 401 &&
            jsonDecode(response.body)["message"] == "Unauthorized") {
          Future.delayed(Duration(seconds: 1), () {});
        }
        CommonApiClass().normalPrintJson(
          "API_STATUS_CODE${response.statusCode}",
        );
        CommonApiClass().normalPrintJson(
          "API_RESPONSE_JSON_STRING ${response.body}",
        );
      }
    } catch (e) {
      CommonApiClass().normalPrintJson("API_ERROR_IN_DECODING$e");
    }
  }

  static void showJsonDialog(BuildContext context, String formattedJson) {
    /// this a code is use  functional but not use in current state
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Incoming Data",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: SelectableText(
            formattedJson,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: formattedJson));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Copied to clipboard")),
              );
            },
            child: const Text(
              "Copy",
              style: TextStyle(color: Color(0xffFFDE59)),
            ),
          ),

          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Done", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
