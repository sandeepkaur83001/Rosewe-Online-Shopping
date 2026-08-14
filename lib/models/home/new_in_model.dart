class NewInResponse {
  final String? success;
  final int? status;
  final String? message;
  final NewInData? data;

  NewInResponse({this.success, this.status, this.message, this.data});

  factory NewInResponse.fromJson(Map<String, dynamic> json) {
    return NewInResponse(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? NewInData.fromJson(json['data']) : null,
    );
  }
}

class NewInData {
  final List<String>? dates;
  final ProductPagination? products;

  NewInData({this.dates, this.products});

  factory NewInData.fromJson(Map<String, dynamic> json) {
    return NewInData(
      dates: json['dates'] != null ? List<String>.from(json['dates']) : null,
      products: json['products'] != null ? ProductPagination.fromJson(json['products']) : null,
    );
  }
}

class ProductPagination {
  final List<NewInProduct>? data;
  final dynamic meta;

  ProductPagination({this.data, this.meta});

  factory ProductPagination.fromJson(Map<String, dynamic> json) {
    return ProductPagination(
      data: json['data'] != null 
          ? (json['data'] as List).map((i) => NewInProduct.fromJson(i)).toList() 
          : null,
      meta: json['meta'],
    );
  }
}

class NewInProduct {
  final int? id;
  final String? name;
  final double? price;
  final double? salePrice;
  final String? image;
  final bool? isSale;
  final bool? isNew;
  final bool? isFavorite;

  NewInProduct({
    this.id,
    this.name,
    this.price,
    this.salePrice,
    this.image,
    this.isSale,
    this.isNew,
    this.isFavorite,
  });

  factory NewInProduct.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    bool? parseBool(dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) return value == '1' || value.toLowerCase() == 'true';
      return null;
    }

    return NewInProduct(
      id: json['id'],
      name: json['name'],
      price: parseDouble(json['price']),
      salePrice: parseDouble(json['sale_price']),
      image: json['image'],
      isSale: parseBool(json['is_sale']),
      isNew: parseBool(json['is_new']),
      isFavorite: parseBool(json['is_favorite']) ?? parseBool(json['is_wishlist']) ?? false,
    );
  }
}
