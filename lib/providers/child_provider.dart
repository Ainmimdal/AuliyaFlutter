import 'package:flutter/material.dart';
import '../models/child_model.dart';
import '../models/harian_model.dart';
import '../models/bonus_model.dart';
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
    // Update selected child if it exists in the new list
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

  /// Increase the level (good behavior). Returns true if earned a star.
  Future<bool> increaseScore(ChildModel child) async {
    bool earnedStar = child.increaseScore();
    await _db.updateChildScore(child);
    notifyListeners();
    return earnedStar;
  }

  /// Decrease the level (bad behavior)
  Future<void> decreaseScore(ChildModel child) async {
    child.decreaseScore();
    await _db.updateChildScore(child);
    notifyListeners();
  }

  /// Claim a harian reward (costs hariankey)
  Future<bool> claimHarian(ChildModel child, HarianModel harian) async {
    if (child.hariankey >= harian.price) {
      child.hariankey -= harian.price;
      await _db.updateChildScore(child);
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Claim a bonus reward (costs stars)
  Future<bool> claimBonus(ChildModel child, BonusModel bonus) async {
    if (child.claimBonus(bonus.price)) {
      await _db.updateChildScore(child);
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Add a harian item to a child
  Future<void> addHarian(ChildModel child, HarianModel harian) async {
    child.harian.add(harian);
    await _db.updateChildHarian(child);
    notifyListeners();
  }

  /// Remove a harian item from a child
  Future<void> removeHarian(ChildModel child, int index) async {
    if (index >= 0 && index < child.harian.length) {
      child.harian.removeAt(index);
      await _db.updateChildHarian(child);
      notifyListeners();
    }
  }

  /// Add a bonus item to a child
  Future<void> addBonus(ChildModel child, BonusModel bonus) async {
    child.bonus.add(bonus);
    await _db.updateChildBonus(child);
    notifyListeners();
  }

  /// Remove a bonus item from a child
  Future<void> removeBonus(ChildModel child, int index) async {
    if (index >= 0 && index < child.bonus.length) {
      child.bonus.removeAt(index);
      await _db.updateChildBonus(child);
      notifyListeners();
    }
  }
}
