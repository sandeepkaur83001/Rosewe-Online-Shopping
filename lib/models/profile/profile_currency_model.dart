class ProfileCurrencyResponse {
  final String? success;
  final int? status;
  final String? message;
  final List<ProfileCurrencyData>? data;

  ProfileCurrencyResponse({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory ProfileCurrencyResponse.fromJson(Map<String, dynamic> json) {
    return ProfileCurrencyResponse(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => ProfileCurrencyData.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status': status,
      'message': message,
      'data': data?.map((i) => i.toJson()).toList(),
    };
  }
}

class ProfileCurrencyData {
  final int? id;
  final String? code;
  final String? symbol;

  ProfileCurrencyData({
    this.id,
    this.code,
    this.symbol,
  });

  factory ProfileCurrencyData.fromJson(Map<String, dynamic> json) {
    return ProfileCurrencyData(
      id: json['id'],
      code: json['code'],
      symbol: json['symbol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'symbol': symbol,
    };
  }
}
