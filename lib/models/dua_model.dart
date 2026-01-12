class Dua {
  int id;
  String title;
  String doa;
  String rumi;
  String maksud;

  Dua({
    required this.id,
    required this.title,
    required this.doa,
    required this.rumi,
    required this.maksud,
  });

  factory Dua.fromJson(Map<String, dynamic> json) {
    return Dua(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? "",
      doa: json['doa'] as String? ?? "",
      rumi: json['rumi'] as String? ?? "",
      maksud: json['maksud'] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'doa': doa,
      'rumi': rumi,
      'maksud': maksud,
    };
  }
}
