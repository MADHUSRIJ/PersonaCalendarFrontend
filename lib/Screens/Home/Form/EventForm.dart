import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:persona_calendar/Animation/animation.dart';
import 'package:persona_calendar/Services/Apis/EventsApi.dart';
import 'package:persona_calendar/sizeConfig.dart';


class Events extends StatefulWidget {
  final int userId;
  const Events({Key? key, required this.userId}) : super(key: key);

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final formKey = GlobalKey<FormState>();
  //String dropdownValue = 'Does not repeat';
  bool isChecked = false;
  Map<String, dynamic>? eventsMap;

  TextEditingController eventsIdText = TextEditingController();
  TextEditingController eventTitle = TextEditingController();
  TextEditingController eventDescription = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();

  Future<String> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      return formattedDate;
    }
    return "";
  }

  Future<String?> _selectTime() async {
    final TimeOfDay initialTime = TimeOfDay.now();
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if(selectedTime != null){
      final time = DateFormat('hh:mm a').format(DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute));
      return time;
    }
    return "";
  }

  Future<String> submitForm() async{
    try{

      eventsMap = {
        "eventTitle": eventTitle.text,
        "eventDescription": eventDescription.text,
        "startDate": startDate.text,
        "endDate": endDate.text,
        "startTime": startTime.text,
        "endTime": endTime.text,
        "eventOccurance": "NA",
        "location" : location.text,
        "eventNotification": isChecked,
        "userId" : widget.userId,
        "access": "Owner",
      };

      http.Response response = await EventsApi.postEvents(eventsMap!);

      if (response.statusCode == 201) {
        // Parse the response body
        Map<String, dynamic> responseBody = json.decode(response.body);

        // Extract the ID from the response body
        int eventId = responseBody['eventId'];
        eventsIdText.text = eventId.toString();

        // Use the ID in your Flutter code
        //print('Created userEvents with ID: $eventId');
      } else {
        throw Exception('Failed to create userEvents: ${response.statusCode}');
      }
    }
    catch(ex){
      throw Exception('In post events : ${ex.toString()}');
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,

      content: Container(
        alignment: Alignment.center,
        height: SizeConfig.height!*130,
        width: SizeConfig.width!*42,
        margin: const EdgeInsets.symmetric(vertical: 30),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,

        ),
        child: SingleChildScrollView(
          child: SizedBox(
            height: SizeConfig.height!*120,
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
                    key: formKey,
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
                                  controller: eventTitle,
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
                                      prefixIcon: Icon(Icons.event_available_rounded,size: SizeConfig.height! * 3,),
                                      contentPadding: const EdgeInsets.symmetric(
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
                                  controller: eventDescription,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  decoration:
                                  InputDecoration(
                                      hintText: "Event Description",
                                      errorMaxLines: 1,
                                      prefixIcon: Icon(Icons.description,size: SizeConfig.height! * 3,),
                                      contentPadding: const EdgeInsets.symmetric(
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
                                      prefix: SizedBox(
                                        height: 20,
                                        width: 10,
                                        child: GestureDetector(
                                          onTap: () async {
                                            startDate.text = (await _showDatePicker());

                                          },

                                        ),
                                      ),
                                      prefixIcon: const Icon(Icons.calendar_today,color: Colors.grey,),
                                      contentPadding: const EdgeInsets.symmetric(
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
                                      prefix: SizedBox(
                                        height: 20,
                                        width: 10,
                                        child: GestureDetector(
                                          onTap: () async {
                                            endDate.text = (await _showDatePicker());

                                          },

                                        ),
                                      ),
                                      prefixIcon: const Icon(Icons.calendar_today,color: Colors.grey,),
                                      contentPadding: const EdgeInsets.symmetric(
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
                                      prefix: SizedBox(
                                        height: 20,
                                        width: 10,
                                        child: GestureDetector(
                                          onTap: () async {
                                            startTime.text = (await _selectTime())!;

                                          },

                                        ),
                                      ),
                                      prefixIcon: const Icon(Icons.timelapse,color: Colors.grey,),
                                      contentPadding: const EdgeInsets.symmetric(
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
                                      prefix: SizedBox(
                                        height: 20,
                                        width: 10,
                                        child: GestureDetector(
                                          onTap: () async {
                                            endTime.text = (await _selectTime())!;

                                          },

                                        ),
                                      ),
                                      prefixIcon: const Icon(Icons.timelapse,color: Colors.grey,),
                                      contentPadding: const EdgeInsets.symmetric(
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
                                  controller: location,
                                  keyboardType: TextInputType.number,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  decoration:
                                  InputDecoration(
                                      hintText: "Location",
                                      errorMaxLines: 1,
                                      prefixIcon: Icon(Icons.location_on_rounded,size: SizeConfig.height! * 3,),
                                      contentPadding: const EdgeInsets.symmetric(
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
                        /*Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                              padding: EdgeInsets.symmetric(horizontal: SizeConfig.width!*2),
                              height: SizeConfig.height! * 4,
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: Colors.grey.shade500),
                                  borderRadius: BorderRadius.circular(10)),
                              child: DropdownButton<String>(
                                hint: const Text("Occurance"),
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
                        SizedBox(height: SizeConfig.height! * 2,),*/
                        Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: SizeConfig.width! * 4),
                              height: SizeConfig.height! * 4,
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  const Text("Send Notification"),
                                  Checkbox(
                                    value: isChecked,
                                    activeColor: const Color(0xff00ADB5),
                                    onChanged: (value) {
                                      setState(() {
                                        isChecked = value!;
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
                          if(submitForm() != ""){
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: SizeConfig.height! * 6,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color(0xff00ADB5),
                          ),
                          child: const Text("Submit",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),),
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
      ),

    );
  }
}


