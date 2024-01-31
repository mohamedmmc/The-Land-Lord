import 'package:intl/intl.dart';

import '../utils/enums/property_type.dart';
import 'guest.dart';

class PropertyFilterModel {
  int? location;
  DateTime? checkin;
  DateTime? checkout;
  final Guest guest;
  int? rooms;
  int? beds;
  PropertyType? type;

  String? get getDuration {
    if (checkin == null && checkout == null) return null;
    bool isSameMonth = checkin!.month == checkout!.month;
    if (isSameMonth) {
      return '${DateFormat.d().format(checkin!)} - ${DateFormat.d().format(checkout!)} ${DateFormat.yMMM().format(checkout!)}';
    } else {
      return '${DateFormat.Md().format(checkin!)} - ${DateFormat.yMd().format(checkout!)}';
    }
  }

  PropertyFilterModel({this.location, this.checkin, this.checkout, this.beds, this.rooms, this.type, Guest? guest}) : guest = guest ?? Guest();
}
