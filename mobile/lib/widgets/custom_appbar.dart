import 'package:the_land_lord_website/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';

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
                const CircleAvatar(radius: 18, backgroundColor: kPrimaryColor, child: Text('GU')),
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
