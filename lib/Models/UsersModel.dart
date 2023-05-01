import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persona_calendar/Models/EventsModel.dart';
import 'package:persona_calendar/Models/NotesModel.dart';
import 'package:persona_calendar/Models/ReminderModel.dart';
import 'package:persona_calendar/Models/TasksModel.dart';
import 'package:persona_calendar/Services/UserApi.dart';
import 'package:http/http.dart' as http;

class UserModel with ChangeNotifier{
  int? _userId;
  String? _userName;
  String? _email;
  String? _mobile;
  String? _hashedPassword;
  List<EventsModel>? _userEvents;
  List<TaskModel>? _userTasks;
  List<RemainderModel>? _userReminder;
  List<NotesModel>? _userNotes;

  int get userId => _userId!;
  String get userName => _userName!;
  String get email => _email!;
  String get mobile => _mobile!;
  String get hashedPassword => _hashedPassword!;
  List<EventsModel> get userEvents => _userEvents!;
  List<TaskModel> get userTasks => _userTasks!;
  List<RemainderModel> get userReminder => _userReminder!;
  List<NotesModel> get userNotes => _userNotes!;


  set userId(int value) {
    _userId = value;
    notifyListeners();
  }

  UserModel();
  UserModel.id(this._userId);
  UserModel.details(this._userName,this._email,this._mobile);
  UserModel.withId(this._userId,this._userName,this._email,this._mobile);

  void getData(int id, User? currentUser) async{
    try {
      Map<String, dynamic> object = await UserApi.getUser(int.parse(currentUser!.displayName!));
      _userId = object["userId"];
      _userName = object["userName"];
      _mobile = object["mobile"];
      _email = object["email"];
    }
    catch(error) {
      throw Exception('Failed to fetch users '+error.toString());
    }
  }

  UserModel.withMap(Map<String,dynamic> object){
    _userId = object["userId"];
    _userName = object["userName"];
    _mobile = object["mobile"];
    _email = object["email"];

    print("UserModel $_mobile");
    notifyListeners();
  }


  UserModel.fromObject(dynamic object){
    _userId = object["userId"];
    _userName = object["userName"];
    _mobile = object["mobile"];
    _email = object["email"];
    _hashedPassword = object["hashedPassword"];
  }

  Map<String,dynamic> toMap() {
    var map = Map<String,dynamic>();
    map["userName"] = _userName;
    map["mobile"] = _mobile;
    map["email"] = _email;
    map["hashedPassword"] = _hashedPassword;

    print("Hello");
    return map;
  }

  set userName(String value) {
    _userName = value;
    notifyListeners();
  }

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  set mobile(String value) {
    _mobile = value;
    notifyListeners();
  }

  set hashedPassword(String value) {
    _hashedPassword = value;
    notifyListeners();
  }

  set userEvents(List<EventsModel> value) {
    _userEvents = value;
    notifyListeners();
  }

  set userTasks(List<TaskModel> value) {
    _userTasks = value;
    notifyListeners();
  }

  set userReminder(List<RemainderModel> value) {
    _userReminder = value;
    notifyListeners();
  }

  set userNotes(List<NotesModel> value) {
    _userNotes = value;
    notifyListeners();
  }
}