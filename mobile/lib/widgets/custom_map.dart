import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';

import '../helpers/helper.dart';
import '../models/property.dart';
import 'custom_marker.dart';

class CustomMap extends StatelessWidget {
  final MapController mapController;
  final Property? property;
  final LatLng? marker;

  const CustomMap({super.key, required this.mapController, this.property, this.marker})
      : assert(property != null || marker != null, 'a Property or a Marker needs to be set before provided');

  @override
  Widget build(BuildContext context) {
    final coordinates = property?.coordinates ?? marker!;
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: coordinates,
        initialZoom: 13,
        onTap: (_, pos) {
          Helper.launchUrlHelper('https://maps.google.com/?q=${coordinates.latitude},${coordinates.longitude}');
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://basemaps.cartocdn.com/rastertiles/voyager_nolabels/{z}/{x}/{y}.png',
          tileProvider: CancellableNetworkTileProvider(),
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: coordinates,
              alignment: Alignment.center,
              width: 90,
              height: 30,
              child: property != null ? BuildCustomMarker(property!, LayerLink(), mapController) : const SizedBox(),
            )
          ],
        ),
      ],
    );
  }
}
