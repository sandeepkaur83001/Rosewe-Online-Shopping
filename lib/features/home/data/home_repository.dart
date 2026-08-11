import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:http/http.dart' as http;

class HomeRepository {
  Future<http.Response> fetchHomeData() async {
    // In a real app, you might have a single endpoint for home or multiple
    return await ApiService.get(ApiEndpoints.getProducts);
  }

  Future<http.Response> fetchCategories() async {
    return await ApiService.get(ApiEndpoints.getCategories);
  }
}
