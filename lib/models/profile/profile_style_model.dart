class ProfileStyleResponse {
  final String? success;
  final int? status;
  final String? message;
  final List<ProfileStyleData>? data;

  ProfileStyleResponse({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory ProfileStyleResponse.fromJson(Map<String, dynamic> json) {
    return ProfileStyleResponse(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => ProfileStyleData.fromJson(i)).toList()
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

class ProfileStyleData {
  final int? id;
  final String? name;

  ProfileStyleData({
    this.id,
    this.name,
  });

  factory ProfileStyleData.fromJson(Map<String, dynamic> json) {
    return ProfileStyleData(
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
