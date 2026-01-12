import 'package:flutter/material.dart';
import '../models/reward_model.dart';

class RewardProvider extends ChangeNotifier {
  List<Reward> _rewards = [];
  
  List<Reward> get rewards => _rewards;

  void loadRewards() {
    // Initial dummy data or load from config/DB if rewards are dynamic
    _rewards = [
      Reward(name: "Ice Cream", price: 5, img: "assets/images/ice_cream.png"),
      Reward(name: "Toy", price: 10, img: "assets/images/toy.png"),
    ];
    notifyListeners();
  }

  void addReward(Reward reward) {
    _rewards.add(reward);
    notifyListeners();
  }
}
