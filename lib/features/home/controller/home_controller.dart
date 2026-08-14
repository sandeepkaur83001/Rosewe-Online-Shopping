import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/home/data/home_repository.dart';
import 'package:rosewe_online_shopping/models/home/home_model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final HomeRepository repository = HomeRepository();

  var isLoading = false.obs;
  var homeData = Rxn<HomeData>();
  
  var banners = <HomeBanner>[].obs;
  var categories = <HomeCategory>[].obs;
  var newArrivals = [].obs;
  var bestSellers = [].obs;
  var featuredProducts = [].obs;

  @override
  void onInit() {
    super.onInit();
    getHomeData();
  }

  Future<void> getHomeData({bool showLoader = true}) async {
    try {
      if (!showLoader) isLoading(true);
      
      final response = await repository.fetchHomeData(showLoader: showLoader);

      if (response.statusCode == 200) {
        final homeResponse = HomeResponse.fromJson(jsonDecode(response.body));
        if (homeResponse.data != null) {
          homeData.value = homeResponse.data;
          banners.value = homeResponse.data!.banners ?? [];
          categories.value = homeResponse.data!.categories ?? [];
          newArrivals.value = homeResponse.data!.newArrivals ?? [];
          bestSellers.value = homeResponse.data!.bestSellers ?? [];
          featuredProducts.value = homeResponse.data!.featuredProducts ?? [];
        }
      }
      
    } catch (e) {
      debugPrint("Error in HomeController: $e");
    } finally {
      if (!showLoader) isLoading(false);
    }
  }

  Future<void> refreshData() async {
    await getHomeData(showLoader: false);
  }
}
