class UserProfile {
  final int? id;
  final String? name;
  final String? email;
  final int? subscribeToEmails;
  final String? createdAt;
  final String? updatedAt;
  final int? points;
  final int? couponsCount;
  final double? balance;
  final int? countryId;
  final int? currencyId;
  final String? gender;
  final String? birthday;
  final List<int>? favoriteCategoryIds;
  final List<int>? favoriteStyleIds;

  UserProfile({
    this.id,
    this.name,
    this.email,
    this.subscribeToEmails,
    this.createdAt,
    this.updatedAt,
    this.points,
    this.couponsCount,
    this.balance,
    this.countryId,
    this.currencyId,
    this.gender,
    this.birthday,
    this.favoriteCategoryIds,
    this.favoriteStyleIds,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      subscribeToEmails: json['subscribe_to_emails'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      points: json['points'],
      couponsCount: json['coupons_count'],
      balance: parseDouble(json['balance']),
      countryId: json['country_id'],
      currencyId: json['currency_id'],
      gender: json['gender'],
      birthday: json['birthday'],
      favoriteCategoryIds: json['category_ids'] != null ? List<int>.from(json['category_ids']) : null,
      favoriteStyleIds: json['style_ids'] != null ? List<int>.from(json['style_ids']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'subscribe_to_emails': subscribeToEmails,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'points': points,
      'coupons_count': couponsCount,
      'balance': balance,
      'country_id': countryId,
      'currency_id': currencyId,
      'gender': gender,
      'birthday': birthday,
      'category_ids': favoriteCategoryIds,
      'style_ids': favoriteStyleIds,
    };
  }
}

class ProfileResponse {
  final String? success;
  final int? status;
  final String? message;
  final UserProfile? data;

  ProfileResponse({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? UserProfile.fromJson(json['data']) : null,
    );
  }
}
