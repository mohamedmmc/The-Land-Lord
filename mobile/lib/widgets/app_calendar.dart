import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

enum CalendarOptions { year, month, week, day }

class AppCalendar extends StatefulWidget {
  final DateTime? date;
  final void Function(DateRangePickerSelectionChangedArgs)? onSelectionChanged;

  const AppCalendar({super.key, this.date, this.onSelectionChanged});

  @override
  State<AppCalendar> createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  @override
  Widget build(BuildContext context) {
    return SfDateRangePicker(
      onSelectionChanged: widget.onSelectionChanged,
      selectionMode: DateRangePickerSelectionMode.range,
      enableMultiView: true,
      minDate: DateTime.now(),
      initialDisplayDate: widget.date ?? DateTime.now(),
    );
  }
}
