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
  final dynamic flashSale;
  final List<dynamic>? newArrivals;
  final List<dynamic>? bestSellers;
  final List<dynamic>? featuredProducts;

  HomeData({
    this.banners,
    this.categories,
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
      flashSale: json['flash_sale'],
      newArrivals: json['new_arrivals'] as List?,
      bestSellers: json['best_sellers'] as List?,
      featuredProducts: json['featured_products'] as List?,
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
