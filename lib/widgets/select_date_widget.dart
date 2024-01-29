import 'package:the_land_lord_website/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:the_land_lord_website/utils/constants/sizes.dart';
import '../utils/booking_steps.dart';
import 'app_calendar.dart';

class SelectDateWidget extends StatelessWidget {
  final BookingStep step;
  final void Function(DateRangePickerSelectionChangedArgs)? onSelectionChanged;

  const SelectDateWidget({super.key, required this.step, this.onSelectionChanged});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    var expandedHeight = size.height - 112 - 60 - 32 - 20;
    return Card(
      elevation: 0.0,
      clipBehavior: Clip.antiAlias,
      child: AnimatedContainer(
          height: step == BookingStep.selectDate ? expandedHeight : 60,
          width: double.infinity,
          color: kNeutralColor100,
          padding: const EdgeInsets.symmetric(vertical: Paddings.large, horizontal: Paddings.large),
          duration: const Duration(milliseconds: 300),
          child: step == BookingStep.selectDate
              ? AppCalendar(onSelectionChanged: onSelectionChanged).animate(delay: const Duration(milliseconds: 300)).fadeIn(
                    duration: const Duration(milliseconds: 300),
                  )
              // Could be needed in mobile version
              // Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const AppCalendar(),
              //       const Spacer(),
              //       const Divider(),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           TextButton(
              //             onPressed: () {},
              //             child: const Text('Skip'),
              //           ),
              //           FilledButton(
              //             onPressed: () {},
              //             style: FilledButton.styleFrom(
              //               backgroundColor: appRed,
              //               minimumSize: const Size(120, 48),
              //               shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(8.0),
              //               ),
              //             ),
              //             child: const Text('Next'),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ).animate(delay: const Duration(milliseconds: 300)).fadeIn(duration: const Duration(milliseconds: 300))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'When',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'I\'m flexible',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
    );
  }
}
