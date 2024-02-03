import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

import '../models/property.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/constants.dart';
import '../utils/constants/sizes.dart';
import '../utils/theme/theme.dart';
import 'property_card.dart';

class BuildCustomMarker extends StatefulWidget {
  final Property property;
  final MapController mapController;
  final LayerLink layerLink;

  const BuildCustomMarker(this.property, this.layerLink, this.mapController, {super.key});

  @override
  State<BuildCustomMarker> createState() => _BuildCustomMarkerState();
}

class _BuildCustomMarkerState extends State<BuildCustomMarker> {
  Future<bool> openMarkerPopup(Property property, LayerLink markerLink, {bool close = false}) async {
    final bool = widget.mapController.move(property.coordinates!, 14);
    if (!close) {
      double width = 200;
      double height = 220;
      Get.dialog(
        barrierColor: Colors.transparent,
        AlertDialog(
          // actions: const [Icon(Icons.search)],
          alignment: Alignment.centerRight,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(100),
          content: CompositedTransformFollower(
            targetAnchor: Alignment.topLeft,
            offset: Offset(-(width / 3.5) - 15, -height - 5),
            link: markerLink,
            child: Container(
              padding: const EdgeInsets.all(Paddings.regular),
              height: height,
              decoration: BoxDecoration(borderRadius: regularRadius, color: kNeutralColor100),
              child: Center(
                child: PropertyCard(property: property, width: width, height: height),
              ),
            ),
          ),
        ),
      );
    } else if (Get.isDialogOpen ?? false) {
      Get.back();
    }
    return bool;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 30,
      child: CompositedTransformTarget(
        link: widget.layerLink,
        child: SizedBox(
          width: 90,
          height: 30,
          child: InkWell(
            onTap: () => openMarkerPopup(widget.property, widget.layerLink),
            child: DecoratedBox(
              decoration: BoxDecoration(color: kNeutralColor100, borderRadius: circularRadius, border: regularBorder),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Paddings.regular, vertical: Paddings.small),
                child: Center(child: FittedBox(child: Text('${widget.property.pricePerNight?.toInt() ?? 280} TND', style: AppFonts.x14Bold))),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
