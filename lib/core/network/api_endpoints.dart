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
  static const String states = "states";
  static const String cart = "cart";
  static const String checkout = "checkout";
  static const String checkoutConfirm = "checkout/confirm";
  static const String orders = "orders";
  static const String wishlist = "wishlist";
  static const String wishlistToggle = "wishlist/toggle";

  // Contact
  static const String contactUs = "contact-us";
  static const String feedbackOptions = "feedback/options";
  static const String feedbackStore = "feedback";

  // Others
  static const String home = "home";
  static const String getProducts = "products/list";
  static String productDetail(int productId) => "products/$productId";
  static const String productCollection = "products/collection";
  static const String getNewIn = "products/new-in";
  static const String cartRecommendations = "recommendations/cart";
  static const String addToCart = "cart/add";
  static const String updateCart = "cart/update";
  static const String removeFromCart = "cart/remove";
  static const String getCategories = "categories/list";
  static const String categoryTree = "categories/tree";
  static const String getBanners = "marketing/banners";
  static const String getDailyCheckIn = "daily-checkin";
}
