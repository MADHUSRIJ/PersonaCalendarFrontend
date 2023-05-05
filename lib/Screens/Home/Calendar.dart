import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter_to_pdf/flutter_to_pdf.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:persona_calendar/Models/EventsModel.dart';
import 'package:persona_calendar/Models/ReminderModel.dart';
import 'package:persona_calendar/Models/TasksModel.dart';
import 'package:persona_calendar/Services/MyCalendarDataSource.dart';
import 'package:persona_calendar/sizeConfig.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  final List<EventsModel> events;
  final List<RemainderModel> reminders;
  final List<TaskModel> tasks;
  const CalendarPage(
      {Key? key,
      required this.events,
      required this.reminders,
      required this.tasks})
      : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late MyCalendarDataSource _dataSource;
  final ScreenshotController screenshotController = ScreenshotController();

  Uint8List? bytes;

  Future saveImage(Uint8List bytes) async {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..download = 'image.png'
      ..style.display = 'none';
    html.document.body!.children.add(anchor);
    anchor.click();
    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  Future<void> _captureAndConvertToPdf() async {
    final Uint8List? imageBytes = await screenshotController.capture();

    if (imageBytes == null) {
      return;
    }

    saveImage(imageBytes);
  }

  final controller = ScreenshotController();
  List<TaskModel> tasks = [];
  @override
  void initState() {
    super.initState();
    _dataSource = MyCalendarDataSource(
      events: widget.events,
      reminders: widget.reminders,
      tasks: widget.tasks,
    );
  }

  Map<String, CalendarView> view = {
    "Day": CalendarView.day,
    "Month": CalendarView.month,
    "Week": CalendarView.week,
    "Schedule": CalendarView.schedule
  };
  String? dropdownValue = 'Month';
  CalendarView current = CalendarView.month;
  final calendarController = CalendarController();

  String headerText = DateFormat('MMM, yyyy').format(DateTime.now());

  final ExportDelegate exportDelegate = ExportDelegate();


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: Container(
                color: Colors.transparent,
                child: Text(
                  headerText,
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )),
              const Expanded(
                flex: 2,
                  child: SizedBox()),
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.width! * 4,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.width! * 2,
                  ),
                  height: SizeConfig.height! * 8,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border:
                          Border.all(width: 0.5, color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButton<String>(
                    hint: const Text("Calendar Type"),
                    value: dropdownValue,
                    onChanged: (newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                        current = view[dropdownValue]!;
                        calendarController.view = current;
                      });
                    },
                    dropdownColor: Colors.white,
                    elevation: 0,
                    items: <String>['Day', 'Month', 'Week', 'Schedule']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Expanded(
                  child: GestureDetector(
                onTap: () async {
                  await _captureAndConvertToPdf();
                },
                child: Container(
                    color: Colors.transparent,
                    child:  Text(
                      "Save",
                      style: GoogleFonts.poppins(color: Color(0xff00ADB5)),
                    )),
              )),
            ],
          ),
        )),
        Expanded(
            flex: 7,
            child: Screenshot(
                controller: screenshotController,
                child: SfCalendar(
                  controller: calendarController,
                  dataSource: _dataSource,
                  view: current,
                  headerHeight: 0,
                  onViewChanged: (details) {
                    int index = 0;
                    if (current == CalendarView.month) {
                      index = 6;
                    }
                    if (current == CalendarView.week) {
                      index = 2;
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        headerText = DateFormat("MMM, yyyy")
                            .format(details.visibleDates[index]);
                      });
                    });
                  },
                  onTap: (details) {},
                  appointmentBuilder: (context, calendarAppointmentDetails) {
                    final details = calendarAppointmentDetails.appointments;

                    for (var appointment in details) {
                      String startTime =
                          DateFormat('hh:mm a').format(appointment.startTime);
                      String endTime =
                          DateFormat('hh:mm a').format(appointment.endTime);

                      // Check if appointment duration is greater than 24 hours
                      bool isMultiDay = DateTime.parse(DateFormat('yyyy-MM-dd')
                                  .format(appointment.endTime))
                              .difference(DateTime.parse(
                                  DateFormat('yyyy-MM-dd')
                                      .format(appointment.startTime)))
                              .inHours >=
                          24;
                      String appointmentSubject = appointment.subject;

                      // Modify appointment subject if it is multi-day
                      if (isMultiDay) {
                        int dayIndex = DateTime.parse(DateFormat('yyyy-MM-dd')
                                    .format(appointment.endTime))
                                .difference(DateTime.parse(
                                    DateFormat('yyyy-MM-dd')
                                        .format(appointment.startTime)))
                                .inDays +
                            1;

                        int currentDay = DateTime.parse(DateFormat('yyyy-MM-dd')
                                    .format(calendarAppointmentDetails.date))
                                .difference(DateTime.parse(
                                    DateFormat('yyyy-MM-dd')
                                        .format(appointment.startTime)))
                                .inDays +
                            1;

                        appointmentSubject += " Day ($currentDay/$dayIndex)";
                      }

                      if (appointment.endTime.isBefore(DateTime.now())) {
                        // Appointment has ended
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: appointment.color),
                            borderRadius: BorderRadius.circular(2),
                            color: appointment.color,
                          ),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    appointmentSubject,
                                    style:  GoogleFonts.poppins(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.white,fontSize: 12),
                                  ),
                                ),
                                current == CalendarView.day ||
                                        isMultiDay ||
                                        current == CalendarView.week
                                    ? Container()
                                    : Expanded(
                                        child: Text(
                                        "$startTime - $endTime",
                                        style:  GoogleFonts.poppins(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.white),
                                      ))
                              ]),
                        );
                      } else {
                        // Appointment is ongoing or in the future
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: appointment.color),
                            borderRadius: BorderRadius.circular(2),
                            color: appointment.color,
                          ),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  appointmentSubject,
                                  style:  GoogleFonts.poppins(color: Colors.white,fontSize: 12),
                                ),
                              ),
                              current == CalendarView.day ||
                                      isMultiDay ||
                                      current == CalendarView.week
                                  ? Container()
                                  : Expanded(
                                      child: Text(
                                        "$startTime - $endTime",
                                        style:  GoogleFonts.poppins(color: Colors.white),
                                      ),
                                    )
                            ],
                          ),
                        );
                      }
                    }
                    return const SizedBox();
                  },
                  monthViewSettings: const MonthViewSettings(
                    navigationDirection: MonthNavigationDirection.horizontal,
                    showAgenda: true,
                    dayFormat: 'EEE',
                  ),
                  scheduleViewSettings: const ScheduleViewSettings(),
                  timeSlotViewSettings: const TimeSlotViewSettings(
                    timeInterval: Duration(minutes: 60),
                    timeFormat: 'h:mm a',
                  ),
                  initialDisplayDate: DateTime.now(),
                  initialSelectedDate: DateTime.now(),
                )))
      ],
    );
  }
}
