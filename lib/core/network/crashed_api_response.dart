class CrashedApiResponse {
  String? message;
  bool? success;
  int? statusCode;

  CrashedApiResponse({this.message = "Server is not responding!", this.success = false, this.statusCode = 500});

  CrashedApiResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['success'] = success;
    data['statusCode'] = statusCode;
    return data;
  }
}
