import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cell_calendar/cell_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:persona_calendar/Animation/animation.dart';
import 'package:persona_calendar/Models/UsersModel.dart';
import 'package:persona_calendar/Screens/Home/Form/EventForm.dart';
import 'package:persona_calendar/Screens/Home/Form/NotesForm.dart';
import 'package:persona_calendar/Screens/Home/Form/ReminderForm.dart';
import 'package:persona_calendar/Screens/Home/Form/TaskForm.dart';
import 'package:persona_calendar/Services/SampleEvent.dart';
import 'package:persona_calendar/Services/app_routes.dart';
import 'package:persona_calendar/sizeConfig.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final events = sampleEvents();
    final cellCalendarPageController = CellCalendarPageController();
    bool _hovering = false;

    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
      disableModePicker: true,
    );

    late DateTime _selectedDate;
    List<DateTime?> _rangeDatePickerValueWithDefaultValue = [
      DateTime(1999, 5, 6),
      DateTime(1999, 5, 21),
    ];

    List<DateTime?> _rangeDatePickerWithActionButtonsWithValue = [
      DateTime.now(),
      DateTime.now(),
    ];

    String _getValueText(
      CalendarDatePicker2Type datePickerType,
      List<DateTime?> values,
    ) {
      values =
          values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
      var valueText = (values.isNotEmpty ? values[0] : null)
          .toString()
          .replaceAll('00:00:00.000', '');

      if (datePickerType == CalendarDatePicker2Type.multi) {
        valueText = values.isNotEmpty
            ? values
                .map((v) => v.toString().replaceAll('00:00:00.000', ''))
                .join(', ')
            : 'null';
      } else if (datePickerType == CalendarDatePicker2Type.range) {
        if (values.isNotEmpty) {
          final startDate = values[0].toString().replaceAll('00:00:00.000', '');
          final endDate = values.length > 1
              ? values[1].toString().replaceAll('00:00:00.000', '')
              : 'null';
          valueText = '$startDate to $endDate';
        } else {
          return 'null';
        }
      }

      return valueText;
    }



    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
            children: <TextSpan>[
              TextSpan(
                  text: 'Persona', style: TextStyle(color: Color(0xff00ADB5))),
              TextSpan(text: ' Calendar'),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_left, color: Colors.black),
            onPressed: () {
              final currentMonthIndex = cellCalendarPageController.page!;
              final previousMonthIndex = currentMonthIndex - 0.1;
              print(cellCalendarPageController.page!);
              print(currentMonthIndex);
              print(previousMonthIndex);
              print("Hello");
              cellCalendarPageController.animateTo(
                1130,
                curve: Curves.linear,
                duration: const Duration(milliseconds: 300),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_right, color: Colors.black),
            onPressed: () {
              cellCalendarPageController.nextPage(
                curve: Curves.linear,
                duration: const Duration(milliseconds: 300),
              );
            },
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Container(
            alignment: Alignment.center,
            child: Text(Provider.of<UserModel>(context,listen: false).userName,style: TextStyle(color: Colors.black),),
          ),),
          Padding(padding: EdgeInsets.symmetric(horizontal: 16),child:  GestureDetector(
            child: const Icon(
              Icons.person,
              color: Colors.black,
            ),
            onTap: (){
              FirebaseAuth.instance.signOut();
              Get.toNamed(AppRoutes.MyApp);
            },
          ),)

        ],
      ),
      body: Row(
        children: [
          Expanded(
              flex: 5,
              child: SizedBox(
                width: 250,
                child: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const UserAccountsDrawerHeader(
                        decoration: BoxDecoration(color: Color(0xff00ADB5)),
                        accountName: Text(
                          'John Doe',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                        accountEmail: Text('john.doe@example.com',
                            style: TextStyle(fontWeight: FontWeight.w300)),
                        currentAccountPicture: CircleAvatar(
                          radius: 4,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: Color(0xff393E46),
                          ),
                        ),
                        currentAccountPictureSize: Size(50, 50),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          CalendarDatePicker2WithActionButtons(
                            config: config,
                            value: _rangeDatePickerWithActionButtonsWithValue,
                            onValueChanged: (dates) => setState(() =>
                                _rangeDatePickerWithActionButtonsWithValue =
                                    dates),
                          ),
                          const SizedBox(height: 25),
                        ],
                      )
                    ],
                  ),
                ),
              )),
          Expanded(
            flex: 15,
            child: Center(
              child: CellCalendar(
                cellCalendarPageController: cellCalendarPageController,
                events: events,
                daysOfTheWeekBuilder: (dayIndex) {
                  final labels = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4.0, top: 8),
                    child: Text(
                      labels[dayIndex],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
                monthYearLabelBuilder: (datetime) {
                  final year = datetime!.year.toString();
                  final month = datetime.month.monthName;
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Text(
                          "$month  $year",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xff00ADB5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            cellCalendarPageController.animateToDate(
                              DateTime.now(),
                              curve: Curves.linear,
                              duration: const Duration(milliseconds: 300),
                            );
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              alignment: Alignment.center,
                              height: SizeConfig.height! * 6,
                              padding: EdgeInsets.symmetric(horizontal: 16),

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color(0xff00ADB5),
                              ),
                              child: Text("Today",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                onCellTapped: (date) {
                  final eventsOnTheDate = events.where((event) {
                    final eventDate = event.eventDate;
                    return eventDate.year == date.year &&
                        eventDate.month == date.month &&
                        eventDate.day == date.day;
                  }).toList();
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: Text("${date.month.monthName} ${date.day}"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: eventsOnTheDate
                                  .map(
                                    (event) => Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(4),
                                      margin: const EdgeInsets.only(bottom: 12),
                                      color: event.eventBackgroundColor,
                                      child: Text(
                                        event.eventName,
                                        style: event.eventTextStyle,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ));
                },
                onPageChanged: (firstDate, lastDate) {
                  /// Called when the page was changed
                  /// Fetch additional events by using the range between [firstDate] and [lastDate] if you want
                },
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async{
                          await EventForm.createEvent(context);
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    "https://cdn0.iconfinder.com/data/icons/time-calendar-2/24/time_event_calendar_add_create-512.png",
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: -20,
                              child: AnimatedOpacity(
                                opacity: _hovering ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 100),
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Text(
                                    'Click to add event',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onHover: (val) {
                          setState(() {
                            _hovering = val;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          TaskForm.createTask(context);
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://cdn-icons-png.flaticon.com/512/6109/6109208.png"),
                                ),
                              ),
                            ),
                            Positioned(
                              top: -20,
                              child: AnimatedOpacity(
                                opacity: _hovering ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 100),
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Text(
                                    'Click to add tasks',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onHover: (val) {
                          setState(() {
                            _hovering = val;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          NotesForm.createNote(context);
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://cdn0.iconfinder.com/data/icons/online-education-butterscotch-vol-2/512/Student_Notes-512.png"),
                                ),
                              ),
                            ),
                            Positioned(
                              top: -20,
                              child: AnimatedOpacity(
                                opacity: _hovering ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 100),
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Text(
                                    'Click to add notes',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onHover: (val) {
                          setState(() {
                            _hovering = val;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: (){
                         ReminderForm.createReminder(context);
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://cdn-icons-png.flaticon.com/512/1792/1792931.png"),
                                ),
                              ),
                            ),
                            Positioned(
                              top: -20,
                              child: AnimatedOpacity(
                                opacity: _hovering ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 100),
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Text(
                                    'Click to add reminder',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onHover: (val) {
                          setState(() {
                            _hovering = val;
                          });
                        },
                      ),
                    ),
                    Expanded(flex: 3, child: Container()),
                  ],
                ),
              ))
        ],
      ),
    ));
  }









}
