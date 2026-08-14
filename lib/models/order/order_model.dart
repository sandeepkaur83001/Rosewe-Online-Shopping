import 'package:rosewe_online_shopping/models/home/new_in_model.dart';

class OrderResponse {
  final String? success;
  final int? status;
  final String? message;
  final OrderPagination? data;

  OrderResponse({this.success, this.status, this.message, this.data});

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? OrderPagination.fromJson(json['data']) : null,
    );
  }
}

class OrderPagination {
  final int? currentPage;
  final List<OrderData>? data;
  final int? lastPage;
  final int? total;

  OrderPagination({this.currentPage, this.data, this.lastPage, this.total});

  factory OrderPagination.fromJson(Map<String, dynamic> json) {
    return OrderPagination(
      currentPage: json['current_page'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => OrderData.fromJson(i)).toList()
          : [],
      lastPage: json['last_page'],
      total: json['total'],
    );
  }
}

class OrderData {
  final int? id;
  final int? userId;
  final int? userAddressId;
  final double? total;
  final String? status;
  final String? paymentStatus;
  final String? createdAt;
  final List<OrderItemData>? items;

  OrderData({
    this.id,
    this.userId,
    this.userAddressId,
    this.total,
    this.status,
    this.paymentStatus,
    this.createdAt,
    this.items,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return OrderData(
      id: json['id'],
      userId: json['user_id'],
      userAddressId: json['user_address_id'],
      total: parseDouble(json['total']),
      status: json['status'],
      paymentStatus: json['payment_status'],
      createdAt: json['created_at'],
      items: json['items'] != null
          ? (json['items'] as List).map((i) => OrderItemData.fromJson(i)).toList()
          : [],
    );
  }
}

class OrderItemData {
  final int? id;
  final int? orderId;
  final int? productId;
  final int? quantity;
  final double? price;
  final NewInProduct? product;

  OrderItemData({
    this.id,
    this.orderId,
    this.productId,
    this.quantity,
    this.price,
    this.product,
  });

  factory OrderItemData.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return OrderItemData(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      price: parseDouble(json['price']),
      product: json['product'] != null ? NewInProduct.fromJson(json['product']) : null,
    );
  }
}
