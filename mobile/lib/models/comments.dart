class Comments {
  final String name;
  final String country;
  final double rating;
  final String? comment;
  final DateTime createdAt;

  Comments({
    required this.name,
    required this.country,
    required this.rating,
    required this.createdAt,
    this.comment,
  });

  String get initials => name.split(' ').map((e) => e[0].toUpperCase()).join();
}
