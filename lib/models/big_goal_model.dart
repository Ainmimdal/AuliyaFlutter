/// BigGoal represents a large reward that children save up stars to claim
/// Uses child.star for progress (like a bank balance)
class BigGoal {
  String name;      // e.g., "PlayStation 5", "New Bike"
  String img;       // Visual motivation for kids
  int price;        // Number of stars needed to claim
  bool isClaimed;   // Whether this goal has been claimed

  BigGoal({
    this.name = '',
    this.img = '',
    this.price = 10,
    this.isClaimed = false,
  });

  factory BigGoal.fromJson(Map<String, dynamic> json) {
    return BigGoal(
      name: json['name'] as String? ?? '',
      img: json['img'] as String? ?? '',
      price: json['price'] as int? ?? 10,
      isClaimed: json['isClaimed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'img': img,
      'price': price,
      'isClaimed': isClaimed,
    };
  }

  @override
  String toString() => 'BigGoal{name: $name, price: $price, isClaimed: $isClaimed}';
}
