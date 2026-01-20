
import 'package:flutter_test/flutter_test.dart';


import 'package:auliya/models/child_model.dart';
import 'package:auliya/models/harian_model.dart';
import 'package:auliya/models/bonus_model.dart';
void main() {
  group('ChildModel Tests', () {
    test('ChildModel serialization (toJson/fromJson)', () {
      final child = ChildModel(
        userId: 'user123',
        name: 'Ali',
        age: '7',
        img: 'img.png',
        level: 5,
        hariankey: 2,
        star: 3,
        checkmarks: [111, 222],
        harian: [
          HarianModel(name: 'Task 1', price: 10, img: 'h1.png'),
        ],
        bonus: [
          BonusModel(name: 'Bonus 1', price: 50, img: 'b1.png'),
        ],
      );

      final json = child.toJson();

      // Basic fields
      expect(json['userId'], 'user123');
      expect(json['name'], 'Ali');
      expect(json['age'], '7');
      expect(json['img'], 'img.png');
      expect(json['level'], 5);
      expect(json['hariankey'], 2);
      expect(json['star'], 3);

      // Lists
      expect((json['checkmarks'] as List).length, 2);
      expect((json['harian'] as List).length, 1);
      expect((json['bonus'] as List).length, 1);

      // Convert back
      final fromJson = ChildModel.fromJson(json, id: 'childDocId');

      expect(fromJson.id, 'childDocId');
      expect(fromJson.userId, 'user123');
      expect(fromJson.name, 'Ali');
      expect(fromJson.age, '7');
      expect(fromJson.img, 'img.png');
      expect(fromJson.level, 5);
      expect(fromJson.hariankey, 2);
      expect(fromJson.star, 3);

      expect(fromJson.checkmarks.length, 2);
      expect(fromJson.harian.length, 1);
      expect(fromJson.bonus.length, 1);

      // Check one nested item (safe minimal check)
      expect(fromJson.harian.first.name, 'Task 1');
      expect(fromJson.harian.first.price, 10);
      expect(fromJson.bonus.first.name, 'Bonus 1');
      expect(fromJson.bonus.first.price, 50);
    });

    test('increaseScore increments level until 9 (no star earned)', () {
      final child = ChildModel(level: 8, star: 0, hariankey: 0);

      final earned = child.increaseScore(); // 8 -> 9
      expect(child.level, 9);
      expect(child.star, 0);
      expect(child.hariankey, 0);
      expect(earned, false);
    });

    test('increaseScore when level is 9 resets level and adds star & hariankey', () {
      final child = ChildModel(level: 9, star: 0, hariankey: 0);

      final earned = child.increaseScore(); // 9 -> reset + star + hariankey
      expect(child.level, 0);
      expect(child.star, 1);
      expect(child.hariankey, 1);
      expect(earned, true);
    });

    test('decreaseScore does not go below 0', () {
      final child = ChildModel(level: 0);

      child.decreaseScore();
      expect(child.level, 0);
    });

    test('claimBonus deducts stars when enough', () {
      final child = ChildModel(star: 10);

      final ok = child.claimBonus(5);
      expect(ok, true);
      expect(child.star, 5);
    });

    test('claimBonus fails when not enough stars', () {
      final child = ChildModel(star: 3);

      final ok = child.claimBonus(5);
      expect(ok, false);
      expect(child.star, 3);
    });

    test('decreaseHariankey works correctly', () {
      final child = ChildModel(hariankey: 1);

      final ok = child.decreaseHariankey();
      expect(ok, true);
      expect(child.hariankey, 0);

      final ok2 = child.decreaseHariankey();
      expect(ok2, false);
      expect(child.hariankey, 0);
    });
  });
}
