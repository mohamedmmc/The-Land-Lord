class FilterData {
  final List<DBObject> locationList;
  final List<DBObject> propertyTypelist;
  final List<Amenity> listAmenities;

  factory FilterData.fromJson(json) => FilterData(
        locationList: (json['locationList'] as List).map((e) => DBObject.fromJson(e)).toList(),
        propertyTypelist: (json['propertyTypelist'] as List).map((e) => DBObject.fromJson(e)).toList(),
        listAmenities: (json['listAmenities'] as List).map((e) => Amenity.fromJson(e)).toList(),
      );

  FilterData({required this.locationList, required this.propertyTypelist, required this.listAmenities});
}

class DBObject {
  final int id;
  final String name;

  DBObject({required this.id, required this.name});

  factory DBObject.fromJson(json) => DBObject(
        id: json['id'],
        name: json['name'],
      );
}

class Amenity {
  final String id;
  final String name;

  Amenity({required this.id, required this.name});

  factory Amenity.fromJson(json) => Amenity(
        id: json['id'],
        name: json['name'],
      );
}
