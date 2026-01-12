/// BonusModel represents a bonus reward that can be purchased with stars
/// Matches Android's BonusParcel structure
class BonusModel {
  String name;
  String img;
  int price;

  BonusModel({
    this.name = '',
    this.img = '',
    this.price = 0,
  });

  factory BonusModel.fromJson(Map<String, dynamic> json) {
    return BonusModel(
      name: json['bonusname'] as String? ?? '',
      img: json['bonusimg'] as String? ?? '',
      price: json['bonusprice'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bonusname': name,
      'bonusimg': img,
      'bonusprice': price,
    };
  }

  @override
  String toString() {
    return 'BonusModel{name: $name, img: $img, price: $price}';
  }
}
