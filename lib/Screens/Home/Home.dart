import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persona_calendar/Models/EventsModel.dart';
import 'package:persona_calendar/Models/NotesModel.dart';
import 'package:persona_calendar/Models/ReminderModel.dart';
import 'package:persona_calendar/Models/TasksModel.dart';
import 'package:persona_calendar/Models/UsersModel.dart';
import 'package:persona_calendar/Screens/Home/Calendar.dart';
import 'package:persona_calendar/Screens/Home/Form/EventForm.dart';
import 'package:persona_calendar/Screens/Home/Form/NotesForm.dart';
import 'package:persona_calendar/Screens/Home/Form/ReminderForm.dart';
import 'package:persona_calendar/Screens/Home/Form/TaskForm.dart';
import 'package:persona_calendar/Services/app_routes.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final String userId;
  final List<EventsModel> events;
  final List<TaskModel> tasks;
  final List<RemainderModel> reminder;
  final List<NotesModel> notes;

  const HomePage({Key? key, required this.userId, required this.events, required this.tasks, required this.reminder, required this.notes}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    bool _hovering = false;


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
              child: CalendarPage(events: widget.events,reminders: widget.reminder,tasks: widget.tasks),
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
                                return Events(userId: int.parse(widget.userId));
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
                              top: -20,
                              child: AnimatedOpacity(
                                opacity: 0.0,
                                duration: const Duration(milliseconds: 100),
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: const Text(
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
                        onTap: () {
                          showDialog(context: context, builder: (context){
                            return TasksForm(userId: int.parse(widget.userId));
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
                              top: -20,
                              child: AnimatedOpacity(
                                opacity: _hovering ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 100),
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: const Text(
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
                        onTap: () {
                          showDialog(context: context, builder: (context){
                            return NotesForm(userId: int.parse(widget.userId));
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
                              top: -20,
                              child: AnimatedOpacity(
                                opacity: _hovering ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 100),
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: const Text(
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
                        onTap: () {
                          showDialog(context: context, builder: (context){
                            return ReminderForm(userId: int.parse(widget.userId));
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
                              top: -20,
                              child: AnimatedOpacity(
                                opacity: _hovering ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 100),
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: const Text(
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
