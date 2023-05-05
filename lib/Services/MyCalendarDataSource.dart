import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persona_calendar/Models/EventsModel.dart';
import 'package:persona_calendar/Models/ReminderModel.dart';
import 'package:persona_calendar/Models/TasksModel.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyCalendarDataSource extends CalendarDataSource {
  MyCalendarDataSource({
    required List<EventsModel> events,
    required List<RemainderModel> reminders,
    required List<TaskModel> tasks,
  }) {
    appointments = <Appointment>[];
    _addEvents(events);
    _addReminders(reminders);
    _addTasks(tasks);
  }

  void _addEvents(List<EventsModel> events) {
    for (final event in events) {
      appointments?.add(Appointment(
        startTime: DateTime.parse("${event.startDate} ${event.startTime}"),
        endTime: DateTime.parse("${event.endDate} ${event.endTime}"),
        subject: event.eventTitle,
        notes: event.description ?? '',
        location: event.location ?? '',
        color: Colors.blue,
      ));
    }
  }



  void _addReminders(List<RemainderModel> reminders) {
    for (final reminder in reminders) {
      final dateString = reminder.remainderDate;
      final timeString = reminder.remainderTime;
      if (dateString != null) {
        final date = DateTime.parse("$dateString $timeString");

        appointments?.add(Appointment(
          startTime: date,
          endTime: date.add(Duration(minutes: 30)),
          subject: reminder.description,
          notes: '',
          color: Colors.orange,
        ));
      }
    }
  }

  void _addTasks(List<TaskModel> tasks) {
    for (final task in tasks) {
      appointments?.add(Appointment(
        startTime: DateTime.parse("${task.taskDate} ${task.taskTime}"),
        endTime: DateTime.parse("${task.taskDate} ${task.taskTime}").add(Duration(minutes: 30)),
        subject: task.taskTitle,
        notes: task.description ?? '',
        color: Colors.red,
      ));
    }
  }
}
