class HomeResponse {
  final String? success;
  final int? status;
  final String? message;
  final HomeData? data;

  HomeResponse({this.success, this.status, this.message, this.data});

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? HomeData.fromJson(json['data']) : null,
    );
  }
}

class HomeData {
  final List<HomeBanner>? banners;
  final List<HomeCategory>? categories;
  final List<HomeAnnouncement>? announcements;
  final HomeOfferCategory? homeOfferCategory;
  final dynamic flashSale;
  final List<dynamic>? newArrivals;
  final List<dynamic>? bestSellers;
  final List<dynamic>? featuredProducts;

  HomeData({
    this.banners,
    this.categories,
    this.announcements,
    this.homeOfferCategory,
    this.flashSale,
    this.newArrivals,
    this.bestSellers,
    this.featuredProducts,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      banners: (json['banners'] as List?)
          ?.map((i) => HomeBanner.fromJson(i))
          .toList(),
      categories: (json['categories'] as List?)
          ?.map((i) => HomeCategory.fromJson(i))
          .toList(),
      announcements: (json['announcements'] as List?)
          ?.map((i) => HomeAnnouncement.fromJson(i))
          .toList(),
      homeOfferCategory: json['home_offer_category'] != null 
          ? HomeOfferCategory.fromJson(json['home_offer_category']) 
          : null,
      flashSale: json['flash_sale'],
      newArrivals: json['new_arrivals'] as List?,
      bestSellers: json['best_sellers'] as List?,
      featuredProducts: json['featured_products'] as List?,
    );
  }
}

class HomeOfferCategory {
  final String? label;
  final List<HomeCategory>? categories;

  HomeOfferCategory({this.label, this.categories});

  factory HomeOfferCategory.fromJson(Map<String, dynamic> json) {
    return HomeOfferCategory(
      label: json['label'],
      categories: (json['categories'] as List?)
          ?.map((i) => HomeCategory.fromJson(i))
          .toList(),
    );
  }
}

class HomeAnnouncement {
  final int? id;
  final String? title;

  HomeAnnouncement({this.id, this.title});

  factory HomeAnnouncement.fromJson(Map<String, dynamic> json) {
    return HomeAnnouncement(
      id: json['id'],
      title: json['title'],
    );
  }
}

class HomeCategory {
  final int? id;
  final String? name;
  final String? slug;
  final String? image;

  HomeCategory({this.id, this.name, this.slug, this.image});

  factory HomeCategory.fromJson(Map<String, dynamic> json) {
    return HomeCategory(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      image: json['image'],
    );
  }
}

class HomeBanner {
  final int? id;
  final String? title;
  final String? image;
  final String? linkType;
  final String? linkId;

  HomeBanner({this.id, this.title, this.image, this.linkType, this.linkId});

  factory HomeBanner.fromJson(Map<String, dynamic> json) {
    return HomeBanner(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      linkType: json['link_type'],
      linkId: json['link_id'],
    );
  }
}
