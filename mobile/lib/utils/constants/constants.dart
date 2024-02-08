import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'colors.dart';

const LatLng tesaLocation = LatLng(36.8292677, 10.1880348);

BorderRadius circularRadius = BorderRadius.circular(50);
BorderRadius regularRadius = BorderRadius.circular(20);
BorderRadius smallRadius = BorderRadius.circular(10);

Border lightBorder = Border.all(color: kNeutralLightColor, width: 0.5);
Border regularBorder = Border.all(color: kNeutralColor, width: 0.8);

const laMarsaGrp = {
  'title': "La Marsa",
  'children': [63298, 25348, 63299],
};

double minPriceRange = 20;
double maxPriceRange = 2200;

const int kLoadMoreLimit = 9;
