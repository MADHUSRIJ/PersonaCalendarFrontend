import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persona_calendar/Animation/animation.dart';
import 'package:persona_calendar/sizeConfig.dart';


class NotesForm{
   static Future<void> createNote(BuildContext context) async {
     final formKey = GlobalKey<FormState>();

     TextEditingController notesTitle = TextEditingController();
     TextEditingController notesDescription = TextEditingController();

     return showDialog(
         context: context,
         builder: (context) {

           return AlertDialog(
             backgroundColor: Colors.transparent,
             contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
             content: Container(
               alignment: Alignment.center,
               height: SizeConfig.height!*50,
               width: SizeConfig.width!*42,
               margin: EdgeInsets.symmetric(vertical: 30),
               padding: const EdgeInsets.all(24),
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(24),
                 color: Colors.white,

               ),
               child: SingleChildScrollView(
                 child: Container(
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
                                           controller: notesDescription,

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
             ),

           );
         });
   }

}