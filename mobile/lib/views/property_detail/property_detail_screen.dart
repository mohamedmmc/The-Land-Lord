import 'package:card_swiper/card_swiper.dart';
import 'package:the_land_lord_website/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_land_lord_website/views/property_detail/property_detail_controller.dart';

import '../../helpers/helper.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/constants.dart';
import '../../widgets/custom_appbar.dart';

class PropertyDetailScreen extends StatelessWidget {
  static const String routeName = '/property_detail';

  const PropertyDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kNeutralColor100,
        surfaceTintColor: kNeutralColor100,
        toolbarHeight: 110,
        flexibleSpace: const CustomAppBar(),
      ),
      // TODO Use for mobile device
      // bottomNavigationBar: AppBottomNavigation(),
      body: GetBuilder<PropertyDetailController>(
        builder: (controller) => DecoratedBox(
            decoration: BoxDecoration(border: Border(top: BorderSide(color: kNeutralLightColor, width: 0.5))),
            child: Helper.isLoading.value
                ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
                : SharedPreferencesService.find.isReady
                    ? Swiper(
                        itemBuilder: (_, int i) => ClipRRect(
                          borderRadius: regularRadius,
                          child: Image.network(
                            controller.propertyDetailDTO.mappedProperties.images[i].url,
                            height: 200,
                            width: 200,
                            fit: BoxFit.fitHeight,

                          ),
                        ),
                        itemCount: controller.propertyDetailDTO.mappedProperties.images.length,
                        pagination: const SwiperPagination(),
                        control: const SwiperControl(), // TODO Customize this
                      )
                    : const Center(child: CircularProgressIndicator(color: kPrimaryColor))),
      ),
    );
  }
}
