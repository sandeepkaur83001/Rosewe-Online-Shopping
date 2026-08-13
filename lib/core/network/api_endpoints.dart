class ApiEndpoints {
  // Auth
  static const String register = "auth/register";
  static const String login = "auth/login";
  static const String socialLogin = "auth/social";
  static const String deleteReasons = "auth/delete-reasons";
  static const String changePassword = "auth/change-password";
  static const String logout = "auth/logout";
  static const String deleteAccount = "auth/delete-account";

  // Profile
  static const String profileCategories = "profile/categories";
  static const String profileStyles = "profile/styles";
  static const String profileCountries = "profile/countries";
  static const String profileCurrencies = "profile/currencies";
  static const String profile = "profile";

  // Addresses
  static const String addresses = "addresses";
  static String addressDetail(String addressId) => "addresses/$addressId";

  // Contact
  static const String contactUs = "contact-us";

  // Others
  static const String getProducts = "products/list";
  static const String getCategories = "categories/list";
  static const String getBanners = "marketing/banners";
  static const String getDailyCheckIn = "user/daily-checkin";
}
