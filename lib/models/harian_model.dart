/// HarianModel represents a daily reward/task that can be claimed
/// Matches Android's HarianParcel structure
class HarianModel {
  String name;
  int price;
  String img;

  HarianModel({
    this.name = '',
    this.price = 1,
    this.img = '',
  });

  factory HarianModel.fromJson(Map<String, dynamic> json) {
    return HarianModel(
      name: json['harianname'] as String? ?? '',
      price: json['harianprice'] as int? ?? 1,
      img: json['harianimg'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'harianname': name,
      'harianprice': price,
      'harianimg': img,
    };
  }

  @override
  String toString() {
    return 'HarianModel{name: $name, price: $price, img: $img}';
  }
}
