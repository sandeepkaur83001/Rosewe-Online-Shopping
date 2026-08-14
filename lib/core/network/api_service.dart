import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rosewe_online_shopping/core/common_imports.dart';

import '../../features/profile/controller/profile_controller.dart';
import 'api_response.dart';

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
    bool showLoader = true,
  }) async {
    final dialog = Get.find<DialogService>();
    if (showLoader) {
      dialog.showLoader();
    }
    try {
      final requestHeaders = headers ?? defaultHeaders;
      CommonApiClass().normalPrintJson("API_RESPONSE_URL '$_baseUrl$endpoint");
      CommonApiClass().normalPrintJson("API_HEADER '$requestHeaders");
      final response = await http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: requestHeaders,
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
      if (showLoader) {
        dialog.hideLoader();
      }
    }
  }

  static Future<http.Response> put(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
    bool showLoader = true,
  }) async {
    final dialog = Get.find<DialogService>();
    if (showLoader) {
      dialog.showLoader();
    }
    
    final requestHeaders = headers ?? defaultHeaders;
    CommonApiClass().normalPrintJson("API_RESPONSE_URL '$_baseUrl$endpoint");
    CommonApiClass().normalPrintJson("API_HEADER '$requestHeaders");
    CommonApiClass().normalPrintJson("API_BODY '${jsonEncode(body)}");
    try {
      final jsonBody = body ?? {};
      final response = await http.put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: requestHeaders,
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
      if (showLoader) {
        dialog.hideLoader();
      }
    }
  }

  static Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
    bool showLoader = true,
  }) async {
    final dialog = Get.find<DialogService>();
    if (showLoader) {
      dialog.showLoader();
    }

    final requestHeaders = headers ?? defaultHeaders;
    CommonApiClass().normalPrintJson("API_RESPONSE_URL '$_baseUrl$endpoint");
    CommonApiClass().normalPrintJson("API_HEADER '$requestHeaders");
    CommonApiClass().normalPrintJson("API_BODY '${jsonEncode(body)}");
    try {
      final jsonBody = body ?? {};
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: requestHeaders,
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
      if (showLoader) {
        dialog.hideLoader();
      }
    }
  }

  static Future<http.Response> formPost(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    List<File>? files,
    String fileType = 'file',
    bool showLoader = true,
  }) async {
    final dialog = Get.find<DialogService>();
    if (showLoader) {
      dialog.showLoader();
    }

    final requestHeaders = headers ?? defaultHeaders;
    CommonApiClass().normalPrintJson("API_RESPONSE_URL '$_baseUrl$endpoint");
    CommonApiClass().normalPrintJson("API_HEADER '$requestHeaders");
    CommonApiClass().normalPrintJson("API_BODY '$body");
    try {
      final requestHeaders = Map<String, String>.from(headers ?? defaultHeaders);
      requestHeaders.remove('Content-Type'); // Let MultipartRequest set the boundary
      
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl$endpoint'),
      );
      request.headers.addAll(requestHeaders);

      if (body != null) {
        body.forEach((key, value) {
          if (value is List) {
            if (value.isEmpty) {
              request.fields['$key[]'] = '';
            } else {
              for (var item in value) {
                request.fields['$key[]'] = item.toString();
              }
            }
          } else {
            request.fields[key] = value.toString();
          }
        });
      }
      if (files != null) {
        for (int i = 0; i < files.length; i++) {
          request.files.add(
            await http.MultipartFile.fromPath(fileType, files[i].path),
          );
        }
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
      if (showLoader) {
        dialog.hideLoader();
      }
    }
  }

  static Future<http.Response> formPut(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    List<File>? files,
    String? fileName,
    bool showLoader = true,
  }) async {
    final dialog = Get.find<DialogService>();
    if (showLoader) {
      dialog.showLoader();
    }

    final requestHeaders = headers ?? defaultHeaders;
    CommonApiClass().normalPrintJson("API_RESPONSE_URL '$_baseUrl$endpoint");
    CommonApiClass().normalPrintJson("API_HEADER '$requestHeaders");
    CommonApiClass().normalPrintJson("API_BODY '$body");
    try {
      final requestHeaders = Map<String, String>.from(headers ?? defaultHeaders);
      requestHeaders.remove('Content-Type'); // Let MultipartRequest set the boundary

      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$_baseUrl$endpoint'),
      );
      request.headers.addAll(requestHeaders);
      if (body != null) {
        body.forEach((key, value) {
          if (value is List) {
            if (value.isEmpty) {
              request.fields['$key[]'] = '';
            } else {
              for (var item in value) {
                request.fields['$key[]'] = item.toString();
              }
            }
          } else {
            request.fields[key] = value.toString();
          }
        });
      }
      if (files != null && fileName != null) {
        for (int i = 0; i < files.length; i++) {
          request.files.add(
            await http.MultipartFile.fromPath(fileName, files[i].path),
          );
        }
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
      if (showLoader) {
        dialog.hideLoader();
      }
    }
  }

  static Future<http.Response> formPutEncoded(
    String endpoint, {
    Map<String, String>? headers,
    required Map<String, String> body,
    bool showLoader = true,
  }) async {
    final dialog = Get.find<DialogService>();
    if (showLoader) {
      dialog.showLoader();
    }
    final requestHeaders = headers ?? defaultHeaders;
    requestHeaders['Content-Type'] = 'application/x-www-form-urlencoded';
    
    CommonApiClass().normalPrintJson("API_RESPONSE_URL '$_baseUrl$endpoint");
    CommonApiClass().normalPrintJson("API_HEADER '$requestHeaders");
    CommonApiClass().normalPrintJson("API_BODY '$body");
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: requestHeaders,
        body: body,
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
      if (showLoader) {
        dialog.hideLoader();
      }
    }
  }

  static Future<http.Response> formDelete(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    bool showLoader = true,
  }) async {
    final dialog = Get.find<DialogService>();
    if (showLoader) {
      dialog.showLoader();
    }

    final requestHeaders = headers ?? defaultHeaders;
    CommonApiClass().normalPrintJson("API_RESPONSE_URL '$_baseUrl$endpoint");
    CommonApiClass().normalPrintJson("API_HEADER '$requestHeaders");
    CommonApiClass().normalPrintJson("API_BODY '$body");
    try {
      final requestHeaders = Map<String, String>.from(headers ?? defaultHeaders);
      requestHeaders.remove('Content-Type'); // Let MultipartRequest set the boundary

      final request = http.MultipartRequest(
        'DELETE',
        Uri.parse('$_baseUrl$endpoint'),
      );
      request.headers.addAll(requestHeaders);

      if (body != null) {
        body.forEach((key, value) {
          if (value is List) {
            if (value.isEmpty) {
              request.fields['$key[]'] = '';
            } else {
              for (var item in value) {
                request.fields['$key[]'] = item.toString();
              }
            }
          } else {
            request.fields[key] = value.toString();
          }
        });
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
      if (showLoader) {
        dialog.hideLoader();
      }
    }
  }

  static Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
    bool showLoader = true,
  }) async {
    final dialog = Get.find<DialogService>();
    if (showLoader) {
      dialog.showLoader();
    }

    final requestHeaders = headers ?? defaultHeaders;
    CommonApiClass().normalPrintJson("API_RESPONSE_URL '$_baseUrl$endpoint");
    CommonApiClass().normalPrintJson("API_HEADER '$requestHeaders");
    CommonApiClass().normalPrintJson("API_BODY '${jsonEncode(body)}");
    try {
      final jsonBody = body ?? {};
      final response = await http.delete(
        Uri.parse('$_baseUrl$endpoint'),
        headers: requestHeaders,
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
      if (showLoader) {
        dialog.hideLoader();
      }
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
        CommonApiClass().normalPrintJson(
          "API_STATUS_CODE${response.statusCode}",
        );
        CommonApiClass().normalPrintJson(
          "API_RESPONSE_JSON_STRING ${response.body}",
        );

        if (response.statusCode == 401) {
          final decoded = jsonDecode(response.body);
          if (decoded["message"] == "Unauthorized" || decoded["message"] == "Unauthenticated.") {
            final profileController = Get.find<ProfileController>();
            profileController.logout();
            
            CustomToast.showToast(message: "Session expired. Please login again.");
            // We don't import LoginScreen here to avoid circular dependencies
            // We trigger a global logout which UI observers can react to
          }
        }
      }
    } catch (e) {
      CommonApiClass().normalPrintJson("API_ERROR_IN_DECODING$e");
    }
  }

  /// Helper to process raw response into ApiResponse
  static ApiResponse<T> processResponse<T>(
    http.Response response,
    T Function(dynamic json) fromJson,
  ) {
    try {
      final decoded = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Assuming the actual data is in a 'data' field or is the root object
        final data = decoded is Map && decoded.containsKey('data') 
            ? fromJson(decoded['data']) 
            : fromJson(decoded);
        return ApiResponse.success(data, statusCode: response.statusCode);
      } else {
        final message = decoded is Map ? decoded['message'] ?? 'Unknown error' : 'Error: ${response.statusCode}';
        return ApiResponse.error(message, statusCode: response.statusCode);
      }
    } catch (e) {
      return ApiResponse.error("Failed to parse response: $e", statusCode: response.statusCode);
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
