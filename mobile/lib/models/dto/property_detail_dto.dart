import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../helpers/helper.dart';
import '../../networking/api_base_helper.dart';

class PropertyDetailsDTO {
  MappedProperty? mappedProperties;
  List<BlockDTO> mappedCalendar;

  PropertyDetailsDTO({required this.mappedProperties, required this.mappedCalendar});

  factory PropertyDetailsDTO.fromJson(Map<String, dynamic> json) => PropertyDetailsDTO(
        mappedProperties: json['mappedProperties']?[0] != null ? MappedProperty.fromJson(json['mappedProperties'][0]) : null,
        mappedCalendar: json['mappedCalendar'] != null ? List<BlockDTO>.from(json['mappedCalendar'].map((x) => BlockDTO.fromJson(x))) : [],
      );

  List<DateTime> getBlackoutDates() {
    List<DateTime> result = [];
    for (final element in mappedCalendar) {
      result.addAll(Helper.getDatesInRange(DateTimeRange(start: DateTime.parse(element.dateFrom), end: DateTime.parse(element.dateTo))));
    }
    return result;
  }
}

class BlockDTO {
  final String dateFrom;
  final String dateTo;

  BlockDTO({required this.dateFrom, required this.dateTo});

  factory BlockDTO.fromJson(Map<String, dynamic> json) {
    return BlockDTO(
      dateFrom: json['block']['date_from'],
      dateTo: json['block']['date_to'],
    );
  }
}

class MappedProperty {
  String id;
  String name;
  DateTime lastModified;
  DateTime dateCreated;
  String cleaningPrice;
  String space;
  String standardGuests;
  String canSleepMax;
  String typePropertyId;
  String objectTypeId;
  String floor;
  String street;
  String zipCode;
  Coordinates coordinates;
  CheckInOut checkInOut;
  String preparationTimeBeforeArrival;
  String preparationTimeBeforeArrivalInHours;
  String isActive;
  String isArchived;
  List<HouseRule> houseRules;
  List<Description> description;
  List<CancellationPolicy> cancellationPolicies;
  Location location;
  List<Amenity> amenity;
  List<Amenity> paiement;
  List<Amenity> room;
  List<ImageDTO> images;
  List<Deposit> deposit;
  bool petsAllowed;
  bool smokingAllowed;
  double rating;
  int reviewers;

  MappedProperty({
    required this.id,
    required this.name,
    required this.lastModified,
    required this.dateCreated,
    required this.cleaningPrice,
    required this.space,
    required this.standardGuests,
    required this.canSleepMax,
    required this.typePropertyId,
    required this.objectTypeId,
    required this.floor,
    required this.street,
    required this.zipCode,
    required this.coordinates,
    required this.checkInOut,
    required this.preparationTimeBeforeArrival,
    required this.preparationTimeBeforeArrivalInHours,
    required this.isActive,
    required this.isArchived,
    required this.houseRules,
    required this.description,
    required this.cancellationPolicies,
    required this.location,
    required this.amenity,
    required this.paiement,
    required this.room,
    required this.images,
    required this.deposit,
    required this.rating,
    required this.reviewers,
    this.petsAllowed = true,
    this.smokingAllowed = false,
  });

  factory MappedProperty.fromJson(Map<String, dynamic> json) {
    final model = MappedProperty(
      id: json["id"],
      name: json["name"],
      lastModified: DateTime.parse(json["last_modified"]),
      dateCreated: DateTime.parse(json["date_created"]),
      cleaningPrice: double.parse(json["cleaning_price"] ?? '0').toStringAsFixed(2),
      space: json["space"],
      standardGuests: json["standard_guests"],
      canSleepMax: json["can_sleep_max"],
      typePropertyId: json["type_property_id"],
      objectTypeId: json["objectType_id"],
      floor: json["floor"],
      street: json["street"],
      zipCode: json["zip_code"],
      rating: json["rating"] ?? 5,
      reviewers: json["reviewers"] ?? 0,
      coordinates: Coordinates.fromJson(json["coordinates"]),
      checkInOut: CheckInOut.fromJson(json["check_in_out"]),
      preparationTimeBeforeArrival: json["preparation_time_before_arrival"],
      preparationTimeBeforeArrivalInHours: json["preparation_time_before_arrival_in_hours"],
      isActive: json["is_active"],
      isArchived: json["is_archived"],
      houseRules: List<HouseRule>.from(json["houseRules"].map((x) => HouseRule.fromJson(x))),
      description: List<Description>.from(json["description"].map((x) => Description.fromJson(x))),
      cancellationPolicies: List<CancellationPolicy>.from(json["cancellation_policies"].map((x) => CancellationPolicy.fromJson(x))),
      location: Location.fromJson(json["location"]),
      amenity: List<Amenity>.from(json["amenity"].map((x) => Amenity.fromJson(x))),
      paiement: List<Amenity>.from(json["paiement"].map((x) => Amenity.fromJson(x))),
      room: List<Amenity>.from(json["room"].map((x) => Amenity.fromJson(x))),
      images: List<ImageDTO>.from(json["images"].map((x) => ImageDTO.fromJson(x))),
      deposit: List<Deposit>.from(json["deposit"].map((x) => Deposit.fromJson(x))),
    );
    model.petsAllowed = model.houseRules.any((element) => element.houseRules.contains('Pets - allowed'));
    model.smokingAllowed = model.houseRules.any((element) => element.houseRules.contains('Smoking - allowed'));
    return model;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "last_modified": lastModified.toIso8601String(),
        "date_created": "${dateCreated.year.toString().padLeft(4, '0')}-${dateCreated.month.toString().padLeft(2, '0')}-${dateCreated.day.toString().padLeft(2, '0')}",
        "cleaning_price": cleaningPrice,
        "space": space,
        "standard_guests": standardGuests,
        "can_sleep_max": canSleepMax,
        "type_property_id": typePropertyId,
        "objectType_id": objectTypeId,
        "floor": floor,
        "street": street,
        "zip_code": zipCode,
        "coordinates": coordinates.toJson(),
        "check_in_out": checkInOut.toJson(),
        "preparation_time_before_arrival": preparationTimeBeforeArrival,
        "preparation_time_before_arrival_in_hours": preparationTimeBeforeArrivalInHours,
        "is_active": isActive,
        "is_archived": isArchived,
        "houseRules": List<dynamic>.from(houseRules.map((x) => x.toJson())),
        "description": List<dynamic>.from(description.map((x) => x.toJson())),
        "cancellation_policies": List<dynamic>.from(cancellationPolicies.map((x) => x.toJson())),
        "location": location.toJson(),
        "amenity": List<dynamic>.from(amenity.map((x) => x.toJson())),
        "paiement": List<dynamic>.from(paiement.map((x) => x.toJson())),
        "room": List<dynamic>.from(room.map((x) => x.toJson())),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "deposit": List<dynamic>.from(deposit.map((x) => x.toJson())),
      };

