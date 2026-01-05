class BoredActivity {
  final String activity;
  final String type;
  final int participants;

  BoredActivity({
    required this.activity,
    required this.type,
    required this.participants,
  });

  factory BoredActivity.fromJson(Map<String, dynamic> json) {
    return BoredActivity(
      activity: json['activity'],
      type: json['type'],
      participants: json['participants'],
    );
  }
}
