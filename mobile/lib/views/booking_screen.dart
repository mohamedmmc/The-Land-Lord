import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_land_lord_website/utils/constants/sizes.dart';
import '../utils/enums/booking_steps.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/constants.dart';
import '../widgets/select_date_widget.dart';
import '../widgets/select_destination_widget.dart';
import '../widgets/select_guests_widget.dart';

class BookingDetailsScreen extends StatefulWidget {
  static const String routeName = '/booking-details';

  const BookingDetailsScreen({super.key});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  var step = BookingStep.selectDate;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
      child: Scaffold(
        backgroundColor: kNeutralColor100.withOpacity(0.5),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: Get.back,
            icon: const Icon(Icons.close),
          ),
          actions: const [SizedBox(width: 48.0)],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: Paddings.large, right: Paddings.large, top: Paddings.large),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      step = BookingStep.selectDestination;
                    });
                  },
                  child: Hero(
                    tag: 'search',
                    child: SelectDestinationWidget(step: step),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      step = BookingStep.selectDate;
                    });
                  },
                  child: SelectDateWidget(step: step),
                ),
                (step == BookingStep.selectDate)
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            step = BookingStep.selectGuests;
                          });
                        },
                        child: SelectGuestsWidget(step: step),
                      ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: (step == BookingStep.selectDate)
            ? null
            : BottomAppBar(
                padding: const EdgeInsets.symmetric(horizontal: Paddings.large),
                notchMargin: 0,
                color: Colors.white,
                surfaceTintColor: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // if (step == BookingStep.selectDestination) {
                        //   setState(() {
                        //     step = BookingStep.selectGuests;
                        //   });
                        // } else {
                        //   setState(() {
                        //     step = BookingStep.selectDestination;
                        //   });
                        // }
                      },
                      child: Text(
                        'Clear all',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: kErrorColor,
                        minimumSize: const Size(100, 56.0),
                        shape: RoundedRectangleBorder(borderRadius: smallRadius),
                      ),
                      icon: const Icon(Icons.search),
                      label: const Text('Search'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
