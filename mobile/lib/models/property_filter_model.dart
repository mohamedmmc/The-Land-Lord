import 'package:intl/intl.dart';
import 'package:the_land_lord_website/models/filter_data.dart';

import '../utils/constants/constants.dart';
import 'guest.dart';

class PropertyFilterModel {
  int? location;
  DateTime? checkin;
  DateTime? checkout;
  Guest guest;
  int? bathrooms;
  int? beds;
  int? type;
  double priceMin;
  double priceMax;
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

  PropertyFilterModel({this.location, this.checkin, this.checkout, this.beds, this.bathrooms, this.type, Guest? guest, List<Amenity>? amenitiesList, double? priceMin = 20, double? priceMax = 2200})
      : guest = guest ?? Guest(),
        priceMin = priceMin ?? minPriceRange,
        priceMax = priceMax ?? maxPriceRange,
        amenities = amenitiesList ?? [];
}
