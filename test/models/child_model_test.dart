import 'package:flutter_test/flutter_test.dart';
import 'package:auliya/models/child_model.dart';
import 'package:auliya/models/daily_task_model.dart';

void main() {
  group('ChildModel Tests', () {
    test('ChildModel serialization', () {
      final child = ChildModel(
        userId: 'user123',
        name: 'Ali',
        age: '7',
        level: 5,
        dailyTasks: [
          DailyTask(name: 'Task 1', price: 10),
        ],
      );

      final json = child.toJson();
      expect(json['name'], 'Ali');
      expect(json['level'], 5);
      expect((json['dailyTasks'] as List).length, 1);

      final fromJson = ChildModel.fromJson(json);
      expect(fromJson.name, 'Ali');
      expect(fromJson.dailyTasks.first.name, 'Task 1');
    });

    test('Add Star increases star count', () {
      // Logic inside provider, but we can test basic model state if we move logic there
      // Currently logic is in Provider.
      // We can verify model defaults.
      final child = ChildModel();
      expect(child.star, 0);
      child.star += 5;
      expect(child.star, 5);
    });
  });
}
