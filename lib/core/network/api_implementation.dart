import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/core/network/api_endpoints.dart';
import 'package:http/http.dart' as http;

class ApiImplementation {
  
  // Example GET call for products
  static Future<void> fetchProducts() async {
    try {
      final response = await ApiService.get(ApiEndpoints.getProducts, headers: ApiService.defaultHeaders);
      if (response.statusCode == 200) {
        // Parse data here
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
    }
  }

  // Example POST call for login
  static Future<void> loginUser(String email) async {
    try {
      final body = {"email": email};
      final response = await ApiService.post(ApiEndpoints.login, body: body, headers: ApiService.defaultHeaders);
      if (response.statusCode == 200) {
        // Handle success login
      }
    } catch (e) {
      debugPrint("Error logging in: $e");
    }
  }

  // Example GET call for categories
  static Future<void> fetchCategories() async {
    try {
      final response = await ApiService.get(ApiEndpoints.getCategories, headers: ApiService.defaultHeaders);
      if (response.statusCode == 200) {
        // Parse data here
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    }
  }
}
