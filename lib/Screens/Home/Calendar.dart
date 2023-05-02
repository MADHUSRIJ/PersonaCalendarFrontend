import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:persona_calendar/Models/EventsModel.dart';
import 'package:persona_calendar/Models/ReminderModel.dart';
import 'package:persona_calendar/Models/TasksModel.dart';
import 'package:persona_calendar/Services/MyCalendarDataSource.dart';
import 'package:persona_calendar/sizeConfig.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  final List<EventsModel> events;
  final List<RemainderModel> reminders;
  final List<TaskModel> tasks;
  const CalendarPage({Key? key, required this.events, required this.reminders, required this.tasks}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  late MyCalendarDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    /*_dataSource = MyCalendarDataSource(
      events: widget.events,
      reminders: widget.reminders,
      tasks: widget.tasks,
    );*/
  }

  Map<String, CalendarView> view = {
    "Day": CalendarView.day,
    "Month": CalendarView.month,
    "Week": CalendarView.week,
    "Schedule": CalendarView.schedule
  };
  String? dropdownValue = 'Day';
  CalendarView current = CalendarView.day;
  final calendarController = CalendarController();

  String headerText = DateFormat('MMM, yyyy').format(DateTime.now());


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
                  Expanded(child: Text(headerText,style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500),)),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.width! * 4,),
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.width! * 2,
                      ),
                      height: SizeConfig.height! * 8,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Colors.grey.shade500),
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
                ],
              ),
            )),
        Expanded(
          flex: 7,
            child: SfCalendar(
          controller: calendarController,
          view: current,
          headerHeight: 0,
          onViewChanged: (details){
            int index = 0;
            if(current == CalendarView.month){
              index = 6;
            }
            if(current == CalendarView.week){
              index = 2;
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                headerText = DateFormat("MMM, yyyy").format(details.visibleDates[index]);
              });
            });
          },
          onTap: (details) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(details.date.toString()),
                  );
                });
          },
          monthViewSettings: const MonthViewSettings(
            navigationDirection: MonthNavigationDirection.horizontal,
            dayFormat: 'EEE',
          ),
          initialDisplayDate: DateTime.now(),
        ))
      ],
    );
  }
}
