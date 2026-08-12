import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/core/network/api_response.dart';
import 'package:rosewe_online_shopping/features/profile/data/models/profile_model.dart';

class ProfileRepository {
  Future<ApiResponse<UserProfile>> getProfile() async {
    try {
      final response = await ApiService.get(ApiEndpoints.getProfile);
      return ApiService.processResponse<UserProfile>(
        response,
        (json) => UserProfile.fromJson(json),
      );
    } catch (e) {
      return ApiResponse.error("Repository error: $e");
    }
  }

  Future<ApiResponse<bool>> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await ApiService.put(ApiEndpoints.updateProfile, body: data);
      return ApiService.processResponse<bool>(
        response,
        (json) => json['success'] ?? false,
      );
    } catch (e) {
      return ApiResponse.error("Repository error: $e");
    }
  }
}
