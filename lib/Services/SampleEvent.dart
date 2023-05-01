import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';

class SampleEvent {
  final String eventName;
  final DateTime eventDate;
  final Color eventBackgroundColor;
  final TextStyle eventTextStyle;

  SampleEvent({
    required this.eventName,
    required this.eventDate,
    required this.eventBackgroundColor,
    required this.eventTextStyle,
  });
}

List<CalendarEvent> sampleEvents() {
  return [
    CalendarEvent(
      eventName: 'Meeting with John',
      eventDate: DateTime(2023, 4, 3),
      eventBackgroundColor: Colors.red.withOpacity(0.3),
      eventTextStyle: TextStyle(color: Colors.white),
    ),
    CalendarEvent(
      eventName: 'Lunch with Jane',
      eventDate: DateTime(2023, 5, 8),
      eventBackgroundColor: Colors.blue.withOpacity(0.3),
      eventTextStyle: TextStyle(color: Colors.white),
    ),
    CalendarEvent(
      eventName: 'Conference call',
      eventDate: DateTime(2023, 5, 15),
      eventBackgroundColor: Colors.green.withOpacity(0.3),
      eventTextStyle: TextStyle(color: Colors.white),
    ),
  ];
}
