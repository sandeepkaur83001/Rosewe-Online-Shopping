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
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      subscribeToEmails: json['subscribe_to_emails'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      points: json['points'],
      couponsCount: json['coupons_count'],
      balance: (json['balance'] as num?)?.toDouble(),
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
