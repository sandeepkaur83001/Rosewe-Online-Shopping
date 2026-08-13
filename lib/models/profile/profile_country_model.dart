class ProfileCountryResponse {
  final String? success;
  final int? status;
  final String? message;
  final List<ProfileCountryData>? data;

  ProfileCountryResponse({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory ProfileCountryResponse.fromJson(Map<String, dynamic> json) {
    return ProfileCountryResponse(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => ProfileCountryData.fromJson(i)).toList()
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

class ProfileCountryData {
  final int? id;
  final String? name;
  final String? code;
  final String? unicode;
  final String? image;

  ProfileCountryData({
    this.id,
    this.name,
    this.code,
    this.unicode,
    this.image,
  });

  factory ProfileCountryData.fromJson(Map<String, dynamic> json) {
    return ProfileCountryData(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      unicode: json['unicode'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'unicode': unicode,
      'image': image,
    };
  }
}
