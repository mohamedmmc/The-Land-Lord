import 'package:intl/intl.dart';
import 'package:the_land_lord_website/models/filter_data.dart';

import 'guest.dart';

class PropertyFilterModel {
  int? location;
  DateTime? checkin;
  DateTime? checkout;
  final Guest guest;
  int? rooms;
  int? beds;
  int? type;
  List<Amenity> amenities;

  String? get getDuration {
    if (checkin == null && checkout == null) return null;
    bool isSameMonth = checkin!.month == checkout!.month;
    if (isSameMonth) {
      return '${DateFormat.d().format(checkin!)} - ${DateFormat.d().format(checkout!)} ${DateFormat.yMMM().format(checkout!)}';
    } else {
      return '${DateFormat.Md().format(checkin!)} - ${DateFormat.yMd().format(checkout!)}';
    }
  }

  PropertyFilterModel({this.location, this.checkin, this.checkout, this.beds, this.rooms, this.type, Guest? guest, List<Amenity>? amenitiesList})
      : guest = guest ?? Guest(),
        amenities = amenitiesList ?? [];
}
