import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';
import '../widgets/custom_appbar.dart';

class Buildables {
  static Widget lightDivider({EdgeInsets? padding}) => Padding(
        padding: padding ?? const EdgeInsets.symmetric(vertical: Paddings.large),
        child: Divider(color: kNeutralLightColor.withAlpha(150), thickness: 0.7),
      );

  static Widget lightVerticalDivider({EdgeInsets? padding}) => Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: Paddings.exceptional),
        child: Container(color: kNeutralLightColor, width: 1, height: 50),
      );

  static AppBar customAppBar() => AppBar(
        backgroundColor: kNeutralColor100,
        surfaceTintColor: kNeutralColor100,
        toolbarHeight: 80,
        leading: const SizedBox(),
        flexibleSpace: const Center(child: CustomAppBar()),
      );
  static TileLayer mapTileLayer() => TileLayer(
        urlTemplate: 'https://basemaps.cartocdn.com/rastertiles/voyager_nolabels/{z}/{x}/{y}.png',
        tileProvider: CancellableNetworkTileProvider(),
      );
}
