class LocationData {
  final int id;
  final String name;
  final int count;

  LocationData({required this.id, required this.name, required this.count});

  factory LocationData.fromJson(json) => LocationData(
        id: json['id'],
        name: json['name'],
        count: json['count'],
      );
}
