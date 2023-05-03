import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persona_calendar/Models/UsersModel.dart';
import 'package:persona_calendar/Screens/Home/Calendar.dart';
import 'package:persona_calendar/Screens/Home/Form/EventForm.dart';
import 'package:persona_calendar/Screens/Home/Form/NotesForm.dart';
import 'package:persona_calendar/Screens/Home/Form/ReminderForm.dart';
import 'package:persona_calendar/Screens/Home/Form/TaskForm.dart';
import 'package:persona_calendar/Services/app_routes.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {

  final UserModel userModel;
  const HomePage({Key? key,required this.userModel}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _eventHovering = false;
  bool _taskHovering = false;
  bool _reminderHovering = false;
  bool _notesHovering = false;

  final config = CalendarDatePicker2WithActionButtonsConfig(
    calendarType: CalendarDatePicker2Type.range,
    disableModePicker: true,
  );

  late DateTime selectedDate;
  List<DateTime?> rangeDatePickerValueWithDefaultValue = [
    DateTime(1999, 5, 6),
    DateTime(1999, 5, 21),
  ];

  List<DateTime?> rangeDatePickerWithActionButtonsWithValue = [
    DateTime.now(),
    DateTime.now(),
  ];

  String getValueText(
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

  @override
  Widget build(BuildContext context) {



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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                Provider.of<UserModel>(context, listen: false).userName,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              child: const Icon(
                Icons.person,
                color: Colors.black,
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Get.toNamed(AppRoutes.MyApp);
              },
            ),
          )
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
                       UserAccountsDrawerHeader(
                        decoration: const BoxDecoration(color: Color(0xff00ADB5)),
                        accountName: Text(
                          widget.userModel.userName,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                        accountEmail: Text(widget.userModel.email,
                            style: const TextStyle(fontWeight: FontWeight.w300)),
                        currentAccountPicture: const CircleAvatar(
                          radius: 4,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: Color(0xff393E46),
                          ),
                        ),
                        currentAccountPictureSize: const Size(50, 50),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          CalendarDatePicker2WithActionButtons(
                            config: config,
                            value: rangeDatePickerWithActionButtonsWithValue,
                            onValueChanged: (dates) => setState(() =>
                                rangeDatePickerWithActionButtonsWithValue =
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
              child: CalendarPage(events: widget.userModel.userEvents,reminders: widget.userModel.userReminder,tasks: widget.userModel.userTasks),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Events(userId: widget.userModel.userId);
                              });
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    "https://cdn0.iconfinder.com/data/icons/time-calendar-2/24/time_event_calendar_add_create-512.png",
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 24,
                              child: AnimatedOpacity(
                                opacity: _eventHovering ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 100),
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: const Text(
                                    'Event',
                                    style: TextStyle(
                                      color: Color(0xff00ADB5),
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onHover: (val) {
                          setState(() {
                            _eventHovering = val;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showDialog(context: context, builder: (context){
                            return TasksForm(userId: widget.userModel.userId);
                          });
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://cdn-icons-png.flaticon.com/512/6109/6109208.png"),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 24,
                              child: AnimatedOpacity(
                                opacity: _taskHovering ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 100),
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: const Text(
                                    'Task',
                                    style: TextStyle(
                                      color: Color(0xff00ADB5),
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onHover: (val) {
                          setState(() {
                            _taskHovering = val;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showDialog(context: context, builder: (context){
                            return NotesForm(userId: widget.userModel.userId);
                          });
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: 36,
                              width: 36,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://cdn0.iconfinder.com/data/icons/online-education-butterscotch-vol-2/512/Student_Notes-512.png"),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 24,
                              child: AnimatedOpacity(
                                opacity: _notesHovering ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 100),
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: const Text(
                                    'Notes',
                                    style: TextStyle(
                                      color: Color(0xff00ADB5),
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onHover: (val) {
                          setState(() {
                            _notesHovering = val;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showDialog(context: context, builder: (context){
                            return ReminderForm(userId: widget.userModel.userId);
                          });
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://cdn-icons-png.flaticon.com/512/1792/1792931.png"),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 24,
                              child: AnimatedOpacity(
                                opacity: _reminderHovering ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 100),
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: const Text(
                                    'Reminder',
                                    style: TextStyle(
                                      color: Color(0xff00ADB5),
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onHover: (val) {
                          setState(() {
                            _reminderHovering = val;
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
