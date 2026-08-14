import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:get/get.dart';
import 'package:rosewe_online_shopping/features/profile/data/models/profile_model.dart';
import 'package:rosewe_online_shopping/features/profile/data/repository/profile_repository.dart';

class ProfileController extends GetxController {
  final ProfileRepository _repository = ProfileRepository();

  var isLoading = false.obs;
  var userProfile = Rxn<UserProfile>();
  var errorMessage = ''.obs;
  var isLoggedIn = false.obs;

  var categories = <ProfileCategoryData>[].obs;
  var styles = <ProfileStyleData>[].obs;
  var countries = <ProfileCountryData>[].obs;
  var currencies = <ProfileCurrencyData>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    await checkLoginStatus();
    if (isLoggedIn.value) {
      await fetchInitialData();
    }
  }

  Future<void> checkLoginStatus() async {
    final hasToken = await SharedManager.getToken();
    isLoggedIn.value = (Globals.BearerToken != null && Globals.BearerToken!.isNotEmpty) || (hasToken ?? false);
  }

  Future<void> fetchInitialData() async {
    if (!isLoggedIn.value) return;

    await Future.wait([
      fetchProfile(showLoader: true),
      fetchCategories(),
      fetchStyles(),
      fetchCountries(),
      fetchCurrencies(),
    ]);
  }

  Future<void> fetchCategories() async {
    try {
      final response = await ApiImplementation.getProfileCategories(showLoader: true);
      if (response != null && response.status == 200) {
        categories.value = response.data ?? [];
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    }
  }

  Future<void> fetchStyles() async {
    try {
      final response = await ApiImplementation.getProfileStyles(showLoader: true);
      if (response != null && response.status == 200) {
        styles.value = response.data ?? [];
      }
    } catch (e) {
      debugPrint("Error fetching styles: $e");
    }
  }

  Future<void> fetchCountries() async {
    try {
      final response = await ApiImplementation.getProfileCountries(showLoader: true);
      if (response != null && response.status == 200) {
        countries.value = response.data ?? [];
      }
    } catch (e) {
      debugPrint("Error fetching countries: $e");
    }
  }

  Future<void> fetchCurrencies() async {
    try {
      final response = await ApiImplementation.getProfileCurrencies(showLoader: true);
      if (response != null && response.status == 200) {
        currencies.value = response.data ?? [];
      }
    } catch (e) {
      debugPrint("Error fetching currencies: $e");
    }
  }

  Future<void> fetchProfile({bool showLoader = true}) async {
    if (Globals.BearerToken == null || Globals.BearerToken!.isEmpty) {
      debugPrint("Skipping fetchProfile: Token is null or empty");
      return;
    }
    try {
      errorMessage('');
      debugPrint("Fetching profile... Token: ${Globals.BearerToken}");
      final response = await _repository.getProfile(showLoader: showLoader);
      if (response != null && response.status == 200) {
        debugPrint("Profile fetched successfully: ${response.data?.name}");
        userProfile.value = response.data;
        isLoggedIn.value = true;
      } else {
        debugPrint("Failed to fetch profile: ${response?.message} (Status: ${response?.status})");
        errorMessage.value = response?.message ?? 'Failed to load profile';
        if (response?.status == 401) {
          isLoggedIn.value = false;
        }
      }
    } catch (e) {
      debugPrint("Error in ProfileController.fetchProfile: $e");
      errorMessage.value = 'An unexpected error occurred';
    }
  }

  void logout() {
    userProfile.value = null;
    Globals.BearerToken = null;
    isLoggedIn.value = false;
    SharedManager.deleteSpecificSharePreference(SharedConstants.LOGIN_MODEL);
  }
}
