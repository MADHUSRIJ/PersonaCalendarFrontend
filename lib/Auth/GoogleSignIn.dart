import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:persona_calendar/Services/Apis/UserApi.dart';
import 'package:persona_calendar/main.dart';
import 'package:http/http.dart' as http;

class googlesigninclass
{
  static final googlesignin = GoogleSignIn();
  TextEditingController userIdText = TextEditingController();
  static GoogleSignInAccount? _user;
  
  static Future googleLogin() async{
    final googleuser = await googlesignin.signIn();
    if(googleuser == null)
      {
        return MyApp();
      }
    _user = googleuser;

    final googleAuth = await googleuser.authentication;

    final credintial = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );


    await FirebaseAuth.instance.signInWithCredential(credintial).whenComplete(() async{
        Map<String, dynamic>? userMap;
        userMap = Map<String,dynamic>();
        userMap["userName"] = _user!.displayName!;
        userMap["mobile"] = "";
        userMap["email"] = _user!.email;
        userMap["hashedPassword"] = "";

       http.Response response = await UserApi.postUser(userMap);
    
      if (response.statusCode == 201) {
        // Parse the response body
        Map<String, dynamic> responseBody = json.decode(response.body);

        // Extract the ID from the response body
        int userId = responseBody['userId'];

        User? user = FirebaseAuth.instance.currentUser!;
        user.updateDisplayName(userId.toString());     
      }

    });
  }



     

  static Future  logout() async{
    String user = FirebaseAuth.instance.currentUser!.uid;
    await googlesignin.disconnect().whenComplete(() async=>{
      await FirebaseFirestore.instance.collection("userdetails").doc(user).delete(),
    });
    FirebaseAuth.instance.signOut();
  }

}