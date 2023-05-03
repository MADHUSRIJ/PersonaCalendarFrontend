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
  static final googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
    clientId: '983009985771-901ek37g5p1f2912n44t0s5n5geogf8a.apps.googleusercontent.com',

  );
  TextEditingController userIdText = TextEditingController();
  static GoogleSignInAccount? _user;
  
  static Future googleLogin() async{
    try{
      final googleUser = await googleSignIn.signIn();

      if(googleUser == null)
      {
        return MyApp();
      }
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential).whenComplete(() async{

        Map<String, dynamic>? userMap;
        userMap = Map<String,dynamic>();
        userMap["userName"] = _user!.displayName!;
        userMap["mobile"] = "0";
        userMap["email"] = _user!.email;
        userMap["hashedPassword"] = "0";

        http.Response response = await UserApi.postUser(userMap);

        if (response.statusCode == 201) {
          // Parse the response body

          Map<String, dynamic> responseBody = json.decode(response.body);

          // Extract the ID from the response body
          int userId = responseBody['userId'];

          print("Hey $userId");

          User? user = FirebaseAuth.instance.currentUser!;
          user.updateDisplayName(userId.toString());

        }

      });
    }
    catch(ex){
      print("Google "+ex.toString());
    }



  }

     

  static Future  logout() async{
    FirebaseAuth.instance.signOut();
  }

}