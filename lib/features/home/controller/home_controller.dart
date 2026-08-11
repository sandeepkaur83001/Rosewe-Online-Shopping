import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/home/data/home_repository.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final HomeRepository repository = HomeRepository();

  var isLoading = false.obs;
  var products = [].obs;
  var categories = [].obs;

  @override
  void onInit() {
    super.onInit();
    // getData(); // Call this when you want to load data on start
  }

  Future<void> getData() async {
    try {
      isLoading(true);
      
      // Parallel API calls
      final results = await Future.wait([
        repository.fetchHomeData(),
        repository.fetchCategories(),
      ]);

      if (results[0].statusCode == 200) {
        // products.value = parseProducts(results[0].body);
      }

      if (results[1].statusCode == 200) {
        // categories.value = parseCategories(results[1].body);
      }
      
    } catch (e) {
      debugPrint("Error in HomeController: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshData() async {
    await getData();
  }
}
