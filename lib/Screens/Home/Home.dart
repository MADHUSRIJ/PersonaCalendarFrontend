import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:persona_calendar/Animation/animation.dart';
import 'package:persona_calendar/Services/SampleEvent.dart';
import 'package:persona_calendar/sizeConfig.dart';

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
                        onTap: (){
                          _createEvent();
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
                          _createTask();
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
                          _createNote();
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
                          _createReminder();
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



  Future<void> _createEvent() async {
    final _formKey = GlobalKey<FormState>();
    String? eventTitle = "";
    String? eventDescription = "";
    String? location = "";
    String dropdownValue = 'Does not repeat';
    bool isChecked = false;

    TextEditingController startDate = TextEditingController();
    TextEditingController endDate = TextEditingController();
    TextEditingController startTime = TextEditingController();
    TextEditingController endTime = TextEditingController();

    Future<String> _showDatePicker() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        final formattedDate = DateFormat('dd-MM-yyyy').format(picked);
        print(formattedDate);
        return formattedDate;
      }
      return "";
    }

    Future<String?> _selectTime() async {
      final TimeOfDay? initialTime = TimeOfDay.now();
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: initialTime!,
      );
      if(selectedTime != null){
        return selectedTime.toString();
      }
      return "";
    }

    return showDialog(
        context: context,
        builder: (context) {

          return AlertDialog(
            backgroundColor: Colors.transparent,

            content: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                height: SizeConfig.height!*130,
                width: SizeConfig.width!*42,
                margin: EdgeInsets.symmetric(vertical: 30),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white,

                ),
                child: Column(
                  children: [
                    Expanded(child: FadeAnimation(1.1,RichText(
                      text: const TextSpan(
                        style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),
                        children:   <TextSpan>[
                          TextSpan(text: 'Persona', style: TextStyle(color: Color(0xff00ADB5))),
                          TextSpan(text: ' Calendar'),
                        ],
                      ),
                    ))),
                    Expanded(child: FadeAnimation(1.2,RichText(
                      text: const TextSpan(
                        style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),
                        children:   <TextSpan>[
                          TextSpan(text: 'New Event')
                        ],
                      ),
                    ))),
                    Expanded(
                      flex: 15,
                      child: FadeAnimation(
                        1.4,Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            SizedBox(height: SizeConfig.height! * 2,),
                            Expanded(
                                child: Container(
                                  padding:EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                                  height: SizeConfig.height! * 4,
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 0.5,color: Colors.grey.shade500),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: TextFormField(
                                      onChanged: (val) {
                                        setState(() {
                                          eventTitle = val;
                                        });
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty && value == "") {
                                          return "Event Title should not be left empty";
                                        }
                                        return null;
                                      },
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      decoration:
                                      InputDecoration(
                                          hintText: "Event Title",
                                          errorMaxLines: 1,
                                          prefixIcon: Icon(Icons.person,size: SizeConfig.height! * 3,),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 20),
                                          hintStyle: GoogleFonts.poppins(
                                              fontSize: SizeConfig.height! * 2.3,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey),
                                          border: InputBorder.none
                                      ),
                                      style: GoogleFonts.poppins(
                                          fontSize: SizeConfig.height! * 2,
                                          color: Colors.black),
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(height: SizeConfig.height! * 2,),
                            Expanded(
                                child: Container(
                                  padding:EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                                  height: SizeConfig.height! * 4,
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 0.5,color: Colors.grey.shade500),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: TextFormField(
                                      onChanged: (val) {
                                        setState(() {
                                          eventDescription = val;
                                        });
                                      },

                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      decoration:
                                      InputDecoration(
                                          hintText: "Event Description",
                                          errorMaxLines: 1,
                                          prefixIcon: Icon(Icons.mail,size: SizeConfig.height! * 3,),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 20),
                                          hintStyle: GoogleFonts.poppins(
                                              fontSize: SizeConfig.height! * 2.3,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey),
                                          border: InputBorder.none
                                      ),
                                      style: GoogleFonts.poppins(
                                          fontSize: SizeConfig.height! * 2,
                                          color: Colors.black),
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(height: SizeConfig.height! * 2,),
                            Expanded(
                              child: Container(
                                  padding:EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                                  height: SizeConfig.height! * 4,
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 0.5,color: Colors.grey.shade500),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: TextFormField(
                                      controller: startDate,
                                      decoration: InputDecoration(
                                          hintText: "Start date",
                                          errorMaxLines: 1,
                                          prefix: Container(
                                            height: 20,
                                            width: 10,
                                            child: GestureDetector(
                                              onTap: () async {
                                                startDate.text = (await _showDatePicker());

                                              },

                                            ),
                                          ),
                                          prefixIcon: Icon(Icons.calendar_today,color: Colors.grey,),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 20),
                                          hintStyle: GoogleFonts.poppins(
                                              fontSize: SizeConfig.height! * 2.3,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey),
                                          border: InputBorder.none
                                      ),
                                      style: GoogleFonts.poppins(
                                          fontSize: SizeConfig.height! * 2,
                                          color: Colors.black),
                                    ),
                                  )
                              ),),
                            SizedBox(height: SizeConfig.height! * 2,),
                            Expanded(
                              child: Container(
                                  padding:EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                                  height: SizeConfig.height! * 4,
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 0.5,color: Colors.grey.shade500),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: TextFormField(
                                      controller: endDate,
                                      decoration: InputDecoration(
                                          hintText: "End date",
                                          errorMaxLines: 1,
                                          prefix: Container(
                                            height: 20,
                                            width: 10,
                                            child: GestureDetector(
                                              onTap: () async {
                                                endDate.text = (await _showDatePicker());

                                              },

                                            ),
                                          ),
                                          prefixIcon: Icon(Icons.calendar_today,color: Colors.grey,),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 20),
                                          hintStyle: GoogleFonts.poppins(
                                              fontSize: SizeConfig.height! * 2.3,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey),
                                          border: InputBorder.none
                                      ),
                                      style: GoogleFonts.poppins(
                                          fontSize: SizeConfig.height! * 2,
                                          color: Colors.black),
                                    ),
                                  )
                              ),),
                            SizedBox(height: SizeConfig.height! * 2,),
                            Expanded(
                              child: Container(
                                  padding:EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                                  height: SizeConfig.height! * 4,
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 0.5,color: Colors.grey.shade500),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: TextFormField(
                                      controller: startTime,
                                      decoration: InputDecoration(
                                          hintText: "Start Time",
                                          errorMaxLines: 1,
                                          prefix: Container(
                                            height: 20,
                                            width: 10,
                                            child: GestureDetector(
                                              onTap: () async {
                                                startTime.text = (await _selectTime())!;

                                              },

                                            ),
                                          ),
                                          prefixIcon: Icon(Icons.timelapse,color: Colors.grey,),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 20),
                                          hintStyle: GoogleFonts.poppins(
                                              fontSize: SizeConfig.height! * 2.3,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey),
                                          border: InputBorder.none
                                      ),
                                      style: GoogleFonts.poppins(
                                          fontSize: SizeConfig.height! * 2,
                                          color: Colors.black),
                                    ),
                                  )
                              ),),
                            SizedBox(height: SizeConfig.height! * 2,),
                            Expanded(
                              child: Container(
                                  padding:EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                                  height: SizeConfig.height! * 4,
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 0.5,color: Colors.grey.shade500),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: TextFormField(
                                      controller: endTime,
                                      decoration: InputDecoration(
                                          hintText: "End time",
                                          errorMaxLines: 1,
                                          prefix: Container(
                                            height: 20,
                                            width: 10,
                                            child: GestureDetector(
                                              onTap: () async {
                                                endTime.text = (await _selectTime())!;

                                              },

                                            ),
                                          ),
                                          prefixIcon: Icon(Icons.timelapse,color: Colors.grey,),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 20),
                                          hintStyle: GoogleFonts.poppins(
                                              fontSize: SizeConfig.height! * 2.3,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey),
                                          border: InputBorder.none
                                      ),
                                      style: GoogleFonts.poppins(
                                          fontSize: SizeConfig.height! * 2,
                                          color: Colors.black),
                                    ),
                                  )
                              ),),
                            SizedBox(height: SizeConfig.height! * 2,),
                            Expanded(
                                child: Container(
                                  padding:EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                                  height: SizeConfig.height! * 4,
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 0.5,color: Colors.grey.shade500),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: TextFormField(
                                      onChanged: (val) {
                                        setState(() {
                                          location = val;
                                        });
                                      },

                                      keyboardType: TextInputType.number,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      decoration:
                                      InputDecoration(
                                          hintText: "Location",
                                          errorMaxLines: 1,
                                          prefixIcon: Icon(Icons.phone,size: SizeConfig.height! * 3,),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 20),
                                          hintStyle: GoogleFonts.poppins(
                                              fontSize: SizeConfig.height! * 2.3,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey),
                                          border: InputBorder.none
                                      ),
                                      style: GoogleFonts.poppins(
                                          fontSize: SizeConfig.height! * 2,
                                          color: Colors.black),
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(height: SizeConfig.height! * 2,),
                            Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.width!*2),
                                  height: SizeConfig.height! * 4,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 0.5, color: Colors.grey.shade500),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: DropdownButton<String>(
                                    hint: Text("Occurance"),
                                    value: dropdownValue,
                                    onChanged: (newValue){
                                      setState(() {
                                        dropdownValue = newValue!;
                                      });
                                    },
                                    dropdownColor: Colors.white,
                                    elevation: 0,
                                    items: <String>['Does not repeat','Daily', 'Weekly', 'Monthly', 'Annually']
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                )),
                            SizedBox(height: SizeConfig.height! * 2,),
                            Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                                  height: SizeConfig.height! * 4,
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      Text("Send Notification"),
                                      Checkbox(
                                        value: isChecked,
                                        onChanged: (value) {
                                          setState(() {
                                            print(value);
                                            print("notification");
                                            isChecked = value!;
                                            print("Hello ${isChecked}");
                                          });
                                        },

                                      ),
                                    ],
                                  ),
                                )),
                            SizedBox(height: SizeConfig.height! * 2,),
                          ],
                        ),
                      ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: FadeAnimation(
                        1.5,Center(
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                          child: GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: SizeConfig.height! * 6,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0xff00ADB5),
                              ),
                              child: Text("Submit",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),),
                            ),
                          ),
                        ),
                      ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

          );
        });
  }
  Future<void> _createTask() async {
    final _formKey = GlobalKey<FormState>();
    String? taskTitle = "";
    String? taskDescription = "";

    String dropdownValue = 'Does not repeat';
    bool isChecked = false;

    TextEditingController taskDate = TextEditingController();
    TextEditingController taskTime = TextEditingController();

    Future<String> _showDatePicker() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        final formattedDate = DateFormat('dd-MM-yyyy').format(picked);
        print(formattedDate);
        return formattedDate;
      }
      return "";
    }

    Future<String?> _selectTime() async {
      final TimeOfDay? initialTime = TimeOfDay.now();
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: initialTime!,
      );
      if(selectedTime != null){
        return selectedTime.toString();
      }
      return "";
    }
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
            content: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                height: SizeConfig.height!*100,
                width: SizeConfig.width!*42,
                margin: EdgeInsets.symmetric(vertical: 30),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white,

                ),
                child: Column(
                  children: [
                    Expanded(child: FadeAnimation(1.1,RichText(
                      text: const TextSpan(
                        style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),
                        children:   <TextSpan>[
                          TextSpan(text: 'Persona', style: TextStyle(color: Color(0xff00ADB5))),
                          TextSpan(text: ' Calendar'),
                        ],
                      ),
                    ))),
                    Expanded(child: FadeAnimation(1.2,RichText(
                      text: const TextSpan(
                        style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),
                        children:   <TextSpan>[
                          TextSpan(text: 'New Task')
                        ],
                      ),
                    ))),
                    Expanded(
                      flex: 15,
                      child: FadeAnimation(
                        1.4,Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(
                                    padding:EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                                    height: SizeConfig.height! * 4,
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.5,color: Colors.grey.shade500),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: TextFormField(
                                        onChanged: (val) {
                                          setState(() {
                                            taskTitle = val;
                                          });
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty && value == "") {
                                            return "Task Title should not be left empty";
                                          }
                                          return null;
                                        },
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        decoration:
                                        InputDecoration(
                                            hintText: "Task Title",
                                            errorMaxLines: 1,
                                            prefixIcon: Icon(Icons.person,size: SizeConfig.height! * 3,),
                                            contentPadding: EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 20),
                                            hintStyle: GoogleFonts.poppins(
                                                fontSize: SizeConfig.height! * 2.3,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey),
                                            border: InputBorder.none
                                        ),
                                        style: GoogleFonts.poppins(
                                            fontSize: SizeConfig.height! * 2,
                                            color: Colors.black),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: SizeConfig.height! * 2,),
                              Expanded(
                                  child: Container(
                                    padding:EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                                    height: SizeConfig.height! * 4,
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.5,color: Colors.grey.shade500),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: TextFormField(
                                        onChanged: (val) {
                                          setState(() {
                                            taskDescription = val;
                                          });
                                        },

                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        decoration:
                                        InputDecoration(
                                            hintText: "Task Description",
                                            errorMaxLines: 1,
                                            prefixIcon: Icon(Icons.mail,size: SizeConfig.height! * 3,),
                                            contentPadding: EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 20),
                                            hintStyle: GoogleFonts.poppins(
                                                fontSize: SizeConfig.height! * 2.3,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey),
                                            border: InputBorder.none
                                        ),
                                        style: GoogleFonts.poppins(
                                            fontSize: SizeConfig.height! * 2,
                                            color: Colors.black),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: SizeConfig.height! * 2,),
                              Expanded(
                                child: Container(
                                    padding:EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                                    height: SizeConfig.height! * 4,
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.5,color: Colors.grey.shade500),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: TextFormField(
                                        controller: taskDate,
                                        decoration: InputDecoration(
                                            hintText: "Task date",
                                            errorMaxLines: 1,
                                            prefix: Container(
                                              height: 20,
                                              width: 10,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  taskDate.text = (await _showDatePicker())!;

                                                },

                                              ),
                                            ),
                                            prefixIcon: Icon(Icons.calendar_today,color: Colors.grey,),
                                            contentPadding: EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 20),
                                            hintStyle: GoogleFonts.poppins(
                                                fontSize: SizeConfig.height! * 2.3,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey),
                                            border: InputBorder.none
                                        ),
                                        style: GoogleFonts.poppins(
                                            fontSize: SizeConfig.height! * 2,
                                            color: Colors.black),
                                      ),
                                    )
                                ),),
                              SizedBox(height: SizeConfig.height! * 2,),
                              Expanded(
                                child: Container(
                                    padding:EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                                    height: SizeConfig.height! * 4,
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.5,color: Colors.grey.shade500),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: TextFormField(
                                        controller: taskTime,
                                        decoration: InputDecoration(
                                            hintText: "Task Time",
                                            errorMaxLines: 1,
                                            prefix: Container(
                                              height: 20,
                                              width: 10,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  taskTime.text = (await _selectTime())!;

                                                },

                                              ),
                                            ),
                                            prefixIcon: Icon(Icons.timelapse,color: Colors.grey,),
                                            contentPadding: EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 20),
                                            hintStyle: GoogleFonts.poppins(
                                                fontSize: SizeConfig.height! * 2.3,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey),
                                            border: InputBorder.none
                                        ),
                                        style: GoogleFonts.poppins(
                                            fontSize: SizeConfig.height! * 2,
                                            color: Colors.black),
                                      ),
                                    )
                                ),),
                              SizedBox(height: SizeConfig.height! * 2,),
                              Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.width!*2),
                                    height: SizeConfig.height! * 4,
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 0.5, color: Colors.grey.shade500),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: DropdownButton<String>(
                                      hint: Text("Occurance"),
                                      value: dropdownValue,
                                      onChanged: (newValue){
                                        setState(() {
                                          dropdownValue = newValue!;
                                        });
                                      },
                                      dropdownColor: Colors.white,
                                      elevation: 0,
                                      items: <String>['Does not repeat','Daily', 'Weekly', 'Monthly', 'Annually']
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  )),
                              SizedBox(height: SizeConfig.height! * 2,),
                              Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                                    height: SizeConfig.height! * 4,
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        Text("Send Notification"),
                                        Checkbox(
                                          value: isChecked,
                                          onChanged: (value) {
                                            setState(() {
                                              print(value);
                                              print("notification");
                                              isChecked = value!;
                                              print("Hello ${isChecked}");
                                            });
                                          },

                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(height: SizeConfig.height! * 2,),
                            ],
                          ),
                        ),
                      ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: FadeAnimation(
                        1.5,Center(
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                          child: GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: SizeConfig.height! * 6,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0xff00ADB5),
                              ),
                              child: Text("Submit",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),),
                            ),
                          ),
                        ),
                      ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

          );
        });
  }
  Future<void> _createReminder() async {
    final _formKey = GlobalKey<FormState>();
    String? reminderDescription = "";

    String dropdownValue = 'Does not repeat';
    TextEditingController reminderDate = TextEditingController();
    TextEditingController reminderTime = TextEditingController();

    Future<String> _showDatePicker() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        final formattedDate = DateFormat('dd-MM-yyyy').format(picked);
        print(formattedDate);
        return formattedDate;
      }
      return "";
    }

    Future<String?> _selectTime() async {
      final TimeOfDay? initialTime = TimeOfDay.now();
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: initialTime!,
      );
      if(selectedTime != null){
        return selectedTime.toString();
      }
      return "";
    }

    return showDialog(
        context: context,
        builder: (context) {

          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
            content: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                height: SizeConfig.height!*80,
                width: SizeConfig.width!*42,
                margin: EdgeInsets.symmetric(vertical: 30),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white,

                ),
                child: Column(
                  children: [
                    Expanded(child: FadeAnimation(1.1,RichText(
                      text: const TextSpan(
                        style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),
                        children:   <TextSpan>[
                          TextSpan(text: 'Persona', style: TextStyle(color: Color(0xff00ADB5))),
                          TextSpan(text: ' Calendar'),
                        ],
                      ),
                    ))),
                    Expanded(child: FadeAnimation(1.2,RichText(
                      text: const TextSpan(
                        style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),
                        children:   <TextSpan>[
                          TextSpan(text: 'New Reminder')
                        ],
                      ),
                    ))),
                    Expanded(
                      flex: 15,
                      child: FadeAnimation(
                        1.4,Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Container(
                          child: Column(
                            children: [
                              SizedBox(height: SizeConfig.height! * 2,),
                              Expanded(
                                  child: Container(
                                    padding:EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                                    height: SizeConfig.height! * 4,
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.5,color: Colors.grey.shade500),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: TextFormField(
                                        onChanged: (val) {
                                          setState(() {
                                            reminderDescription = val;
                                          });
                                        },

                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        decoration:
                                        InputDecoration(
                                            hintText: "Reminder Description",
                                            errorMaxLines: 1,
                                            prefixIcon: Icon(Icons.mail,size: SizeConfig.height! * 3,),
                                            contentPadding: EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 20),
                                            hintStyle: GoogleFonts.poppins(
                                                fontSize: SizeConfig.height! * 2.3,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey),
                                            border: InputBorder.none
                                        ),
                                        style: GoogleFonts.poppins(
                                            fontSize: SizeConfig.height! * 2,
                                            color: Colors.black),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: SizeConfig.height! * 2,),
                              Expanded(
                                child: Container(
                                    padding:EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                                    height: SizeConfig.height! * 4,
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.5,color: Colors.grey.shade500),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Expanded(
                                        child: TextFormField(
                                          controller: reminderDate,
                                          decoration: InputDecoration(
                                              hintText: "Reminder date",
                                              errorMaxLines: 1,
                                              prefix: Container(
                                                height: 20,
                                                width: 10,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    reminderDate.text = (await _showDatePicker());

                                                  },

                                                ),
                                              ),
                                              prefixIcon: Icon(Icons.calendar_today,color: Colors.grey,),
                                              contentPadding: EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 20),
                                              hintStyle: GoogleFonts.poppins(
                                                  fontSize: SizeConfig.height! * 2.3,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey),
                                              border: InputBorder.none
                                          ),
                                          style: GoogleFonts.poppins(
                                              fontSize: SizeConfig.height! * 2,
                                              color: Colors.black),
                                        ),

                                      ),
                                    )
                                ),),
                              SizedBox(height: SizeConfig.height! * 2,),
                              Expanded(
                                child: Container(
                                    padding:EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                                    height: SizeConfig.height! * 4,
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.5,color: Colors.grey.shade500),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: TextFormField(
                                        controller: reminderTime,
                                        decoration: InputDecoration(
                                            hintText: "Reminder Time",
                                            errorMaxLines: 1,
                                            prefix: Container(
                                              height: 20,
                                              width: 10,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  reminderTime.text = (await _selectTime())!;

                                                },

                                              ),
                                            ),
                                            prefixIcon: Icon(Icons.timelapse,color: Colors.grey,),
                                            contentPadding: EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 20),
                                            hintStyle: GoogleFonts.poppins(
                                                fontSize: SizeConfig.height! * 2.3,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey),
                                            border: InputBorder.none
                                        ),
                                        style: GoogleFonts.poppins(
                                            fontSize: SizeConfig.height! * 2,
                                            color: Colors.black),
                                      ),
                                    )
                                ),),
                              SizedBox(height: SizeConfig.height! * 2,),
                              Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.width!*2),
                                    height: SizeConfig.height! * 4,
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 0.5, color: Colors.grey.shade500),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: DropdownButton<String>(
                                      hint: Text("Occurance"),
                                      value: dropdownValue,
                                      onChanged: (newValue){
                                        setState(() {
                                          dropdownValue = newValue!;
                                        });
                                      },
                                      dropdownColor: Colors.white,
                                      elevation: 0,
                                      items: <String>['Does not repeat','Daily', 'Weekly', 'Monthly', 'Annually']
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  )),
                              SizedBox(height: SizeConfig.height! * 2,),
                            ],
                          ),
                        ),
                      ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: FadeAnimation(
                        1.5,Center(
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                          child: GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: SizeConfig.height! * 6,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0xff00ADB5),
                              ),
                              child: Text("Submit",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),),
                            ),
                          ),
                        ),
                      ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

          );
        });
  }
  Future<void> _createNote() async {
    final _formKey = GlobalKey<FormState>();
    String? notesTitle = "";
    String? notesDescription = "";

    return showDialog(
        context: context,
        builder: (context) {

          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
            content: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                height: SizeConfig.height!*50,
                width: SizeConfig.width!*42,
                margin: EdgeInsets.symmetric(vertical: 30),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white,

                ),
                child: Column(
                  children: [
                    Expanded(child: FadeAnimation(1.1,RichText(
                      text: const TextSpan(
                        style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),
                        children:   <TextSpan>[
                          TextSpan(text: 'Persona', style: TextStyle(color: Color(0xff00ADB5))),
                          TextSpan(text: ' Calendar'),
                        ],
                      ),
                    ))),
                    Expanded(child: FadeAnimation(1.2,RichText(
                      text: const TextSpan(
                        style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),
                        children:   <TextSpan>[
                          TextSpan(text: 'New Notes')
                        ],
                      ),
                    ))),
                    Expanded(
                      flex: 6,
                      child: FadeAnimation(
                        1.4,Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Container(
                          child: Column(
                            children: [
                              SizedBox(height: SizeConfig.height! * 2,),
                              Expanded(
                                  child: Container(
                                    padding:EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                                    height: SizeConfig.height! * 4,
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.5,color: Colors.grey.shade500),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: TextFormField(
                                        onChanged: (val) {
                                          setState(() {
                                            notesTitle = val;
                                          });
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty && value == "") {
                                            return "Notes Title should not be left empty";
                                          }
                                          return null;
                                        },
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        decoration:
                                        InputDecoration(
                                            hintText: "Notes Title",
                                            errorMaxLines: 1,
                                            prefixIcon: Icon(Icons.person,size: SizeConfig.height! * 3,),
                                            contentPadding: EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 20),
                                            hintStyle: GoogleFonts.poppins(
                                                fontSize: SizeConfig.height! * 2.3,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey),
                                            border: InputBorder.none
                                        ),
                                        style: GoogleFonts.poppins(
                                            fontSize: SizeConfig.height! * 2,
                                            color: Colors.black),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: SizeConfig.height! * 2,),
                              Expanded(
                                  child: Container(
                                    padding:EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                                    height: SizeConfig.height! * 4,
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.5,color: Colors.grey.shade500),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: TextFormField(
                                        onChanged: (val) {
                                          setState(() {
                                            notesDescription = val;
                                          });
                                        },

                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        decoration:
                                        InputDecoration(
                                            hintText: "Notes Description",
                                            errorMaxLines: 1,
                                            prefixIcon: Icon(Icons.mail,size: SizeConfig.height! * 3,),
                                            contentPadding: EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 20),
                                            hintStyle: GoogleFonts.poppins(
                                                fontSize: SizeConfig.height! * 2.3,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey),
                                            border: InputBorder.none
                                        ),
                                        style: GoogleFonts.poppins(
                                            fontSize: SizeConfig.height! * 2,
                                            color: Colors.black),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: SizeConfig.height! * 2,),
                            ],
                          ),
                        ),
                      ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: FadeAnimation(
                        1.5,Center(
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                          child: GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: SizeConfig.height! * 6,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0xff00ADB5),
                              ),
                              child: Text("Submit",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),),
                            ),
                          ),
                        ),
                      ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

          );
        });
  }



}
