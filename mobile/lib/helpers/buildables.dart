import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';

class Buildables {
  static Widget lightDivider({EdgeInsets? padding}) => Padding(
        padding: padding ?? const EdgeInsets.symmetric(vertical: Paddings.large),
        child: Divider(color: kNeutralLightColor.withAlpha(150), thickness: 0.7),
      );

  static Widget lightVerticalDivider({EdgeInsets? padding}) => Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: Paddings.exceptional),
        child: Container(color: kNeutralLightColor, width: 1, height: 50),
      );
}
