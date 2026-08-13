class DeleteReasonResponse {
  final String? success;
  final int? status;
  final String? message;
  final List<DeleteReasonData>? data;

  DeleteReasonResponse({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory DeleteReasonResponse.fromJson(Map<String, dynamic> json) {
    return DeleteReasonResponse(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => DeleteReasonData.fromJson(i)).toList()
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

class DeleteReasonData {
  final int? id;
  final String? reason;
  final String? type;
  final String? createdAt;
  final String? updatedAt;

  DeleteReasonData({
    this.id,
    this.reason,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory DeleteReasonData.fromJson(Map<String, dynamic> json) {
    return DeleteReasonData(
      id: json['id'],
      reason: json['reason'],
      type: json['type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reason': reason,
      'type': type,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