  String getPropertySizeOverview() =>
      '$standardGuests guests • ${room.singleWhere((element) => element.id == 257).count} bedrooms • $canSleepMax beds • ${room.singleWhere((element) => element.id == 81).count} baths';

  String getFullAddress() => '${location.name}, $street, $zipCode';
}

class Amenity {
  int id;
  String name;
  int count;

  Amenity({
    required this.id,
    required this.name,
    required this.count,
  });

  factory Amenity.fromJson(Map<String, dynamic> json) => Amenity(
        id: json["id"],
        name: json["name"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "count": count,
      };
}

class CancellationPolicy {
  String value;
  String validFrom;
  String validTo;

  CancellationPolicy({
    required this.value,
    required this.validFrom,
    required this.validTo,
  });

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) => CancellationPolicy(
        value: json["value"],
        validFrom: json["validFrom"],
        validTo: json["validTo"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "validFrom": validFrom,
        "validTo": validTo,
      };
}

class CheckInOut {
  List<String> checkInFrom;
  List<String> checkInTo;
  List<String> checkOutUntil;
  List<String> place;

  CheckInOut({
    required this.checkInFrom,
    required this.checkInTo,
    required this.checkOutUntil,
    required this.place,
  });

  factory CheckInOut.fromJson(Map<String, dynamic> json) => CheckInOut(
        checkInFrom: List<String>.from(json["CheckInFrom"].map((x) => x)),
        checkInTo: List<String>.from(json["CheckInTo"].map((x) => x)),
        checkOutUntil: List<String>.from(json["CheckOutUntil"].map((x) => x)),
        place: List<String>.from(json["Place"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "CheckInFrom": List<dynamic>.from(checkInFrom.map((x) => x)),
        "CheckInTo": List<dynamic>.from(checkInTo.map((x) => x)),
        "CheckOutUntil": List<dynamic>.from(checkOutUntil.map((x) => x)),
        "Place": List<dynamic>.from(place.map((x) => x)),
      };
}

class Coordinates {
  List<String> latitude;
  List<String> longitude;

  Coordinates({
    required this.latitude,
    required this.longitude,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        latitude: List<String>.from(json["Latitude"].map((x) => x)),
        longitude: List<String>.from(json["Longitude"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Latitude": List<dynamic>.from(latitude.map((x) => x)),
        "Longitude": List<dynamic>.from(longitude.map((x) => x)),
      };

  LatLng toLatLng() => LatLng(double.parse(latitude.first), double.parse(longitude.first));
}

class Deposit {
  int id;
  String name;
  String value;

  Deposit({
    required this.id,
    required this.name,
    required this.value,
  });

  factory Deposit.fromJson(Map<String, dynamic> json) => Deposit(
        id: json["id"],
        name: json["name"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "value": value,
      };
}

class Description {
  String languageId;
  String text;

  Description({
    required this.languageId,
    required this.text,
  });

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        languageId: json["language_id"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "language_id": languageId,
        "text": text,
      };
}

class HouseRule {
  String houseRules;

  HouseRule({
    required this.houseRules,
  });

  factory HouseRule.fromJson(Map<String, dynamic> json) => HouseRule(
        houseRules: json["house_rules"],
      );

  Map<String, dynamic> toJson() => {
        "house_rules": houseRules,
      };
}

class ImageDTO {
  int id;
  String url;
  String thumbnail;

  ImageDTO({
    required this.id,
    required this.url,
    required this.thumbnail,
  });

  factory ImageDTO.fromJson(Map<String, dynamic> json) => ImageDTO(
        id: json["id"],
        url: json["url"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": ApiBaseHelper().getImageProperty(url),
        "thumbnail": ApiBaseHelper().getImageProperty(thumbnail),
      };
}

class Location {
  String id;
  String name;

  Location({
    required this.id,
    required this.name,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
