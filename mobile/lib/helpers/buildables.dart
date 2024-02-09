import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:get/get.dart';

import '../services/theme/theme.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';
import '../views/properties/properties_screen.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/on_hover.dart';
import 'helper.dart';

class Buildables {
  static final bool isDrawerMobile = Get.width < 900;
  static Widget lightDivider({EdgeInsets? padding}) => Padding(
        padding: padding ?? const EdgeInsets.symmetric(vertical: Paddings.large),
        child: Divider(color: kNeutralLightColor.withAlpha(150), thickness: 0.7),
      );

  static Widget lightVerticalDivider({EdgeInsets? padding}) => Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: Paddings.exceptional),
        child: Container(color: kNeutralLightColor, width: 1, height: 50),
      );

  static AppBar customAppBar() {
    return AppBar(
      backgroundColor: kNeutralColor100,
      surfaceTintColor: kNeutralColor100,
      toolbarHeight: 80,
      leading: isDrawerMobile ? null : const SizedBox(),
      flexibleSpace: isDrawerMobile
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 100),
                Padding(
                  padding: const EdgeInsets.only(top: Paddings.regular),
                  child: InkWell(
                    onTap: () => Get.offAllNamed(PropertiesScreen.routeName),
                    child: Image.asset('assets/images/logo_thelandlord.png', height: 50),
                  ),
                ),
                CustomDropDownMenu(
                  customButton: const CircleAvatar(radius: 20, backgroundColor: kPrimaryColor, child: Text('GU')),
                  items: const ['Profile', 'Messages', 'Wishlist', 'Logout'],
                  offset: const Offset(-105, -5),
                  dropdownWidth: 200,
                  buttonHeight: 40,
                  onChanged: (p0) {},
                ),
              ],
            )
          : const Center(child: CustomAppBar()),
    );
  }

  static TileLayer mapTileLayer() => TileLayer(
        urlTemplate: 'https://basemaps.cartocdn.com/rastertiles/voyager_nolabels/{z}/{x}/{y}.png',
        tileProvider: CancellableNetworkTileProvider(),
      );

  static customDrawer() {
    return isDrawerMobile
        ? Drawer(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Paddings.exceptional, horizontal: Paddings.large),
              child: ListView.builder(
                itemCount: screens.length,
                itemBuilder: (context, index) => OnHover(
                  builder: (isHovered) => ListTile(
                    title: Text(screens[index], style: AppFonts.x16Regular.copyWith(fontWeight: Helper.isCurrentRoute(index) || isHovered ? FontWeight.bold : null)),
                  ),
                ),
              ),
            ),
          )
        : null;
  }
}
