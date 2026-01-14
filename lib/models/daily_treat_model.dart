/// DailyTreat represents a small reward claimable after completing the star chart
class DailyTreat {
  String name;    // e.g., "2 hours gaming", "Extra dessert"
  String img;     // Optional image URL

  DailyTreat({
    this.name = '',
    this.img = '',
  });

  factory DailyTreat.fromJson(Map<String, dynamic> json) {
    return DailyTreat(
      name: json['name'] as String? ?? '',
      img: json['img'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'img': img,
    };
  }

  @override
  String toString() => 'DailyTreat{name: $name, img: $img}';
}
