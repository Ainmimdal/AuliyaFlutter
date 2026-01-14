import 'daily_treat_model.dart';
import 'big_goal_model.dart';

/// ChildModel represents a child's data for the star chart reward system
class ChildModel {
  String? id;             // Firestore document ID
  String? userId;         // Parent's user ID
  String name;            // Child's name
  String age;             // Date of birth (MM/DD/YYYY format)
  String img;             // Profile image URL
  int level;              // Current rocket level (0-8)
  int star;               // Total stars earned (currency for big goals)
  int treatsAvailable;    // Number of daily treats available to claim (1 per star earned)
  
  List<DailyTreat> dailyTreats;   // Small rewards to claim
  List<BigGoal> bigGoals;         // Large rewards with progress
  int? selectedGoalIndex;         // Index of the active goal being worked toward

  ChildModel({
    this.id,
    this.userId,
    this.name = "",
    this.age = "",
    this.img = "",
    this.level = 0,
    this.star = 0,
    this.treatsAvailable = 0,
    List<DailyTreat>? dailyTreats,
    List<BigGoal>? bigGoals,
    this.selectedGoalIndex,
  })  : dailyTreats = dailyTreats ?? [],
        bigGoals = bigGoals ?? [];

  factory ChildModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return ChildModel(
      id: id,
      userId: json['userId'] as String?,
      name: json['name'] as String? ?? "",
      age: json['age'] as String? ?? "",
      img: json['img'] as String? ?? "",
      level: json['level'] as int? ?? 0,
      star: json['star'] as int? ?? 0,
      treatsAvailable: json['treatsAvailable'] as int? ?? 0,
      dailyTreats: (json['dailyTreats'] as List<dynamic>?)
              ?.map((e) => DailyTreat.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      bigGoals: (json['bigGoals'] as List<dynamic>?)
              ?.map((e) => BigGoal.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      selectedGoalIndex: json['selectedGoalIndex'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'age': age,
      'img': img,
      'level': level,
      'star': star,
      'treatsAvailable': treatsAvailable,
      'dailyTreats': dailyTreats.map((e) => e.toJson()).toList(),
      'bigGoals': bigGoals.map((e) => e.toJson()).toList(),
      'selectedGoalIndex': selectedGoalIndex,
    };
  }

  /// Get the currently selected goal, or null if none selected
  BigGoal? get selectedGoal {
    if (selectedGoalIndex != null && 
        selectedGoalIndex! >= 0 && 
        selectedGoalIndex! < bigGoals.length) {
      return bigGoals[selectedGoalIndex!];
    }
    return null;
  }

  /// Increase level by 1. If level reaches 9, reset to 0 and:
  /// - Add 1 star to total (bank balance)
  /// - Add 1 treat available
  /// Returns true if a star was earned.
  bool increaseScore() {
    level++;
    if (level >= 9) {
      level = 0;
      star++;  // Add to bank balance
      treatsAvailable++; // Earn 1 treat claim
      return true;
    }
    return false;
  }

  /// Decrease level by 1, minimum 0
  void decreaseScore() {
    if (level > 0) {
      level--;
    }
  }

  /// Claim a daily treat (costs 1 treatsAvailable)
  bool claimDailyTreat() {
    if (treatsAvailable > 0) {
      treatsAvailable--;
      return true;
    }
    return false;
  }

  /// Check if can afford a goal (have enough stars)
  bool canAffordGoal(BigGoal goal) {
    return star >= goal.price && !goal.isClaimed;
  }

  /// Claim a big goal reward (deducts stars from balance)
  bool claimBigGoal(int index) {
    if (index >= 0 && index < bigGoals.length) {
      final goal = bigGoals[index];
      if (canAffordGoal(goal)) {
        star -= goal.price;  // Deduct from bank balance
        goal.isClaimed = true;
        return true;
      }
    }
    return false;
  }

  /// Select a goal to work toward
  void selectGoal(int index) {
    if (index >= 0 && index < bigGoals.length) {
      selectedGoalIndex = index;
    }
  }

  /// Copy this child model
  ChildModel copy() {
    return ChildModel(
      id: id,
      userId: userId,
      name: name,
      age: age,
      img: img,
      level: level,
      star: star,
      treatsAvailable: treatsAvailable,
      dailyTreats: dailyTreats.map((t) => DailyTreat(name: t.name, img: t.img)).toList(),
      bigGoals: bigGoals.map((g) => BigGoal(
        name: g.name, 
        img: g.img, 
        price: g.price, 
        isClaimed: g.isClaimed
      )).toList(),
      selectedGoalIndex: selectedGoalIndex,
    );
  }

  @override
  String toString() {
    return 'ChildModel{id: $id, name: $name, level: $level, star: $star, treatsAvailable: $treatsAvailable}';
  }
}
