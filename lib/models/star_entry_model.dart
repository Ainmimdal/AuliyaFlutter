/// Tracks when a star was earned for history/charts
class StarEntry {
  final DateTime date;
  final int count;
  
  StarEntry({required this.date, this.count = 1});
  
  factory StarEntry.fromJson(Map<String, dynamic> json) {
    return StarEntry(
      date: DateTime.parse(json['date'] as String),
      count: json['count'] as int? ?? 1,
    );
  }
  
  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'count': count,
  };
}
