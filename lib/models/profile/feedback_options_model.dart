class FeedbackOptionsResponse {
  final String? success;
  final int? status;
  final String? message;
  final List<FeedbackSuggestion>? data;

  FeedbackOptionsResponse({this.success, this.status, this.message, this.data});

  factory FeedbackOptionsResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackOptionsResponse(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => FeedbackSuggestion.fromJson(i)).toList()
          : null,
    );
  }
}

class FeedbackSuggestion {
  final int? id;
  final String? name;
  final List<FeedbackProblem>? problems;

  FeedbackSuggestion({this.id, this.name, this.problems});

  factory FeedbackSuggestion.fromJson(Map<String, dynamic> json) {
    return FeedbackSuggestion(
      id: json['id'],
      name: json['name'],
      problems: json['problems'] != null
          ? (json['problems'] as List).map((i) => FeedbackProblem.fromJson(i)).toList()
          : [],
    );
  }
}

class FeedbackProblem {
  final int? id;
  final int? feedbackSuggestionId;
  final String? name;
  final bool? isOther;

  FeedbackProblem({this.id, this.feedbackSuggestionId, this.name, this.isOther});

  factory FeedbackProblem.fromJson(Map<String, dynamic> json) {
    return FeedbackProblem(
      id: json['id'],
      feedbackSuggestionId: json['feedback_suggestion_id'],
      name: json['name'],
      isOther: json['is_other'],
    );
  }
}
