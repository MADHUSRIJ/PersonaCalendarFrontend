import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:persona_calendar/Animation/animation.dart';
import 'package:persona_calendar/Services/Apis/ReminderApi.dart';
import 'package:persona_calendar/sizeConfig.dart';
import 'package:http/http.dart' as http;

class ReminderForm extends StatefulWidget {
  final int userId;
  const ReminderForm({Key? key, required this.userId}) : super(key: key);

  @override
  State<ReminderForm> createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm> {

  final formKey = GlobalKey<FormState>();

  String dropdownValue = 'Does not repeat';
  TextEditingController reminderIdText = TextEditingController();
  TextEditingController reminderDescription = TextEditingController();
  TextEditingController reminderDate = TextEditingController();
  TextEditingController reminderTime = TextEditingController();
  Map<String, dynamic>? reminderMap;

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
      final time = DateFormat('hh:mm').format(DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute));
      return time;
    }
    return "";
  }

  Future<int> submitForm() async{
    try{

      reminderMap = {
        "reminderDate": reminderDate.text,
        "reminderTime": reminderTime.text,
        "reminderDescription": reminderDescription.text,
        "reminderOccurence": dropdownValue,
        "access": "Owner",
        "userId": widget.userId,
      };

      http.Response response = await ReminderApi.postReminders(reminderMap!);

      if (response.statusCode == 201) {
        // Parse the response body
        Map<String, dynamic> responseBody = json.decode(response.body);

        // Extract the ID from the response body
        int reminderId = responseBody['reminderId'];
        reminderIdText.text = reminderId.toString();
        // Use the ID in your Flutter code
        print('Created userReminder with ID: $reminderId');



        if(reminderId!=0){
          return reminderId;
        }

      } else {
        throw Exception('Failed to create Notes: ${response.statusCode}');
      }
    }
    catch(ex){
      throw Exception('In post Notes : ${ex.toString()}');
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
      content: Container(
        alignment: Alignment.center,
        height: SizeConfig.height!*80,
        width: SizeConfig.width!*42,
        margin: EdgeInsets.symmetric(vertical: 30),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,

        ),
        child: SingleChildScrollView(
          child: Container(
            height: SizeConfig.height!*70,
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
                    key: formKey,
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
                                    controller: reminderDescription,
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
                          submitForm();
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
      ),

    );
  }
}

