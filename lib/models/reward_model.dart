class Reward {
  String name;
  String img;
  int price;

  Reward({
    this.name = "",
    this.img = "",
    this.price = 0,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      name: json['name'] as String? ?? "",
      img: json['img'] as String? ?? "",
      price: json['price'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'img': img,
      'price': price,
    };
  }
}
