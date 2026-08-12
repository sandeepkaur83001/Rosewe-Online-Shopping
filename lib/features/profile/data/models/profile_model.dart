import 'package:rosewe_online_shopping/models/base_model.dart';

class UserProfile extends BaseModel {
  final String? id;
  final String? name;
  final String? email;
  final String? avatarUrl;
  final int? points;
  final int? couponsCount;
  final double? balance;

  UserProfile({
    this.id,
    this.name,
    this.email,
    this.avatarUrl,
    this.points,
    this.couponsCount,
    this.balance,
    super.success,
    super.message,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString(),
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      points: json['points'],
      couponsCount: json['coupons_count'],
      balance: (json['balance'] as num?)?.toDouble(),
      success: json['success'],
      message: json['message'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['avatar_url'] = avatarUrl;
    data['points'] = points;
    data['coupons_count'] = couponsCount;
    data['balance'] = balance;
    return data;
  }
}
