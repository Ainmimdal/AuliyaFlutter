class DailyTask {
  String name;
  int price;
  String img;
  int menuVisible;

  DailyTask({
    this.name = "",
    this.price = 1,
    this.img = "",
    this.menuVisible = 0,
  });

  factory DailyTask.fromJson(Map<String, dynamic> json) {
    return DailyTask(
      name: json['name'] as String? ?? "",
      price: json['price'] as int? ?? 1,
      img: json['img'] as String? ?? "",
      menuVisible: json['menuVisible'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'img': img,
      'menuVisible': menuVisible,
    };
  }
}
