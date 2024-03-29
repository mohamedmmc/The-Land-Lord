import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_land_lord_website/helpers/helper.dart';

import 'repository/location_repository.dart';
import 'repository/property_repository.dart';
import 'services/main_app_service.dart';
import 'services/logger_service.dart';
import 'services/shared_preferences.dart';
import 'views/properties/properties_controller.dart';
import 'views/properties/properties_screen.dart';
import 'views/property_detail/components/all_photos_screen.dart';
import 'views/property_detail/property_detail_controller.dart';
import 'views/property_detail/property_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Land Lord',
      logWriterCallback: (text, {isError = false}) => isError ? LoggerService.logger?.e(text) : LoggerService.logger?.i(text),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus},
      ),
      // localizationsDelegates: const <LocalizationsDelegate>[
      //   GlobalCupertinoLocalizations.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      // ],
      // supportedLocales: supportedLocal,
      // translations: AppLocalization(),
      // locale: Locale(_languageCode, _countryCode),
      fallbackLocale: const Locale('en', 'US'),
      theme: ThemeData(primarySwatch: Colors.cyan),
      initialBinding: InitialBindings(),
      initialRoute: PropertiesScreen.routeName,
      navigatorObservers: <NavigatorObserver>[MyNavigatorObserver()],
      getPages: <GetPage>[
        GetPage(
          name: PropertiesScreen.routeName,
          page: () => const PropertiesScreen(),
        ),
        GetPage(
          name: PropertyDetailScreen.routeName,
          page: () => const PropertyDetailScreen(),
          binding: BindingsBuilder.put(() => PropertyDetailController()),
        ),
        GetPage(
          name: AllPhotoScreen.routeName,
          page: () {
            if (Get.arguments?['images'] == null) {
              Helper.waitAndExecute(() => SharedPreferencesService.find.isReady, () {
                final idProperty = SharedPreferencesService.find.get('idProperty');
                WidgetsBinding.instance.addPostFrameCallback((_) => Get.toNamed(PropertyDetailScreen.routeName, arguments: {'idProperty': idProperty}));
              });
              return const PropertiesScreen();
            }
            return AllPhotoScreen(images: Get.arguments['images']);
          },
        ),
        // GetPage(
        //   name: BookingDetailsScreen.routeName,
        //   page: () => const BookingDetailsScreen(),
        //   // binding: BindingsBuilder.put(() => PropertiesController()),
        // ),
        // GoRoute(
        //   name: 'booking-details',
        //   path: '/booking-details',
        //   pageBuilder: (context, state) => CustomTransitionPage<void>(
        //     key: state.pageKey,
        //     opaque: false,
        //     barrierColor: appBlack.withOpacity(0.5),
        //     transitionDuration: const Duration(milliseconds: 300),
        //     transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
        //     child: BookingDetailsScreen(),
        //   ),
        // ),
      ],
    );
  }
}

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(SharedPreferencesService(), permanent: true);
    Get.put(LoggerService(), permanent: true);
    Get.put(LocationRepository(), permanent: true);
    Get.put(PropertyRepository(), permanent: true);
    Get.put<MainAppServie>(MainAppServie(), permanent: true);
    Get.put<PropertiesController>(PropertiesController(), permanent: true);
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  @override
  Future<void> didPop(Route<dynamic> route, Route<dynamic>? previousRoute) async {
    // if (previousRoute?.settings.name == RoleDetails.routeName) await TaskManagementController.find.initMyRoles();
  }
}
