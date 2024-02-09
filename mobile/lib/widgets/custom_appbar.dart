import 'package:get/get.dart';
import 'package:the_land_lord_website/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:the_land_lord_website/services/theme/theme.dart';
import 'package:the_land_lord_website/views/properties/properties_screen.dart';
import 'package:the_land_lord_website/widgets/custom_dropdown.dart';
import 'package:the_land_lord_website/widgets/on_hover.dart';

import '../helpers/helper.dart';
import '../utils/constants/colors.dart';

final List<String> screens = ['Accueil', 'Logements', 'Services', 'A Propos', 'Contact'];

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Paddings.small, horizontal: Paddings.exceptional),
          child: DecoratedBox(
            decoration: const BoxDecoration(color: kNeutralColor100),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Get.offAllNamed(PropertiesScreen.routeName),
                  child: Image.asset('assets/images/logo_thelandlord.png', height: 50),
                ),
                const Spacer(),
                ...List.generate(
                  screens.length,
                  (index) => OnHover(
                    builder: (isHovered) => Padding(
                      padding: EdgeInsets.only(right: index < screens.length - 1 ? Paddings.exceptional * 2 : 0),
                      child: Text(screens[index], style: AppFonts.x16Regular.copyWith(fontWeight: Helper.isCurrentRoute(index) || isHovered ? FontWeight.bold : null)),
                    ),
                  ),
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: -10,
          child: CustomDropDownMenu(
            customButton: const CircleAvatar(radius: 20, backgroundColor: kPrimaryColor, child: Text('GU')),
            items: const ['Profile', 'Messages', 'Wishlist', 'Logout'],
            offset: const Offset(-105, -5),
            dropdownWidth: 200,
            buttonHeight: 40,
            onChanged: (p0) {},
          ),
        ),
      ],
    );
  }
}
