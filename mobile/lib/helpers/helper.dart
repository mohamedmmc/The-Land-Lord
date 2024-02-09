import 'dart:async';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';
import '../services/logger_service.dart';
import '../services/theme/theme.dart';

class Helper {
  static Timer? _searchOnStoppedTyping;

  static RxBool blockRequest = false.obs;
  static RxBool isLoading = true.obs;
  
  static void snackBar({String message = 'Snack bar test', String? title, Duration? duration, bool includeDismiss = true, Widget? overrideButton, TextStyle? styleMessage}) =>
      GetSnackBar(
        titleText: title != null ? Text(title, style: styleMessage ?? AppFonts.x14Bold.copyWith(color: kNeutralColor100)) : null,
        message: message,
        duration: duration ?? const Duration(seconds: 3),
        isDismissible: true,
        margin: EdgeInsets.zero,
        backgroundColor: kSecondaryColor,
        snackPosition: SnackPosition.BOTTOM,
        mainButton: overrideButton ?? (includeDismiss ? TextButton(onPressed: Get.back, child: const Text('Dismiss')) : null),
      ).show();

  static Future<void> waitAndExecute(bool Function() condition, Function callback, {Duration? duration}) async {
    while (!condition()) {
      await Future.delayed(duration ?? const Duration(milliseconds: 800), () {});
    }
    callback();
  }

  static bool isNullOrEmpty(String? value) => value == null || value.isEmpty;

  static void onSearchDebounce(void Function() callback, {Duration duration = const Duration(milliseconds: 800)}) {
    if (_searchOnStoppedTyping != null) _searchOnStoppedTyping!.cancel();
    _searchOnStoppedTyping = Timer(duration, callback);
  }

  static final bool isMobile = Get.width < 500 && (GetPlatform.isAndroid || GetPlatform.isIOS);

  static bool isColorDarkEnoughForWhiteText(Color color, {double threshold = 0.55}) {
    assert(threshold >= 0 && threshold <= 1, 'The threshold value should be between 0.0 and 1.0');
    // Calculate the relative luminance of the color
    final double luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    // Determine if the color is dark enough based on a threshold value
    return luminance > threshold;
  }

  static Future<dynamic> openBottomSheet(Widget widget, {double? height, Widget? backgroundWidget}) async => await Get.bottomSheet(
        Material(
          color: backgroundWidget != null ? Colors.transparent : null,
          child: backgroundWidget != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(onTap: Get.back, child: Container(color: Colors.transparent, height: Get.height - (height ?? 0), child: backgroundWidget)),
                    SizedBox(height: height, child: widget),
                  ],
                )
              : SizedBox(height: height, child: widget),
        ),
        isScrollControlled: true,
        enableDrag: true,
        enterBottomSheetDuration: const Duration(milliseconds: 300),
        clipBehavior: Clip.hardEdge,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(RadiusSize.large))),
        ignoreSafeArea: true,
      );

  static String getReadableLanguage(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English'.tr;
      case 'es':
        return 'Spanish';
      case 'fr':
        return 'French'.tr;
      case 'de':
        return 'German';
      case 'ar':
        return 'Arabic';
      // Add more language codes and their readable names as needed
      default:
        return 'Unknown';
    }
  }

  static String getDayFullName(int day) => DateFormat('EEEE').format(DateTime(2023, 5, day));

  static DateTime parseDisplayedDate(String date) => DateFormat('MMM d, h:mm a').parse(date).copyWith(year: DateTime.now().year);

  static AlertDialog buildDialog({
    required Widget child,
    double? width,
    double? height,
    Color backgroundColor = kNeutralColor100,
    double radius = RadiusSize.large,
    EdgeInsets padding = EdgeInsets.zero,
  }) =>
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(radius))),
        backgroundColor: backgroundColor,
        insetPadding: padding,
        contentPadding: padding,
        elevation: 0,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: SizedBox(
            width: width ?? Get.width * 0.8,
            height: height ?? Get.height * 0.8,
            child: child,
          ),
        ),
      );

  static Future<void> launchUrlHelper(String url) async {
    LoggerService.logger!.i('launching: $url');
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  static String encryptPassword(String password) {
    final key = enc.Key.fromUtf8('23557520584123485319BCFAEFEDADEF');
    final iv = enc.IV(Uint8List.fromList(List<int>.filled(16, 0)));
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final encrypted = encrypter.encrypt(password, iv: iv);
    return encrypted.base64;
  }

  static String decryptPassword(String encryptedPassword) {
    final key = enc.Key.fromUtf8('23557520584123485319BCFAEFEDADEF');
    final iv = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(key));
    final decrypted = encrypter.decrypt64(encryptedPassword, iv: iv);
    return decrypted;
  }

  static List<DateTime> getDatesInRange(DateTimeRange range) {
    final days = getDurationInRange(range) + 1;
    return List<DateTime>.generate(days, (index) => range.start.add(Duration(days: index)));
  }

  static int getDurationInRange(DateTimeRange range) {
    if (range.start.isAfter(range.end)) throw ArgumentError('From date cannot be after to date');
    return range.end.difference(range.start).inDays;
  }
}
