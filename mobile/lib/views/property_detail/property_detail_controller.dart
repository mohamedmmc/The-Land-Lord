import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:the_land_lord_website/helpers/helper.dart';
import 'package:the_land_lord_website/repository/property_repository.dart';
import 'package:the_land_lord_website/services/shared_preferences.dart';

import '../../models/comments.dart';
import '../../models/dto/property_detail_dto.dart';

class PropertyDetailController extends GetxController {
  final ScrollController scrollController = ScrollController();
  String? idProperty;
  PropertyDetailsDTO? propertyDetailsDTO;
  MapController mapController = MapController();
  DateTimeRange _selectedDuration = DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 3)));
  double galleryAdditionalHeight = 0;
  double? estimatedPrice;

  DateTimeRange get selectedDuration => _selectedDuration;

  set selectedDuration(DateTimeRange value) {
    _selectedDuration = value;
    update();
  }

  PropertyDetailController() {
    _init();
  }

  void _init() {
    Helper.waitAndExecute(() => SharedPreferencesService.find.isReady, () async {
      idProperty = Get.arguments?['id'] ?? SharedPreferencesService.find.get('idProperty');
      estimatedPrice = Get.arguments?['price'] ?? double.parse(SharedPreferencesService.find.get('propertyPrice') ?? '0');
      estimatedPrice = double.parse(estimatedPrice!.toStringAsFixed(2));
      if (idProperty != null) {
        propertyDetailsDTO = await PropertyRepository.find.getDetailProperty(idProperty: idProperty!);
        Helper.waitAndExecute(
          () => propertyDetailsDTO?.mappedProperties != null,
          () => PropertyRepository.find.getPropertyCalendar(idProperty: idProperty!, location: propertyDetailsDTO!.mappedProperties!.location.id).then((value) {
            propertyDetailsDTO?.mappedCalendar = value.mappedCalendar;
            update();
          }),
        );
      }
      update();
    });
  }

  double getTotalPrice() => double.parse(((estimatedPrice ?? 280) * Helper.getDurationInRange(selectedDuration) +
          (propertyDetailsDTO!.mappedProperties?.cleaningPrice != null ? double.parse(propertyDetailsDTO!.mappedProperties!.cleaningPrice) : 50))
      .toStringAsFixed(2));

  static List<Comments> dummyComments = [
    Comments(
      name: 'Sarah Jones',
      country: 'United States',
      rating: 5,
      comment:
          "While the location of this apartment was convenient, the interior felt a bit dated and could use some modernization. The furniture was worn, and the kitchen appliances were quite old. Additionally, the Wi-Fi connection was slow and unreliable, which caused some frustration during my stay. On the positive side, the apartment was clean and spacious, and the host was responsive to my inquiries. However, considering the price point, I was expecting a more updated and well-maintained space. With some renovations and improvements, this apartment could be a great option for budget-conscious travelers.",
      createdAt: DateTime.parse('2024-02-07'),
    ),
    Comments(
      name: 'Jean Dupont',
      country: 'France',
      rating: 4,
      comment: "Lovely location and comfortable apartment. Communication with the host was smooth. Only downside was the slightly noisy street traffic at night.",
      createdAt: DateTime.parse('2024-02-05'),
    ),
    Comments(
      name: 'Maria Garcia',
      country: 'Spain',
      rating: 5,
      comment: "Perfect for a group trip! The spacious living area and well-equipped kitchen were great for socializing and cooking together. Would definitely stay here again!",
      createdAt: DateTime.parse('2024-02-03'),
    ),
    Comments(
      name: 'Li Wang',
      country: 'China',
      rating: 3,
      comment:
          "Planning a group trip can be tricky, but finding the perfect accommodation wasn't an issue thanks to this spacious loft! The living area was large enough for everyone to spread out and relax, and the kitchen was well-equipped for all our culinary adventures. We especially enjoyed the rooftop terrace, perfect for barbecues and socializing under the stars. The host, Daniel, was incredibly understanding and flexible, allowing for late check-out and even offering extra towels when needed. The location was great too, close to shops, restaurants, and nightlife. We had a blast and made some unforgettable memories here. Highly recommend for any group looking for a fun and comfortable stay!",
      createdAt: DateTime.parse('2024-02-02'),
    ),
    Comments(
      name: 'Michael Schmidt',
      country: 'Germany',
      rating: 5,
      comment: "The host went above and beyond to make our stay memorable. From providing local recommendations to offering early check-in, they exceeded our expectations.",
      createdAt: DateTime.parse('2024-01-31'),
    ),
    Comments(
      name: 'Anna Petrova',
      country: 'Russia',
      rating: 4,
      comment: "Clean and cozy apartment with a stunning view. However, the lack of air conditioning made it a bit uncomfortable during the hot summer days.",
      createdAt: DateTime.parse('2024-01-28'),
    ),
    Comments(
      name: 'David Lee',
      country: 'South Korea',
      rating: 5,
      comment:
          "This charming studio apartment offered a quaint and peaceful escape in the heart of the city. The location was fantastic, nestled in a quiet side street but just a short walk away from many popular attractions. The apartment itself was clean and well-maintained, with comfortable furniture and a well-equipped kitchen. My one critique is the somewhat limited natural light due to the lack of large windows. However, the host, Pierre, was incredibly friendly and accommodating, even leaving a welcome basket with local treats. He was also readily available to answer any questions and offer recommendations. Overall, it was a pleasant stay in a convenient location, and with a few minor adjustments, this apartment could be truly exceptional.",
      createdAt: DateTime.parse('2024-01-25'),
    ),
    Comments(
      name: 'Isabella Rossi',
      country: 'Italy',
      rating: 4,
      comment: "Great location close to public transportation and amenities. Only minor issue was the slightly worn-out furniture in the living room.",
      createdAt: DateTime.parse('2024-01-22'),
    ),
    Comments(
      name: 'Pedro Martinez',
      country: 'Mexico',
      rating: 5,
      comment: "Fantastic value for the price! The apartment was well-maintained, had all the necessary amenities, and the host was super friendly and accommodating.",
      createdAt: DateTime.parse('2024-01-20'),
    ),
    Comments(
      name: 'Aisha Khan',
      country: 'India',
      rating: 3,
      comment:
          "From the moment I booked, I knew this stay would be special. The host, Sarah, was incredibly communicative and helpful, even recommending hidden gem restaurants and activities not found in tourist guides. The apartment itself was spotless, beautifully decorated with a modern yet cozy vibe, and equipped with everything we needed for a comfortable stay. The highlight was definitely the private balcony overlooking the bustling city square, perfect for enjoying morning coffee or evening drinks. We couldn't have asked for a better location, central to everything we wanted to see and do. Overall, this place exceeded our expectations and we wouldn't hesitate to recommend it to anyone visiting the city!",
      createdAt: DateTime.parse('2024-01-18'),
    ),
  ];
}
