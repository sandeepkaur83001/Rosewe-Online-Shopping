import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:get/get.dart';
import 'package:rosewe_online_shopping/features/profile/data/models/profile_model.dart';
import 'package:rosewe_online_shopping/features/profile/data/repository/profile_repository.dart';

class ProfileController extends GetxController {
  final ProfileRepository _repository = ProfileRepository();

  var isLoading = false.obs;
  var userProfile = Rxn<UserProfile>();
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchProfile(); // Uncomment when ready to fetch from API
  }

  Future<void> fetchProfile() async {
    try {
      isLoading(true);
      errorMessage('');
      final response = await _repository.getProfile();
      if (response.success) {
        userProfile.value = response.data;
      } else {
        errorMessage.value = response.message ?? 'Failed to load profile';
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      debugPrint("Error in ProfileController: $e");
    } finally {
      isLoading(false);
    }
  }

  void logout() {
    // Implement logout logic, clear tokens, etc.
    userProfile.value = null;
    Globals.BearerToken = null;
    // Navigate to login or home
  }
}
