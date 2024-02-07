import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:the_land_lord_website/utils/constants/colors.dart';

enum CalendarOptions { year, month, week, day }

class AppCalendar extends StatelessWidget {
  final DateTime? date;
  final bool isDoubleCalendar;
  final List<DateTime>? blackoutDates;
  final PickerDateRange? initialSelectedRange;
  final void Function(DateRangePickerSelectionChangedArgs)? onSelectionChanged;

  const AppCalendar({
    super.key,
    this.date,
    this.onSelectionChanged,
    this.initialSelectedRange,
    this.blackoutDates,
    this.isDoubleCalendar = true,
  });

  @override
  Widget build(BuildContext context) {
    return SfDateRangePicker(
      onSelectionChanged: onSelectionChanged,
      selectionMode: DateRangePickerSelectionMode.range,
      monthViewSettings: DateRangePickerMonthViewSettings(blackoutDates: blackoutDates ?? []),
      monthCellStyle: const DateRangePickerMonthCellStyle(
        blackoutDateTextStyle: TextStyle(color: kErrorColor, decoration: TextDecoration.lineThrough),
      ),
      enableMultiView: isDoubleCalendar,
      minDate: DateTime.now(),
      initialDisplayDate: date ?? DateTime.now(),
      initialSelectedRange: initialSelectedRange,
    );
  }
}
