import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:persona_calendar/Animation/animation.dart';
import 'package:persona_calendar/Services/Apis/TasksApi.dart';
import 'package:persona_calendar/main.dart';
import 'package:persona_calendar/sizeConfig.dart';


class TasksForm extends StatefulWidget {
  final int userId;
  const TasksForm({Key? key, required this.userId}) : super(key: key);

  @override
  State<TasksForm> createState() => _TasksFormState();
}

class _TasksFormState extends State<TasksForm> {

  final formKey = GlobalKey<FormState>();
  Map<String, dynamic>? tasksMap;

  TextEditingController tasksIdText = TextEditingController();
  TextEditingController taskTitle = TextEditingController();
  TextEditingController taskDescription = TextEditingController();
  TextEditingController taskDate = TextEditingController();
  TextEditingController taskTime = TextEditingController();
  bool isChecked = false;

  Future<String> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      //print(formattedDate);
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

  Future<int> submitForm() async{
    try{

      tasksMap = {
        "taskTitle": taskTitle.text,
        "taskDescription": taskDescription.text,
        "taskDate": taskDate.text,
        "taskTime": taskTime.text,
        "taskNotification": isChecked,
        "userId": widget.userId,
        "access": "Owner",
      };

      http.Response response = await TasksApi.postTasks(tasksMap!);

      if (response.statusCode == 201) {
        // Parse the response body
        Map<String, dynamic> responseBody = json.decode(response.body);

        // Extract the ID from the response body
        int taskId = responseBody['taskId'];
        tasksIdText.text = taskId.toString();
        // Use the ID in your Flutter code
        //print('Created userTask with ID: $taskId');



        if(taskId!=0){
          return taskId;
        }

      } else {
        throw Exception('Failed to create Tasks: ${response.statusCode}');
      }
    }
    catch(ex){
      throw Exception('In post Tasks : ${ex.toString()}');
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
      content: Container(
        alignment: Alignment.center,
        height: SizeConfig.height!*100,
        width: SizeConfig.width!*42,
        margin: const EdgeInsets.symmetric(vertical: 30),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,

        ),
        child: SingleChildScrollView(
          child: SizedBox(
            height: SizeConfig.height!*90,
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
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                  controller: taskTitle,
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
                                      prefixIcon: Icon(Icons.task_alt,size: SizeConfig.height! * 3,),
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
                                  controller: taskDescription,

                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  decoration:
                                  InputDecoration(
                                      hintText: "Task Description",
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
                                  controller: taskDate,
                                  decoration: InputDecoration(
                                      hintText: "Task date",
                                      errorMaxLines: 1,
                                      prefix: SizedBox(
                                        height: 20,
                                        width: 10,
                                        child: GestureDetector(
                                          onTap: () async {
                                            taskDate.text = (await _showDatePicker());

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
                                  controller: taskTime,
                                  decoration: InputDecoration(
                                      hintText: "Task Time",
                                      errorMaxLines: 1,
                                      prefix: SizedBox(
                                        height: 20,
                                        width: 10,
                                        child: GestureDetector(
                                          onTap: () async {
                                            taskTime.text = (await _selectTime())!;

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
                        onTap: ()  async {
                          int errorMessage =  await submitForm();
                          if (errorMessage!=0) {
                            Navigator.pop(context);
                            Get.off(MyApp());
                          } else {
                            // if there's an error, display an error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Error creating notes")),
                            );
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



