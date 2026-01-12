import 'package:flutter/material.dart';
import '../models/child_model.dart';
import '../models/daily_treat_model.dart';
import '../models/big_goal_model.dart';
import '../services/database_service.dart';

class ChildProvider extends ChangeNotifier {
  List<ChildModel> _children = [];
  ChildModel? _selectedChild;
  final DatabaseService _db;

  ChildProvider(this._db);

  List<ChildModel> get children => _children;
  ChildModel? get selectedChild => _selectedChild;

  void setChildren(List<ChildModel> children) {
    _children = children;
    if (_selectedChild != null) {
      final updated = children.where((c) => c.id == _selectedChild!.id).firstOrNull;
      if (updated != null) {
        _selectedChild = updated;
      }
    }
    notifyListeners();
  }

  void selectChild(ChildModel child) {
    _selectedChild = child;
    notifyListeners();
  }

  Future<String> addChild(ChildModel child) async {
    String id = await _db.addChild(child);
    child.id = id;
    return id;
  }

  Future<void> updateChild(ChildModel child) async {
    await _db.updateChild(child);
    notifyListeners();
  }

  Future<void> deleteChild(ChildModel child) async {
    if (child.id != null) {
      await _db.deleteChild(child.id!);
      _children.removeWhere((c) => c.id == child.id);
      if (_selectedChild?.id == child.id) {
        _selectedChild = null;
      }
      notifyListeners();
    }
  }

  /// Increase level (good behavior). Returns true if earned a star.
  /// Also adds progress to the selected big goal.
  Future<bool> increaseScore(ChildModel child) async {
    bool earnedStar = child.increaseScore();
    await _db.updateChild(child);
    notifyListeners();
    return earnedStar;
  }

  /// Decrease level (bad behavior)
  Future<void> decreaseScore(ChildModel child) async {
    child.decreaseScore();
    await _db.updateChild(child);
    notifyListeners();
  }

  /// Add a daily treat to child
  Future<void> addDailyTreat(ChildModel child, DailyTreat treat) async {
    child.dailyTreats.add(treat);
    await _db.updateChild(child);
    notifyListeners();
  }

  /// Remove a daily treat
  Future<void> removeDailyTreat(ChildModel child, int index) async {
    if (index >= 0 && index < child.dailyTreats.length) {
      child.dailyTreats.removeAt(index);
      await _db.updateChild(child);
      notifyListeners();
    }
  }

  /// Add a big goal to child
  Future<void> addBigGoal(ChildModel child, BigGoal goal) async {
    child.bigGoals.add(goal);
    // Auto-select if first goal
    if (child.bigGoals.length == 1) {
      child.selectedGoalIndex = 0;
    }
    await _db.updateChild(child);
    notifyListeners();
  }

  /// Remove a big goal
  Future<void> removeBigGoal(ChildModel child, int index) async {
    if (index >= 0 && index < child.bigGoals.length) {
      child.bigGoals.removeAt(index);
      // Update selected goal index if needed
      if (child.selectedGoalIndex == index) {
        child.selectedGoalIndex = child.bigGoals.isEmpty ? null : 0;
      } else if (child.selectedGoalIndex != null && child.selectedGoalIndex! > index) {
        child.selectedGoalIndex = child.selectedGoalIndex! - 1;
      }
      await _db.updateChild(child);
      notifyListeners();
    }
  }

  /// Select a big goal to work toward
  Future<void> selectBigGoal(ChildModel child, int index) async {
    if (index >= 0 && index < child.bigGoals.length) {
      child.selectedGoalIndex = index;
      await _db.updateChild(child);
      notifyListeners();
    }
  }

  /// Claim a completed big goal
  Future<bool> claimBigGoal(ChildModel child, int index) async {
    if (index >= 0 && index < child.bigGoals.length) {
      final goal = child.bigGoals[index];
      if (goal.isComplete) {
        goal.isClaimed = true;
        await _db.updateChild(child);
        notifyListeners();
        return true;
      }
    }
    return false;
  }
}
