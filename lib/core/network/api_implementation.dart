import 'dart:io';
import 'dart:convert';

import 'package:rosewe_online_shopping/core/common_imports.dart';
import 'package:rosewe_online_shopping/core/network/api_endpoints.dart';
import 'package:http/http.dart' as http;

class ApiImplementation {
  // --- Auth APIs ---

  static Future<AuthResponse?> register(Map<String, dynamic> body, {List<File>? files, bool showLoader = true}) async {
    final response = await ApiService.formPost(ApiEndpoints.register, body: body, files: files, headers: ApiService.defaultHeaders, showLoader: showLoader);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  static Future<AuthResponse?> login(Map<String, dynamic> body, {bool showLoader = true}) async {
    final response = await ApiService.post(ApiEndpoints.login, body: body, headers: ApiService.defaultHeaders, showLoader: showLoader);
    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  static Future<AuthResponse?> socialLogin(Map<String, dynamic> body, {bool showLoader = true}) async {
    final response = await ApiService.formPost(ApiEndpoints.socialLogin, body: body, headers: ApiService.defaultHeaders, showLoader: showLoader);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  static Future<DeleteReasonResponse?> getDeleteReasons({bool showLoader = true}) async {
    final response = await ApiService.get(ApiEndpoints.deleteReasons, headers: ApiService.defaultHeaders, showLoader: showLoader);
    if (response.statusCode == 200) {
      return DeleteReasonResponse.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  static Future<http.Response> changePassword(Map<String, dynamic> body, {bool showLoader = true}) async {
    return await ApiService.formPost(ApiEndpoints.changePassword, body: body, headers: ApiService.defaultHeaders, showLoader: showLoader);
  }

  static Future<http.Response> logout({bool showLoader = true}) async {
    return await ApiService.post(ApiEndpoints.logout, headers: ApiService.defaultHeaders, showLoader: showLoader);
  }

  static Future<http.Response> deleteAccount(Map<String, dynamic> body, {bool showLoader = true}) async {
    return await ApiService.delete(ApiEndpoints.deleteAccount, body: body, headers: ApiService.defaultHeaders, showLoader: showLoader);
  }

  // --- Profile APIs ---

  static Future<ProfileCategoryResponse?> getProfileCategories({bool showLoader = true}) async {
    final response = await ApiService.get(ApiEndpoints.profileCategories, headers: ApiService.defaultHeaders, showLoader: showLoader);
    if (response.statusCode == 200) {
      return ProfileCategoryResponse.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  static Future<ProfileStyleResponse?> getProfileStyles({bool showLoader = true}) async {
    final response = await ApiService.get(ApiEndpoints.profileStyles, headers: ApiService.defaultHeaders, showLoader: showLoader);
    if (response.statusCode == 200) {
      return ProfileStyleResponse.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  static Future<ProfileCountryResponse?> getProfileCountries({bool showLoader = true}) async {
    final response = await ApiService.get(ApiEndpoints.profileCountries, headers: ApiService.defaultHeaders, showLoader: showLoader);
    if (response.statusCode == 200) {
      return ProfileCountryResponse.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  static Future<ProfileCurrencyResponse?> getProfileCurrencies({bool showLoader = true}) async {
    final response = await ApiService.get(ApiEndpoints.profileCurrencies, headers: ApiService.defaultHeaders, showLoader: showLoader);
    if (response.statusCode == 200) {
      return ProfileCurrencyResponse.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  static Future<http.Response> getProfile({bool showLoader = true}) async {
    return await ApiService.get(ApiEndpoints.profile, headers: ApiService.defaultHeaders, showLoader: showLoader);
  }

  static Future<http.Response> updateProfile(Map<String, dynamic> body, {bool showLoader = true}) async {
    return await ApiService.formPut(ApiEndpoints.profile, body: body, showLoader: showLoader);
  }

  // --- Address APIs ---

  static Future<http.Response> getStates(String countryId, {bool showLoader = true}) async {
    return await ApiService.get("${ApiEndpoints.states}?country_id=$countryId", headers: ApiService.defaultHeaders, showLoader: showLoader);
  }

  static Future<http.Response> getAddresses({bool showLoader = true}) async {
    return await ApiService.get(ApiEndpoints.addresses, headers: ApiService.defaultHeaders, showLoader: showLoader);
  }

  static Future<http.Response> addAddress(Map<String, dynamic> body, {bool showLoader = true}) async {
    return await ApiService.formPost(ApiEndpoints.addresses, body: body, showLoader: showLoader);
  }

  static Future<http.Response> updateAddress(String addressId, Map<String, dynamic> body, {bool showLoader = true}) async {
    // Convert dynamic map to string map for x-www-form-urlencoded
    final stringBody = body.map((key, value) => MapEntry(key, value.toString()));
    return await ApiService.formPutEncoded(ApiEndpoints.addressDetail(addressId), body: stringBody, showLoader: showLoader);
  }

  static Future<http.Response> deleteAddress(String addressId, {bool showLoader = true}) async {
    return await ApiService.delete(ApiEndpoints.addressDetail(addressId), headers: ApiService.defaultHeaders, showLoader: showLoader);
  }

  // --- Contact APIs ---

  static Future<http.Response> contactUs(Map<String, dynamic> body, {bool showLoader = true}) async {
    return await ApiService.formPost(ApiEndpoints.contactUs, body: body, showLoader: showLoader);
  }

  static Future<http.Response> getFeedbackOptions({bool showLoader = true}) async {
    return await ApiService.get(ApiEndpoints.feedbackOptions, headers: ApiService.defaultHeaders, showLoader: showLoader);
  }

  // --- Home APIs ---

  static Future<http.Response> getHomeData({bool showLoader = true}) async {
    return await ApiService.get(ApiEndpoints.home, headers: ApiService.defaultHeaders, showLoader: showLoader);
  }

  static Future<http.Response> getCategoryTree({bool showLoader = true}) async {
    return await ApiService.get(ApiEndpoints.categoryTree, headers: ApiService.defaultHeaders, showLoader: showLoader);
  }

  static Future<http.Response> getNewInProducts({bool showLoader = true}) async {
    return await ApiService.get(ApiEndpoints.getNewIn, headers: ApiService.defaultHeaders, showLoader: showLoader);
  }

  static Future<http.Response> getCartRecommendations({bool showLoader = true}) async {
    return await ApiService.get(ApiEndpoints.cartRecommendations, headers: ApiService.defaultHeaders, showLoader: showLoader);
  }

  static Future<http.Response> addToCart(Map<String, dynamic> body, {bool showLoader = true}) async {
    return await ApiService.formPost(ApiEndpoints.addToCart, body: body, showLoader: showLoader);
  }

  static Future<http.Response> updateCart(Map<String, dynamic> body, {bool showLoader = true}) async {
    return await ApiService.formPost(ApiEndpoints.updateCart, body: body, showLoader: showLoader);
  }

  static Future<http.Response> removeFromCart(String productId, {bool showLoader = true}) async {
    return await ApiService.delete("${ApiEndpoints.removeFromCart}?product_id=$productId", headers: ApiService.defaultHeaders, showLoader: showLoader);
  }

  static Future<http.Response> getCart({bool showLoader = true}) async {
    return await ApiService.get(ApiEndpoints.cart, headers: ApiService.defaultHeaders, showLoader: showLoader);
  }

  static Future<http.Response> checkout(Map<String, dynamic> body, {bool showLoader = true}) async {
    return await ApiService.formPost(ApiEndpoints.checkout, body: body, showLoader: showLoader);
  }

  static Future<http.Response> confirmCheckout(Map<String, dynamic> body, {bool showLoader = true}) async {
    return await ApiService.formPost(ApiEndpoints.checkoutConfirm, body: body, showLoader: showLoader);
  }

  static Future<http.Response> getOrders({bool showLoader = true}) async {
    return await ApiService.get(ApiEndpoints.orders, headers: ApiService.defaultHeaders, showLoader: showLoader);
  }

  static Future<http.Response> getWishlist({bool showLoader = true}) async {
    return await ApiService.get(ApiEndpoints.wishlist, headers: ApiService.defaultHeaders, showLoader: showLoader);
  }

  static Future<http.Response> toggleWishlist(Map<String, dynamic> body, {bool showLoader = true}) async {
    return await ApiService.formPost(ApiEndpoints.wishlistToggle, body: body, showLoader: showLoader);
  }

  // Legacy/Example placeholders
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
}
