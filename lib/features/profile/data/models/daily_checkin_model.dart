class DailyCheckInResponse {
  String? success;
  int? status;
  String? message;
  DailyCheckInData? data;

  DailyCheckInResponse({this.success, this.status, this.message, this.data});

  DailyCheckInResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DailyCheckInData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DailyCheckInData {
  int? totalPoints;
  bool? checkedInToday;
  int? currentDay;
  int? nextDay;
  int? nextReward;
  Map<String, int>? rewards;
  
  // POST response specific fields
  int? day;
  int? pointsEarned;
  bool? cycleCompleted;

  DailyCheckInData({
    this.totalPoints,
    this.checkedInToday,
    this.currentDay,
    this.nextDay,
    this.nextReward,
    this.rewards,
    this.day,
    this.pointsEarned,
    this.cycleCompleted,
  });

  DailyCheckInData.fromJson(Map<String, dynamic> json) {
    totalPoints = json['total_points'];
    checkedInToday = json['checked_in_today'];
    currentDay = json['current_day'] ?? json['day'];
    nextDay = json['next_day'];
    nextReward = json['next_reward'];
    day = json['day'];
    pointsEarned = json['points_earned'];
    cycleCompleted = json['cycle_completed'];
    if (json['rewards'] != null) {
      rewards = Map<String, int>.from(json['rewards']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_points'] = totalPoints;
    data['checked_in_today'] = checkedInToday;
    data['current_day'] = currentDay;
    data['next_day'] = nextDay;
    data['next_reward'] = nextReward;
    data['day'] = day;
    data['points_earned'] = pointsEarned;
    data['cycle_completed'] = cycleCompleted;
    if (rewards != null) {
      data['rewards'] = rewards;
    }
    return data;
  }
}
