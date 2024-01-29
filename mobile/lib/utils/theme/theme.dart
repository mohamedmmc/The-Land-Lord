import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../constants/colors.dart';

enum MyThemeMode { light, dark }

class AppFonts {
  static const TextStyle x24Regular = TextStyle(
    color: kBlackColor,
    fontSize: 24,
  );
  static const TextStyle x24Bold = TextStyle(
    color: kBlackColor,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle x18Bold = TextStyle(
    color: kBlackColor,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle x18Regular = TextStyle(
    color: kBlackColor,
    fontSize: 18,
  );
  static const TextStyle x16Bold = TextStyle(
    color: kBlackColor,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle x16Regular = TextStyle(
    color: kBlackColor,
    fontSize: 16,
  );
  static const TextStyle x15Bold = TextStyle(
    color: kBlackColor,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle x14Bold = TextStyle(
    color: kBlackColor,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle x14Regular = TextStyle(
    color: kBlackColor,
    fontSize: 14,
  );
  static const TextStyle x12Regular = TextStyle(
    color: kBlackColor,
    fontSize: 12,
  );

  ThemeData basicTheme({MyThemeMode theme = MyThemeMode.light}) {
    final ThemeData lightBase = ThemeData.light();
    final ThemeData darkBase = ThemeData.dark();
    final Logger logger = Logger();

    TextTheme basicTextTheme(TextTheme base) => base.copyWith(displayLarge: AppFonts.x18Bold);

    if (theme == MyThemeMode.light) {
      return lightBase.copyWith(
        textTheme: basicTextTheme(lightBase.textTheme),
        brightness: Brightness.light,
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kNeutralColor100,
        // colorScheme: const ColorScheme(error: kErrorColor),
      );
    } else if (theme == MyThemeMode.dark) {
      return darkBase.copyWith(
        textTheme: basicTextTheme(darkBase.textTheme).copyWith(
          displayLarge: AppFonts.x18Bold.copyWith(color: kNeutralColor100),
        ),
        brightness: Brightness.dark,
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kNeutralColor,
        // colorScheme: const ColorScheme(error: kErrorColor),
      );
    } else {
      logger.e('Error: Provided theme does not exist');
    }
    return ThemeData.light(); //default Flutter theme
  }
}
