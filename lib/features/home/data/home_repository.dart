import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:http/http.dart' as http;

class HomeRepository {
  Future<http.Response> fetchHomeData({bool showLoader = true}) async {
    return await ApiImplementation.getHomeData(showLoader: showLoader);
  }

  // If needed, keep the specific categories fetch or use the one from home data
  Future<http.Response> fetchCategories() async {
    return await ApiService.get(ApiEndpoints.getCategories);
  }
}
