class ProfileCategoryResponse {
  final String? success;
  final int? status;
  final String? message;
  final List<ProfileCategoryData>? data;

  ProfileCategoryResponse({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory ProfileCategoryResponse.fromJson(Map<String, dynamic> json) {
    return ProfileCategoryResponse(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => ProfileCategoryData.fromJson(i)).toList()
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

class ProfileCategoryData {
  final int? id;
  final String? name;

  ProfileCategoryData({
    this.id,
    this.name,
  });

  factory ProfileCategoryData.fromJson(Map<String, dynamic> json) {
    return ProfileCategoryData(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
