import 'package:rosewe_online_shopping/models/home/new_in_model.dart';

class CartResponse {
  final String? success;
  final int? status;
  final String? message;
  final CartData? data;

  CartResponse({this.success, this.status, this.message, this.data});

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? CartData.fromJson(json['data']) : null,
    );
  }
}

class CartData {
  final int? id;
  final int? userId;
  final double? total;
  final List<CartItem>? items;

  CartData({this.id, this.userId, this.total, this.items});

  factory CartData.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return CartData(
      id: json['id'],
      userId: json['user_id'],
      total: parseDouble(json['total']),
      items: json['items'] != null
          ? (json['items'] as List).map((i) => CartItem.fromJson(i)).toList()
          : [],
    );
  }
}

class CartItem {
  final int? id;
  final int? cartId;
  final int? productId;
  final int? quantity;
  final double? price;
  final NewInProduct? product;

  CartItem({
    this.id,
    this.cartId,
    this.productId,
    this.quantity,
    this.price,
    this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return CartItem(
      id: json['id'],
      cartId: json['cart_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      price: parseDouble(json['price']),
      product: json['product'] != null ? NewInProduct.fromJson(json['product']) : null,
    );
  }
}
