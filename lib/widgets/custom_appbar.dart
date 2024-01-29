import 'package:the_land_lord_website/utils/constants/sizes.dart';
import 'package:the_land_lord_website/views/properties/properties_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/colors.dart';
import 'property_filter/property_filter_widget.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Paddings.extraLarge),
      child: DecoratedBox(
        decoration: const BoxDecoration(color: kNeutralColor100),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Image.asset('assets/images/logo_thelandlord.png', height: 60),
                const Text('Accueil'),
                const Text('Logements'),
                const Text('Services'),
                const Text('A Propos'),
                const Text('Contact'),
                if (Get.currentRoute == PropertiesScreen.routeName)
                  const SizedBox(width: 300)
                else
                  PropertyFilterWidget(
                    propertiesList: SizedBox(height: Get.height),
                    constraints: const BoxConstraints(maxHeight: 60, maxWidth: 300),
                    updateFilter: (filter) {},
                  ),
                const CircleAvatar(radius: 18, backgroundColor: Colors.greenAccent, child: Text('GU')),
                const SizedBox(),
              ],
            ),
            const SizedBox(height: 10),
            // PropertyTypeList(),
          ],
        ),
      ),
    );
  }
}
