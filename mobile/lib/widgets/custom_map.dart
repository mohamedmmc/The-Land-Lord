import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../models/property.dart';
import '../utils/constants/constants.dart';
import 'custom_marker.dart';

class CustomMap extends StatelessWidget {
  final MapController mapController;
  final Property property;

  const CustomMap({super.key, required this.mapController, required this.property});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: property.coordinates ?? tesaLocation,
        initialZoom: 13,
        onTap: (_, pos) {
          // Helper.launchUrlHelper('https://maps.google.com/?q=${tesaLocation.latitude},${tesaLocation.longitude}');
        },
      ),
      children: [
        TileLayer(urlTemplate: 'https://basemaps.cartocdn.com/rastertiles/voyager_nolabels/{z}/{x}/{y}.png'),
        MarkerLayer(
          markers: [
            Marker(
              point: property.coordinates!,
              alignment: Alignment.center,
              width: 90,
              height: 30,
              child: BuildCustomMarker(property, LayerLink(), mapController),
            )
          ],
        ),
      ],
    );
  }
}
