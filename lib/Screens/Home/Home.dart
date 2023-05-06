import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persona_calendar/Models/UsersModel.dart';
import 'package:persona_calendar/Screens/Home/Calendar.dart';
import 'package:persona_calendar/Screens/Home/Form/EventForm.dart';
import 'package:persona_calendar/Screens/Home/Form/NotesForm.dart';
import 'package:persona_calendar/Screens/Home/Form/ReminderForm.dart';
import 'package:persona_calendar/Screens/Home/Form/TaskForm.dart';
import 'package:persona_calendar/Services/app_routes.dart';
import 'package:persona_calendar/sizeConfig.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  const HomePage({Key? key, required this.userModel}) : super(key: key);

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

  TextEditingController search = TextEditingController();

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

  List<bool> notesHoverList = [];
  List<bool> eventsHoverList = [];
  List<bool> taskHoverList = [];
  List<bool> reminderHoverList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notesHoverList =
        List.generate(widget.userModel.userNotes.length, (index) => false);
    eventsHoverList =
        List.generate(widget.userModel.userEvents.length, (index) => false);
    taskHoverList =
        List.generate(widget.userModel.userTasks.length, (index) => false);
    reminderHoverList =
        List.generate(widget.userModel.userReminder.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Row(
        children: [
          Expanded(
              flex: 4,
              child: SizedBox(
                width: 250,
                child: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        height: 44,
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500, fontSize: 24),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Persona',
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xff00ADB5))),
                              const TextSpan(text: ' Calendar'),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration:
                            const BoxDecoration(color: Color(0xff00ADB5)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userModel.userName,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(widget.userModel.email,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.5, color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        child: TextFormField(
                          controller: search,
                          decoration: InputDecoration(
                              hintText: "Search",
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: SizeConfig.height! * 2.3,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                              errorMaxLines: 1,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {});
                                },
                                icon: const Icon(Icons.search_outlined),
                                color: Colors.grey,
                              ),
                              border: InputBorder.none),
                          style: GoogleFonts.poppins(
                              fontSize: SizeConfig.height! * 2,
                              color: Colors.black),
                        ),
                      ),
                      search.text == ""
                          ? Container()
                          : Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                children: [
                                  eventSearchContainer(),
                                  taskSearchContainer(),
                                  reminderSearchContainer(),
                                ],
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Notes",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff00ADB5)),
                            ),
                            SizedBox(
                              height: SizeConfig.height! * 90,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      //print("Hmm");
                                    },
                                    onHover: (value) {
                                      setState(() {
                                        notesHoverList[index] = value;
                                      });
                                    },
                                    child: Container(
                                      height: 240,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade50,
                                            offset: const Offset(
                                              1.0,
                                              1.0,
                                            ),
                                            blurRadius: 6.0,
                                            spreadRadius: 2.0,
                                          ),
                                          BoxShadow(
                                            color: Colors.grey.shade50,
                                            offset: const Offset(
                                              1.0,
                                              1.0,
                                            ),
                                            blurRadius: 6.0,
                                            spreadRadius: 2.0,
                                          ),
                                        ],
                                        border: Border.all(
                                            color: Colors.grey.shade200,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                              child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                    widget
                                                        .userModel
                                                        .userNotes[index]
                                                        .notesTitle!,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    )),
                                              ),
                                              Expanded(
                                                  child: AnimatedOpacity(
                                                      opacity:
                                                          notesHoverList[index]
                                                              ? 1.0
                                                              : 0.0,
                                                      duration: const Duration(
                                                          milliseconds: 100),
                                                      child: PopupMenuButton<
                                                          String>(
                                                        itemBuilder:
                                                            (context) => [
                                                          PopupMenuItem(
                                                            value: 'edit',
                                                            child: Text(
                                                              'Edit',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                      fontSize:
                                                                          12),
                                                            ),
                                                          ),
                                                          PopupMenuItem(
                                                            value: 'delete',
                                                            child: Text(
                                                              'Delete',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                      fontSize:
                                                                          12),
                                                            ),
                                                          ),
                                                          PopupMenuItem(
                                                            value: 'share',
                                                            child: Text(
                                                              'Share',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                      fontSize:
                                                                          12),
                                                            ),
                                                          ),
                                                        ],
                                                        onSelected: (value) {
                                                          // handle menu item selection here
                                                          print(
                                                              'Selected: $value');
                                                        },
                                                        child: const Icon(
                                                          Icons.more_vert,
                                                          color:
                                                              Color(0xff00ADB5),
                                                          size: 16,
                                                        ),
                                                      )))
                                            ],
                                          )),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                                widget
                                                    .userModel
                                                    .userNotes[index]
                                                    .description!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: widget.userModel.userNotes.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Expanded(
            flex: 15,
            child: Center(
              child: CalendarPage(
                  events: widget.userModel.userEvents,
                  reminders: widget.userModel.userReminder,
                  tasks: widget.userModel.userTasks),
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
                        child: optionsWidget(
                            "https://cdn0.iconfinder.com/data/icons/time-calendar-2/24/time_event_calendar_add_create-512.png",
                            _eventHovering,
                            "Event"),
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
                          showDialog(
                              context: context,
                              builder: (context) {
                                return TasksForm(
                                    userId: widget.userModel.userId);
                              });
                        },
                        child: optionsWidget(
                            "https://cdn-icons-png.flaticon.com/512/6109/6109208.png",
                            _taskHovering,
                            "Task"),
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
                          showDialog(
                              context: context,
                              builder: (context) {
                                return NotesForm(
                                    userId: widget.userModel.userId);
                              });
                        },
                        child: optionsWidget(
                            "https://cdn0.iconfinder.com/data/icons/online-education-butterscotch-vol-2/512/Student_Notes-512.png",
                            _notesHovering,
                            "Notes"),
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
                          showDialog(
                              context: context,
                              builder: (context) {
                                return ReminderForm(
                                    userId: widget.userModel.userId);
                              });
                        },
                        child: optionsWidget(
                            "https://cdn-icons-png.flaticon.com/512/1792/1792931.png",
                            _reminderHovering,
                            "Reminder"),
                        onHover: (val) {
                          setState(() {
                            _reminderHovering = val;
                          });
                        },
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: Padding(
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
                        )),
                  ],
                ),
              ))
        ],
      ),
    ));
  }

  Stack optionsWidget(String image, bool hoveringBool, String optionName) {
    return Stack(
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                image,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 24,
          child: AnimatedOpacity(
            opacity: hoveringBool ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                optionName,
                style: GoogleFonts.poppins(
                  color: const Color(0xff00ADB5),
                  fontSize: 10.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Visibility reminderSearchContainer() {
    return Visibility(
      visible: widget.userModel.userReminder.any((reminder) =>
          (reminder.description
              .toLowerCase()
              .contains(search.text.toLowerCase())) &&
          (DateTime.parse(
                  "${reminder.remainderDate} ${reminder.remainderTime.substring(0, 5)}")
              .isAfter(DateTime.now()))),
      child: LayoutBuilder(
        builder: (context, constraints) => SizedBox(
          height: 200,
          child: ListView.builder(
            itemBuilder: (context, index) {
              bool reminderContains = (widget
                      .userModel.userReminder[index].description
                      .toLowerCase()
                      .contains(search.text.toLowerCase())) &&
                  (DateTime.parse(
                          "${widget.userModel.userReminder[index].remainderDate} ${widget.userModel.userReminder[index].remainderTime.substring(0, 5)}")
                      .isAfter(DateTime.now()));
              return reminderContains
                  ? InkWell(
                      onTap: () {
                        //print("Hmm");
                      },
                      onHover: (value) {
                        setState(() {
                          reminderHoverList[index] = value;
                        });
                      },
                      child: Container(
                        height: 100,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          border:
                              Border.all(color: Colors.grey.shade200, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text("Reminder",
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                ),
                                Expanded(
                                    child: AnimatedOpacity(
                                  opacity: reminderHoverList[index] ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 100),
                                  child: PopupMenuButton<String>(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Text(
                                          'Edit',
                                          style:
                                              GoogleFonts.poppins(fontSize: 12),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'cancel',
                                        child: Text(
                                          'Cancel',
                                          style:
                                              GoogleFonts.poppins(fontSize: 12),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'share',
                                        child: Text(
                                          'Share',
                                          style:
                                              GoogleFonts.poppins(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      // handle menu item selection here
                                      print('Selected: $value');
                                    },
                                    child: const Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ))
                              ],
                            )),
                            Expanded(
                              flex: 3,
                              child: Text(
                                  widget.userModel.userReminder[index]
                                      .description,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: Colors.white)),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                  "${widget.userModel.userReminder[index].remainderDate} ${widget.userModel.userReminder[index].remainderTime}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                    );
            },
            itemCount: widget.userModel.userReminder.length,
          ),
        ),
      ),
    );
  }

  Visibility taskSearchContainer() {
    return Visibility(
      visible: widget.userModel.userTasks.any((task) =>
          (task.description.toLowerCase().contains(search.text.toLowerCase()) ||
              task.taskTitle
                  .toLowerCase()
                  .contains(search.text.toLowerCase())) &&
          (DateTime.parse("${task.taskDate} ${task.taskTime.substring(0, 5)}")
              .isAfter(DateTime.now()))),
      child: LayoutBuilder(
        builder: (context, constraints) => SizedBox(
          height: 200,
          child: ListView.builder(
            itemBuilder: (context, index) {
              bool taskContains = (widget.userModel.userTasks[index].taskTitle
                          .toLowerCase()
                          .contains(search.text.toLowerCase()) ||
                      widget.userModel.userTasks[index].description
                          .toLowerCase()
                          .contains(search.text.toLowerCase())) &&
                  (DateTime.parse(
                          "${widget.userModel.userTasks[index].taskDate} ${widget.userModel.userTasks[index].taskTime.substring(0, 5)}")
                      .isAfter(DateTime.now()));
              return taskContains
                  ? InkWell(
                      onTap: () {
                        //print("Hmm");
                      },
                      onHover: (value) {
                        setState(() {
                          taskHoverList[index] = value;
                        });
                      },
                      child: Container(
                        height: 100,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          border:
                              Border.all(color: Colors.grey.shade200, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                      widget
                                          .userModel.userTasks[index].taskTitle,
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                ),
                                Expanded(
                                    child: AnimatedOpacity(
                                  opacity: taskHoverList[index] ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 100),
                                  child: PopupMenuButton<String>(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Text(
                                          'Edit',
                                          style:
                                              GoogleFonts.poppins(fontSize: 12),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'cancel',
                                        child: Text(
                                          'Cancel',
                                          style:
                                              GoogleFonts.poppins(fontSize: 12),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'share',
                                        child: Text(
                                          'Share',
                                          style:
                                              GoogleFonts.poppins(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      // handle menu item selection here
                                      print('Selected: $value');
                                    },
                                    child: const Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ))
                              ],
                            )),
                            Expanded(
                              flex: 3,
                              child: Text(
                                  widget.userModel.userTasks[index].description,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: Colors.white)),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                  "${widget.userModel.userTasks[index].taskDate} ${widget.userModel.userTasks[index].taskTime}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                    );
            },
            itemCount: widget.userModel.userTasks.length,
          ),
        ),
      ),
    );
  }

  Visibility eventSearchContainer() {
    return Visibility(
      visible: widget.userModel.userEvents.any((events) =>
          (events.description
                  .toLowerCase()
                  .contains(search.text.toLowerCase()) ||
              events.eventTitle
                  .toLowerCase()
                  .contains(search.text.toLowerCase())) &&
          (DateTime.parse(
                  "${events.startDate} ${events.startTime.substring(0, 5)}")
              .isAfter(DateTime.now()))),
      child: LayoutBuilder(
        builder: (context, constraints) => SizedBox(
          height: 200,
          child: ListView.builder(
            itemBuilder: (context, index) {
              bool eventsContains = (widget
                          .userModel.userEvents[index].eventTitle
                          .toLowerCase()
                          .contains(search.text.toLowerCase()) ||
                      widget.userModel.userEvents[index].description
                          .toLowerCase()
                          .contains(search.text.toLowerCase())) &&
                  (DateTime.parse(widget.userModel.userEvents[index].startDate)
                      .isAfter(DateTime.now()));
              return eventsContains
                  ? InkWell(
                      onTap: () {
                        //print("Hmm");
                      },
                      onHover: (value) {
                        setState(() {
                          eventsHoverList[index] = value;
                        });
                      },
                      child: Container(
                        height: 150,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          border:
                              Border.all(color: Colors.grey.shade200, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                      widget.userModel.userEvents[index]
                                          .eventTitle,
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                ),
                                Expanded(
                                    child: AnimatedOpacity(
                                  opacity: eventsHoverList[index] ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 100),
                                  child: PopupMenuButton<String>(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Text(
                                          'Edit',
                                          style:
                                              GoogleFonts.poppins(fontSize: 12),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'cancel',
                                        child: Text(
                                          'Cancel',
                                          style:
                                              GoogleFonts.poppins(fontSize: 12),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'share',
                                        child: Text(
                                          'Share',
                                          style:
                                              GoogleFonts.poppins(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      // handle menu item selection here
                                      print('Selected: $value');
                                    },
                                    child: const Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ))
                              ],
                            )),
                            Expanded(
                              flex: 3,
                              child: Text(
                                  widget
                                      .userModel.userEvents[index].description,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: Colors.white)),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                  "${widget.userModel.userEvents[index].startDate} ${widget.userModel.userEvents[index].startTime}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: Colors.white)),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                  "${widget.userModel.userEvents[index].endDate} ${widget.userModel.userEvents[index].endTime}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                    );
            },
            itemCount: widget.userModel.userEvents.length,
          ),
        ),
      ),
    );
  }
}
