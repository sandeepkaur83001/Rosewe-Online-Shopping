class StateResponse {
  final String? success;
  final int? status;
  final String? message;
  final List<StateData>? data;

  StateResponse({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory StateResponse.fromJson(Map<String, dynamic> json) {
    return StateResponse(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => StateData.fromJson(i)).toList()
          : null,
    );
  }
}

class StateData {
  final int? id;
  final String? name;
  final int? countryId;

  StateData({
    this.id,
    this.name,
    this.countryId,
  });

  factory StateData.fromJson(Map<String, dynamic> json) {
    return StateData(
      id: json['id'],
      name: json['name'],
      countryId: json['country_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country_id': countryId,
    };
  }
}
