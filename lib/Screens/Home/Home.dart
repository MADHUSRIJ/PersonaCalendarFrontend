import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persona_calendar/Animation/animation.dart';
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
import 'package:persona_calendar/Services/Apis/EventsApi.dart';
import 'package:persona_calendar/Services/Apis/NotesApi.dart';
import 'package:persona_calendar/Services/Apis/ReminderApi.dart';
import 'package:persona_calendar/Services/Apis/TasksApi.dart';
import 'package:persona_calendar/Services/app_routes.dart';
import 'package:persona_calendar/main.dart';
import 'package:persona_calendar/sizeConfig.dart';
import 'package:url_launcher/url_launcher.dart';

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

  final formKey = GlobalKey<FormState>();
  Map<String, dynamic>? notesMap;

  TextEditingController notesTitle = TextEditingController();
  TextEditingController notesIdText = TextEditingController();
  TextEditingController notesDescription = TextEditingController();
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
                                                        onSelected:
                                                            (value) async {
                                                          if (value == 'edit') {
                                                            setState(() {
                                                              notesTitle.text =
                                                                  widget
                                                                      .userModel
                                                                      .userNotes[
                                                                          index]
                                                                      .notesTitle!;
                                                              notesDescription
                                                                      .text =
                                                                  widget
                                                                      .userModel
                                                                      .userNotes[
                                                                          index]
                                                                      .description!;
                                                            });
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return notesEdit(widget
                                                                      .userModel
                                                                      .userNotes[index]);
                                                                });
                                                          }
                                                          if (value ==
                                                              'delete') {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return notesDelete(widget
                                                                      .userModel
                                                                      .userNotes[index]);
                                                                });
                                                          }
                                                          if (value ==
                                                              'share') {
                                                            try {
                                                              final Uri params =
                                                                  Uri(
                                                                scheme:
                                                                    'mailto',
                                                                path:
                                                                    'nithinraajjp@gmail.com',
                                                                query:
                                                                    'subject=subject of email&body=body of email',
                                                              );

                                                              final String url =
                                                                  params
                                                                      .toString();
                                                              print(url);
                                                              if (await canLaunchUrl(
                                                                  params)) {
                                                                await launchUrl(
                                                                    params);
                                                              } else {
                                                                throw 'Could not launch $url';
                                                              }
                                                            } catch (ex) {
                                                              print(ex
                                                                  .toString());
                                                            }
                                                          }
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
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => MyApp()),
                                    (Route<dynamic> route) => false,
                              );
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

  AlertDialog notesDelete(NotesModel notes) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
      content: Container(
        alignment: Alignment.center,
        height: SizeConfig.height! * 30,
        width: SizeConfig.width! * 30,
        margin: const EdgeInsets.symmetric(vertical: 30),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                "Are you sure want to delete note?",
                style: GoogleFonts.poppins(),
              ),
            ),
            Expanded(
              child: Text(
                notes.notesTitle!,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
                child: Row(
              children: [
                const Expanded(child: SizedBox()),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(3)),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(
                            color: Colors.grey, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () async {
                    final response = await NotesApi.deleteNotes(notes.notesId!);
                    if (response.statusCode == 204) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Delete Successful'),
                          duration: Duration(seconds: 10),
                        ),
                      );
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Delete not performed ${response.statusCode}'),
                          duration: const Duration(seconds: 10),
                        ),
                      );
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(3)),
                    child: Text(
                      "Delete",
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.w400),
                    ),
                  ),
                )),
              ],
            ))
          ],
        ),
      ),
    );
  }

  AlertDialog notesEdit(NotesModel notes) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
      content: Container(
        alignment: Alignment.center,
        height: SizeConfig.height! * 60,
        width: SizeConfig.width! * 50,
        margin: const EdgeInsets.symmetric(vertical: 30),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: FadeAnimation(
                    1.1,
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Persona',
                              style: TextStyle(color: Color(0xff00ADB5))),
                          TextSpan(text: ' Calendar'),
                        ],
                      ),
                    ))),
            Expanded(
                child: FadeAnimation(
                    1.2,
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                        children: <TextSpan>[TextSpan(text: 'Edit Notes')],
                      ),
                    ))),
            Expanded(
              flex: 6,
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.height! * 2,
                    ),
                    Expanded(
                        child: FadeAnimation(
                            1.3,
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.width! * 4),
                              height: SizeConfig.height! * 4,
                              alignment: Alignment.center,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.5,
                                        color: Colors.grey.shade500),
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  controller: notesTitle,
                                  validator: (value) {
                                    if (value!.isEmpty && value == "") {
                                      return "Notes Title should not be left empty";
                                    }
                                    return null;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                      hintText: "Notes Title",
                                      errorMaxLines: 1,
                                      prefixIcon: Icon(
                                        Icons.notes,
                                        size: SizeConfig.height! * 3,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 20),
                                      hintStyle: GoogleFonts.poppins(
                                          fontSize: SizeConfig.height! * 2.3,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey),
                                      border: InputBorder.none),
                                  style: GoogleFonts.poppins(
                                      fontSize: SizeConfig.height! * 2,
                                      color: Colors.black),
                                ),
                              ),
                            ))),
                    SizedBox(
                      height: SizeConfig.height! * 2,
                    ),
                    Expanded(
                        child: FadeAnimation(
                            1.4,
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.width! * 4),
                              height: SizeConfig.height! * 4,
                              alignment: Alignment.center,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.5,
                                        color: Colors.grey.shade500),
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  controller: notesDescription,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                      hintText: "Notes Description",
                                      errorMaxLines: 1,
                                      prefixIcon: Icon(
                                        Icons.description,
                                        size: SizeConfig.height! * 3,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 20),
                                      hintStyle: GoogleFonts.poppins(
                                          fontSize: SizeConfig.height! * 2.3,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey),
                                      border: InputBorder.none),
                                  style: GoogleFonts.poppins(
                                      fontSize: SizeConfig.height! * 2,
                                      color: Colors.black),
                                ),
                              ),
                            ))),
                    SizedBox(
                      height: SizeConfig.height! * 2,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: FadeAnimation(
                    1.5,
                    Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(3)),
                              child: Text(
                                "Cancel",
                                style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            child: GestureDetector(
                          onTap: () async {
                            Map<String, dynamic> map = {
                              "notesId": notes.notesId!,
                              "notesTitle": notesTitle.text,
                              "notesBody": notesDescription.text,
                              "userId": widget.userModel.userId,
                              "access": "Owner",
                              "users": null
                            };
                            final response =
                                await NotesApi.editNotes(notes.notesId!, map);
                            if (response.statusCode == 204) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Edit Successful'),
                                  duration: Duration(seconds: 10),
                                ),
                              );
                              Navigator.pop(context);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp()),
                                (Route<dynamic> route) => false,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Edit not performed ${response.statusCode}'),
                                  duration: const Duration(seconds: 10),
                                ),
                              );
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(3)),
                            child: Text(
                              "Edit",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        )),
                      ],
                    )))
          ],
        ),
      ),
    );
  }

  AlertDialog eventDelete(EventsModel events) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
      content: Container(
        alignment: Alignment.center,
        height: SizeConfig.height! * 30,
        width: SizeConfig.width! * 30,
        margin: const EdgeInsets.symmetric(vertical: 30),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                "Are you sure want to delete event?",
                style: GoogleFonts.poppins(),
              ),
            ),
            Expanded(
              child: Text(
                events.eventTitle!,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
                child: Row(
              children: [
                const Expanded(child: SizedBox()),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(3)),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(
                            color: Colors.grey, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () async {
                    final response =
                        await EventsApi.deleteEvents(events.eventId!);
                    if (response.statusCode == 204) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Delete Successful'),
                          duration: Duration(seconds: 10),
                        ),
                      );
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Delete not performed ${response.statusCode}'),
                          duration: const Duration(seconds: 10),
                        ),
                      );
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(3)),
                    child: Text(
                      "Delete",
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.w400),
                    ),
                  ),
                )),
              ],
            ))
          ],
        ),
      ),
    );
  }

  AlertDialog taskDelete(TaskModel task) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
      content: Container(
        alignment: Alignment.center,
        height: SizeConfig.height! * 30,
        width: SizeConfig.width! * 30,
        margin: const EdgeInsets.symmetric(vertical: 30),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                "Are you sure want to delete note?",
                style: GoogleFonts.poppins(),
              ),
            ),
            Expanded(
              child: Text(
                task.taskTitle!,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
                child: Row(
              children: [
                const Expanded(child: SizedBox()),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(3)),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(
                            color: Colors.grey, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () async {
                    final response = await TasksApi.deleteTask(task.taskId!);
                    if (response.statusCode == 204) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Delete Successful'),
                          duration: Duration(seconds: 10),
                        ),
                      );
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Delete not performed ${response.statusCode}'),
                          duration: const Duration(seconds: 10),
                        ),
                      );
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(3)),
                    child: Text(
                      "Delete",
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.w400),
                    ),
                  ),
                )),
              ],
            ))
          ],
        ),
      ),
    );
  }

  AlertDialog reminderDelete(RemainderModel reminder) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
      content: Container(
        alignment: Alignment.center,
        height: SizeConfig.height! * 30,
        width: SizeConfig.width! * 30,
        margin: const EdgeInsets.symmetric(vertical: 30),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                "Are you sure want to delete note?",
                style: GoogleFonts.poppins(),
              ),
            ),
            Expanded(
              child: Text(
                reminder.description,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
                child: Row(
              children: [
                const Expanded(child: SizedBox()),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(3)),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(
                            color: Colors.grey, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () async {
                    final response =
                        await ReminderApi.deleteReminder(reminder.remainderId!);
                    if (response.statusCode == 204) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Delete Successful'),
                          duration: Duration(seconds: 10),
                        ),
                      );
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Delete not performed ${response.statusCode}'),
                          duration: const Duration(seconds: 10),
                        ),
                      );
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(3)),
                    child: Text(
                      "Delete",
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.w400),
                    ),
                  ),
                )),
              ],
            ))
          ],
        ),
      ),
    );
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
                                    onSelected: (value) async{
                                      if(value == "edit"){
                                        showDialog(context: context, builder: (context){
                                          return Container();
                                        });
                                      }
                                      if(value == "cancel"){
                                        showDialog(context: context, builder: (context){
                                          return reminderDelete(widget.userModel.userReminder[index]);
                                        });
                                      }
                                      if (value ==
                                          'share') {
                                        try {
                                          final Uri params =
                                          Uri(
                                            scheme:
                                            'mailto',
                                            path:
                                            'nithinraajjp@gmail.com',
                                            query:
                                            'subject=subject of email&body=body of email',
                                          );

                                          final String url =
                                          params
                                              .toString();
                                          print(url);
                                          if (await canLaunchUrl(
                                              params)) {
                                            await launchUrl(
                                                params);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        } catch (ex) {
                                          print(ex
                                              .toString());
                                        }
                                      }
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

                                      onSelected: (value) async{
                                        if(value == "edit"){
                                          showDialog(context: context, builder: (context){
                                            return Container();
                                          });
                                        }
                                        if(value == "cancel"){
                                          showDialog(context: context, builder: (context){
                                            return taskDelete(widget.userModel.userTasks[index]);
                                          });
                                        }
                                        if (value ==
                                            'share') {
                                          try {
                                            final Uri params =
                                            Uri(
                                              scheme:
                                              'mailto',
                                              path:
                                              'nithinraajjp@gmail.com',
                                              query:
                                              'subject=subject of email&body=body of email',
                                            );

                                            final String url =
                                            params
                                                .toString();
                                            print(url);
                                            if (await canLaunchUrl(
                                                params)) {
                                              await launchUrl(
                                                  params);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          } catch (ex) {
                                            print(ex
                                                .toString());
                                          }
                                        }
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
                                    onSelected: (value) async{
                                      if(value == "edit"){
                                        showDialog(context: context, builder: (context){
                                          return Container();
                                        });
                                      }
                                      if(value == "cancel"){
                                        showDialog(context: context, builder: (context){
                                          return eventDelete(widget.userModel.userEvents[index]);
                                        });
                                      }
                                      if (value ==
                                          'share') {
                                        try {
                                          final Uri params =
                                          Uri(
                                            scheme:
                                            'mailto',
                                            path:
                                            'nithinraajjp@gmail.com',
                                            query:
                                            'subject=subject of email&body=body of email',
                                          );

                                          final String url =
                                          params
                                              .toString();
                                          print(url);
                                          if (await canLaunchUrl(
                                          params)) {
                                      await launchUrl(
                                      params);
                                      } else {
                                      throw 'Could not launch $url';
                                      }
                                      } catch (ex) {
                                      print(ex
                                          .toString());
                                      }
                                    }
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
