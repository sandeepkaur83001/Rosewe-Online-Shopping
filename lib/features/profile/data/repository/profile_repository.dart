import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/features/profile/data/models/profile_model.dart';

class ProfileRepository {
  Future<ProfileResponse?> getProfile({bool showLoader = true}) async {
    try {
      final response = await ApiService.get(ApiEndpoints.profile, showLoader: showLoader);
      if (response.statusCode == 200) {
        return ProfileResponse.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      debugPrint("Repository error: $e");
      return null;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data, {bool showLoader = true}) async {
    try {
      final response = await ApiService.put(ApiEndpoints.profile, body: data, showLoader: showLoader);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Repository error: $e");
      return false;
    }
  }
}
