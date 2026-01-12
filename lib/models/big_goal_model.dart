/// BigGoal represents a large reward that children save up stars to claim
/// Includes progress tracking and image for visual motivation
class BigGoal {
  String name;      // e.g., "PlayStation 5", "New Bike"
  String img;       // REQUIRED - visual motivation for kids
  int price;        // Number of stars needed to claim
  int progress;     // Number of stars earned toward this goal
  bool isClaimed;   // Whether this goal has been claimed

  BigGoal({
    this.name = '',
    this.img = '',
    this.price = 10,
    this.progress = 0,
    this.isClaimed = false,
  });

  factory BigGoal.fromJson(Map<String, dynamic> json) {
    return BigGoal(
      name: json['name'] as String? ?? '',
      img: json['img'] as String? ?? '',
      price: json['price'] as int? ?? 10,
      progress: json['progress'] as int? ?? 0,
      isClaimed: json['isClaimed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'img': img,
      'price': price,
      'progress': progress,
      'isClaimed': isClaimed,
    };
  }

  /// Calculate remaining stars needed
  int get remaining => (price - progress).clamp(0, price);

  /// Check if goal is complete (can be claimed)
  bool get isComplete => progress >= price && !isClaimed;

  /// Calculate fill percentage (0.0 to 1.0)
  double get fillPercentage => price > 0 ? (progress / price).clamp(0.0, 1.0) : 0.0;

  /// Add stars to progress (called when child earns a star)
  void addProgress(int stars) {
    progress = (progress + stars).clamp(0, price);
  }

  @override
  String toString() => 'BigGoal{name: $name, price: $price, progress: $progress, isClaimed: $isClaimed}';
}
