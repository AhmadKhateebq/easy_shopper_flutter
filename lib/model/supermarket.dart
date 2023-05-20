class Supermarket {
  final int id;
  final String name;
  final String locationX;
  final String locationY;

  Supermarket({
    required this.id,
    required this.name,
    required this.locationX,
    required this.locationY,
  });

  factory Supermarket.fromJson(Map<String, dynamic> json) {
    return Supermarket(
      id: json['id'],
      name: json['name'],
      locationX: json['locationX'],
      locationY: json['locationY'],
    );
  }
}
