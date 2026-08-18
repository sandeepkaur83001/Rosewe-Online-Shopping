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
  var announcements = <HomeAnnouncement>[].obs;
  var offerCategory = Rxn<HomeOfferCategory>();
  var newArrivals = [].obs;
  var bestSellers = [].obs;
  var featuredProducts = [].obs;

  var tabProducts = [].obs;
  var isTabLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await SharedManager.getToken();
    getHomeData();
  }

  Future<void> fetchTabProducts(String type) async {
    try {
      isTabLoading(true);
      final response = await ApiImplementation.getProductCollection(type, param: 'type', showLoader: false);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final dynamic data = decoded['data'];
        if (data is List) {
          tabProducts.value = data;
        } else if (data is Map && data['data'] is List) {
          tabProducts.value = data['data'];
        } else {
          tabProducts.clear();
        }
      }
    } catch (e) {
      debugPrint("Error fetching tab products: $e");
    } finally {
      isTabLoading(false);
    }
  }

  Future<void> getHomeData({bool showLoader = false}) async {
    try {
      if (!showLoader) isLoading(true);
      
      final response = await repository.fetchHomeData(showLoader: showLoader);

      if (response.statusCode == 200) {
        final homeResponse = HomeResponse.fromJson(jsonDecode(response.body));
        if (homeResponse.data != null) {
          homeData.value = homeResponse.data;
          banners.value = homeResponse.data!.banners ?? [];
          categories.value = homeResponse.data!.categories ?? [];
          announcements.value = homeResponse.data!.announcements ?? [];
          offerCategory.value = homeResponse.data!.homeOfferCategory;
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
