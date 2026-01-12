import 'harian_model.dart';
import 'bonus_model.dart';

/// ChildModel represents a child's data matching Android's Childdata structure
class ChildModel {
  String? id; // Firestore document ID
  String? userId;
  String name;
  String age;
  String img;
  int level;
  int hariankey;
  int star;
  List<int> checkmarks;
  List<HarianModel> harian;
  List<BonusModel> bonus;

  ChildModel({
    this.id,
    this.userId,
    this.name = "",
    this.age = "",
    this.img = "",
    this.level = 0,
    this.hariankey = 0,
    this.star = 0,
    List<int>? checkmarks,
    List<HarianModel>? harian,
    List<BonusModel>? bonus,
  })  : checkmarks = checkmarks ?? [],
        harian = harian ?? [],
        bonus = bonus ?? [];

  factory ChildModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return ChildModel(
      id: id,
      userId: json['userId'] as String?,
      name: json['name'] as String? ?? "",
      age: json['age'] as String? ?? "",
      img: json['img'] as String? ?? "",
      level: json['level'] as int? ?? 0,
      hariankey: json['hariankey'] as int? ?? 0,
      star: json['star'] as int? ?? 0,
      checkmarks: (json['checkmarks'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
      harian: (json['harian'] as List<dynamic>?)
              ?.map((e) => HarianModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      bonus: (json['bonus'] as List<dynamic>?)
              ?.map((e) => BonusModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'age': age,
      'img': img,
      'level': level,
      'hariankey': hariankey,
      'star': star,
      'checkmarks': checkmarks,
      'harian': harian.map((e) => e.toJson()).toList(),
      'bonus': bonus.map((e) => e.toJson()).toList(),
    };
  }

  /// Increase level by 1. If level reaches 9, reset to 0 and add a star.
  /// Returns true if a star was earned.
  bool increaseScore() {
    if (level < 9) {
      level++;
      return false;
    } else {
      // Level 9 reached, earn a star!
      level = 0;
      star++;
      hariankey++;
      return true;
    }
  }

  /// Decrease level by 1, minimum 0
  void decreaseScore() {
    if (level > 0) {
      level--;
    }
  }

  /// Reset level to 0 (called after earning a star)
  void resetScore() {
    level = 0;
  }

  /// Increase hariankey for claiming harian rewards
  void increaseHariankey() {
    hariankey++;
  }

  /// Decrease hariankey when claiming harian reward
  bool decreaseHariankey() {
    if (hariankey > 0) {
      hariankey--;
      return true;
    }
    return false;
  }

  /// Claim a bonus by deducting its price from stars
  /// Returns true if successful
  bool claimBonus(int bonusPrice) {
    if (star >= bonusPrice) {
      star -= bonusPrice;
      return true;
    }
    return false;
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
      hariankey: hariankey,
      star: star,
      checkmarks: List.from(checkmarks),
      harian: harian.map((h) => HarianModel(name: h.name, price: h.price, img: h.img)).toList(),
      bonus: bonus.map((b) => BonusModel(name: b.name, img: b.img, price: b.price)).toList(),
    );
  }

  @override
  String toString() {
    return 'ChildModel{id: $id, name: $name, age: $age, level: $level, star: $star, hariankey: $hariankey}';
  }
}
