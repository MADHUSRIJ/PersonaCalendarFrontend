import 'package:flutter/material.dart';
import 'package:persona_calendar/Models/EventsModel.dart';
import 'package:persona_calendar/Models/NotesModel.dart';
import 'package:persona_calendar/Models/ReminderModel.dart';
import 'package:persona_calendar/Models/TasksModel.dart';

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

  UserModel();
  UserModel.details(this._userName,this._email,this._mobile);
  UserModel.withId(this._userId,this._userName,this._email,this._mobile);


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

    return map;
  }

}