class Property {
  int? id;
  String? title;
  String? type;
  String? imagePath;
  String? location;
  int? guests;
  int? bedrooms;
  int? beds;
  double? bathrooms;
  bool? petsAllowed;
  List<String>? amenities;
  String? description;
  int? pricePerNight;
  double? rating;
  int? reviews;

  Property({
    this.id,
    this.title,
    this.type,
    this.location,
    this.guests,
    this.bedrooms,
    this.beds,
    this.bathrooms,
    this.petsAllowed,
    this.amenities,
    this.description,
    this.pricePerNight,
    this.imagePath,
    this.rating,
    this.reviews,
  });

  Property.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    location = json['location'];
    guests = json['guests'];
    bedrooms = json['bedrooms'];
    beds = json['beds'];
    bathrooms = json['bathrooms'];
    petsAllowed = json['petsAllowed'];
    amenities = json['amenities'].cast<String>();
    description = json['description'];
    pricePerNight = json['pricePerNight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['location'] = location;
    data['guests'] = guests;
    data['bedrooms'] = bedrooms;
    data['beds'] = beds;
    data['bathrooms'] = bathrooms;
    data['petsAllowed'] = petsAllowed;
    data['amenities'] = amenities;
    data['description'] = description;
    data['pricePerNight'] = pricePerNight;
    return data;
  }
}
