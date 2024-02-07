import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:the_land_lord_website/networking/api_base_helper.dart';

import '../../helpers/helper.dart';
import '../../services/main_app_service.dart';

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

class PaymentDTO {
  final String paymentId;

  PaymentDTO({required this.paymentId});

  factory PaymentDTO.fromJson(Map<String, dynamic> json) {
    return PaymentDTO(paymentId: json['payement_id']);
  }
}

class RoomDTO {
  final String roomId;

  RoomDTO({required this.roomId});

  factory RoomDTO.fromJson(Map<String, dynamic> json) {
    return RoomDTO(roomId: json['room_id']);
  }
}

class AmenityDTO {
  final String amenityId;
  final String count;

  AmenityDTO({required this.amenityId, required this.count});

  factory AmenityDTO.fromJson(Map<String, dynamic> json) {
    return AmenityDTO(
      amenityId: json['amenity_id'],
      count: json['count'],
    );
  }
}

class CoordinatesDTO {
  final List<String> latitude;
  final List<String> longitude;

  CoordinatesDTO({required this.latitude, required this.longitude});

  factory CoordinatesDTO.fromJson(Map<String, dynamic> json) {
    return CoordinatesDTO(
      latitude: List<String>.from(json['Latitude']),
      longitude: List<String>.from(json['Longitude']),
    );
  }

  LatLng toLatLng() => LatLng(double.parse(latitude.first), double.parse(longitude.first));
}

class CheckInOutDTO {
  final List<String> checkInFrom;
  final List<String> checkInTo;
  final List<String> checkOutUntil;
  final List<String> place;

  CheckInOutDTO({
    required this.checkInFrom,
    required this.checkInTo,
    required this.checkOutUntil,
    required this.place,
  });

  factory CheckInOutDTO.fromJson(Map<String, dynamic> json) {
    return CheckInOutDTO(
      checkInFrom: List<String>.from(json['CheckInFrom']),
      checkInTo: List<String>.from(json['CheckInTo']),
      checkOutUntil: List<String>.from(json['CheckOutUntil']),
      place: List<String>.from(json['Place']),
    );
  }
}

class CancellationPolicyDTO {
  final String value;
  final String validFrom;
  final String validTo;

  CancellationPolicyDTO({
    required this.value,
    required this.validFrom,
    required this.validTo,
  });

  factory CancellationPolicyDTO.fromJson(Map<String, dynamic> json) {
    return CancellationPolicyDTO(
      value: json['value'],
      validFrom: json['validFrom'],
      validTo: json['validTo'],
    );
  }
}

class MappedPropertyDTO {
  final String id;
  final String name;
  final String locationId;
  final String lastModified;
  final String dateCreated;
  final String cleaningPrice;
  final String space;
  final String standardGuests;
  final String canSleepMax;
  final String? wcCount;
  final double? pricePerNight;
  final String typePropertyId;
  final String objectTypeId;
  final List<String> images;
  final List<PaymentDTO> payment;
  final List<RoomDTO> rooms;
  final List<AmenityDTO> amenities;
  final String floor;
  final String street;
  final String zipCode;
  final CoordinatesDTO coordinates;
  final CheckInOutDTO checkInOut;
  final String depositId;
  final String depositValue;
  final String preparationTimeBeforeArrival;
  final String preparationTimeBeforeArrivalInHours;
  final String isActive;
  final String isArchived;
  final List<CancellationPolicyDTO> cancellationPolicies;

  MappedPropertyDTO({
    required this.id,
    required this.name,
    required this.locationId,
    required this.lastModified,
    required this.dateCreated,
    required this.cleaningPrice,
    required this.space,
    required this.standardGuests,
    required this.canSleepMax,
    required this.wcCount,
    required this.pricePerNight,
    required this.typePropertyId,
    required this.objectTypeId,
    required this.images,
    required this.payment,
    required this.rooms,
    required this.amenities,
    required this.floor,
    required this.street,
    required this.zipCode,
    required this.coordinates,
    required this.checkInOut,
    required this.depositId,
    required this.depositValue,
    required this.preparationTimeBeforeArrival,
    required this.preparationTimeBeforeArrivalInHours,
    required this.isActive,
    required this.isArchived,
    required this.cancellationPolicies,
  });

  factory MappedPropertyDTO.fromJson(Map<String, dynamic> json) {
    return MappedPropertyDTO(
      id: json['id'],
      name: json['name'],
      locationId: json['location_id'],
      lastModified: json['last_modified'],
      dateCreated: json['date_created'],
      cleaningPrice: double.tryParse(json['cleaning_price'])?.toStringAsFixed(1) ?? '0',
      space: json['space'],
      standardGuests: json['standard_guests'],
      canSleepMax: json['can_sleep_max'],
      wcCount: json['wc_count'],
      pricePerNight: json['price_per_night'],
      typePropertyId: json['type_property_id'],
      objectTypeId: json['objectType_id'],
      images: List<String>.from(json['image'].map((image) => ApiBaseHelper().getImageFromRentals(image['url']))),
      payment: List<PaymentDTO>.from(json['paiement'].map((payment) => PaymentDTO.fromJson(payment))),
      rooms: List<RoomDTO>.from(json['room'].map((room) => RoomDTO.fromJson(room))),
      amenities: List<AmenityDTO>.from(json['amenities'].map((amenity) => AmenityDTO.fromJson(amenity))),
      floor: json['floor'],
      street: json['street'],
      zipCode: json['zip_code'],
      coordinates: CoordinatesDTO.fromJson(json['coordinates']),
      checkInOut: CheckInOutDTO.fromJson(json['check_in_out']),
      depositId: json['deposit_id'],
      depositValue: json['deposit_value'],
      preparationTimeBeforeArrival: json['preparation_time_before_arrival'],
      preparationTimeBeforeArrivalInHours: json['preparation_time_before_arrival_in_hours'],
      isActive: json['is_active'],
      isArchived: json['is_archived'],
      cancellationPolicies: List<CancellationPolicyDTO>.from(json['cancellation_policies'].map((policy) => CancellationPolicyDTO.fromJson(policy))),
    );
  }

  String getPropertySizeOverview() => '$standardGuests guests • ${rooms.length} bedrooms • $canSleepMax beds • ${wcCount ?? 0} baths';

  String getFullAddress() => '${MainAppServie.find.getLocationNameById(int.parse(locationId))}, $street, $zipCode';
}

class MappedCalendarDTO {
  final BlockDTO block;

  MappedCalendarDTO({required this.block});

  factory MappedCalendarDTO.fromJson(Map<String, dynamic> json) {
    return MappedCalendarDTO(block: BlockDTO.fromJson(json));
  }
}

class PropertyDetailDTO {
  final List<MappedCalendarDTO> mappedCalendar;
  final MappedPropertyDTO mappedProperties;

  PropertyDetailDTO({required this.mappedCalendar, required this.mappedProperties});

  factory PropertyDetailDTO.fromJson(Map<String, dynamic> json) {
    return PropertyDetailDTO(
        mappedCalendar: List<MappedCalendarDTO>.from(json['mappedCalendar'].map((calendar) => MappedCalendarDTO.fromJson(calendar))),
        mappedProperties: MappedPropertyDTO.fromJson(json['mappedProperties']));
  }

  List<DateTime> getBlackoutDates() {
    List<DateTime> result = [];
    for (final element in mappedCalendar) {
      result.addAll(Helper.getDatesInRange(DateTimeRange(start: DateTime.parse(element.block.dateFrom), end: DateTime.parse(element.block.dateTo))));
    }
    return result;
  }
}
