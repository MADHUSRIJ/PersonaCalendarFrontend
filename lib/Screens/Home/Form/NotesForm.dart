import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persona_calendar/Animation/animation.dart';
import 'package:persona_calendar/Models/UsersModel.dart';
import 'package:persona_calendar/Services/Apis/NotesApi.dart';
import 'package:persona_calendar/Services/Apis/UserApi.dart';
import 'package:persona_calendar/Services/app_routes.dart';
import 'package:persona_calendar/main.dart';
import 'package:persona_calendar/sizeConfig.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotesForm extends StatefulWidget {
  final int userId;
  const NotesForm({Key? key, required this.userId}) : super(key: key);

  @override
  State<NotesForm> createState() => _NotesFormState();
}

class _NotesFormState extends State<NotesForm> {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic>? notesMap;

  TextEditingController notesTitle = TextEditingController();
  TextEditingController notesIdText = TextEditingController();
  TextEditingController notesDescription = TextEditingController();

  Future<int> submitForm() async{
    try{

      notesMap = {
        "notesTitle" : notesTitle.text,
        "notesBody" : notesDescription.text,
        "userId" : widget.userId,
        "access" : "Owner",
      };

      http.Response response = await NotesApi.postNotes(notesMap!);

      if (response.statusCode == 201) {
        // Parse the response body
        Map<String, dynamic> responseBody = json.decode(response.body);

        // Extract the ID from the response body
        int notesId = responseBody['notesId'];
        notesIdText.text = notesId.toString();

        // Use the ID in your Flutter code
        //print('Created userNotes with ID: $notesId');



        if(notesId!=0){
          return notesId;
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
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
      content: Container(
        alignment: Alignment.center,
        height: SizeConfig.height!*50,
        width: SizeConfig.width!*42,
        margin: const EdgeInsets.symmetric(vertical: 30),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,

        ),
        child: SingleChildScrollView(
          child: SizedBox(
            height: SizeConfig.height!*40,
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
                                  controller: notesTitle,
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
                                      prefixIcon: Icon(Icons.notes,size: SizeConfig.height! * 3,),
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
                                  controller: notesDescription,

                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  decoration:
                                  InputDecoration(
                                      hintText: "Notes Description",
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
                            //Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => MyApp()),
                                  (Route<dynamic> route) => false,
                            );

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


