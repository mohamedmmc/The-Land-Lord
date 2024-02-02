import 'dart:convert';

import 'package:latlong2/latlong.dart';

class Property {
  String? id;
  String? name;
  String? type;
  List<String>? imagePath;
  int? location;
  int? guests;
  int? beds;
  int? rooms;
  double? bathrooms;
  bool? petsAllowed;
  List<String>? amenities;
  String? description;
  double? pricePerNight;
  double? rating;
  int? reviews;
  String? houseRules;
  LatLng? coordinates;

  Property({
    this.id,
    this.name,
    this.type,
    this.location,
    this.guests,
    this.beds,
    this.rooms,
    this.bathrooms,
    this.petsAllowed,
    this.amenities,
    this.description,
    this.pricePerNight,
    this.imagePath,
    this.houseRules,
    this.rating,
    this.reviews,
    this.coordinates,
  });

  Property.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    type = json['type'];
    location = json['location'];
    guests = int.tryParse(json['guests']);
    beds = json['beds'] != null ? int.tryParse(json['beds']) : null;
    rooms = json['rooms'] != null ? int.tryParse(json['rooms']) : null;
    imagePath = (json['images'] as List).map((e) => e.toString()).toList();
    bathrooms = json['bathrooms'];
    petsAllowed = json['petsAllowed'];
    amenities = json['amenities'];
    description = json['description'];
    pricePerNight = double.parse(json['price']);
    amenities = json['amenities'];
    rating = json['rating'] != null ? double.parse(json['rating']) : null;
    reviews = json['reviews'];
    houseRules = json['rules'];
    coordinates =
        json['coordinates'] == null ? null : LatLng(double.parse(jsonDecode(json['coordinates'])['Latitude'][0]), double.parse(jsonDecode(json['coordinates'])['Longitude'][0]));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['location'] = location;
    data['guests'] = guests;
    data['beds'] = beds;
    data['rooms'] = rooms;
    data['bathrooms'] = bathrooms;
    data['petsAllowed'] = petsAllowed;
    data['amenities'] = amenities;
    data['description'] = description;
    data['pricePerNight'] = pricePerNight;
    return data;
  }
}
