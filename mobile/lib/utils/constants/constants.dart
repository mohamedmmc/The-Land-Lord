import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'colors.dart';

class Constants {
  static const Color primaryColor = Color.fromRGBO(71, 148, 255, 1); //Preffered primary color
  static const Color highlightColor = Color.fromRGBO(71, 148, 255, 0.2); //Preffered primary color
  static const Color highlightColor2 = Color.fromRGBO(71, 148, 255, 0.3); //Preffered primary color
}

const LatLng tesaLocation = LatLng(36.8292677, 10.1880348);
BorderRadius circularRadius = BorderRadius.circular(50);
BorderRadius regularRadius = BorderRadius.circular(20);
BorderRadius smallRadius = BorderRadius.circular(10);
Border lightBorder = Border.all(color: kNeutralLightColor, width: 0.5);
Border regularBorder = Border.all(color: kNeutralColor, width: 0.8);
List<String> extraPropertyFilters = ['Piscine', 'Barbecue', 'Jacuzzi', 'Lit pour bébé', 'Cheminée', 'Logement fumeur'];
