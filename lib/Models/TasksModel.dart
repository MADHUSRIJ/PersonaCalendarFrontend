import 'package:flutter/material.dart';

class TaskModel with ChangeNotifier {
  int? _taskId;
  String? _taskTitle;
  String? _taskDate;
  String? _taskTime;
  String? _occurance;
  String? _description;
  bool? _notification;

  int? get taskId => _taskId;
  String get taskTitle => _taskTitle!;
  String get taskDate => _taskDate!;
  String get taskTime => _taskTime!;
  String get occurance => _occurance!;
  String get description => _description!;
  bool get notification => _notification!;

  TaskModel(this._taskTitle, this._taskDate, this._taskTime, this._occurance,
      this._description, this._notification);
  TaskModel.withId(this._taskId, this._taskTitle, this._taskDate,
      this._taskTime, this._occurance, this._description, this._notification);

  TaskModel.fromObject(dynamic object) {
    _taskId = object["taskId"];
    _taskTitle = object["taskTitle"];
    _taskDate = object["taskDate"];
    _taskTime = object["taskTime"];
    _occurance = object["occurance"];
    _description = object["description"];
    _notification = object["notification"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["taskId"] = _taskId;
    map["taskTitle"] = _taskTitle;
    map["taskDate"] = _taskDate;
    map["taskTime"] = _taskTime;
    map["occurance"] = _occurance;
    map["description"] = _description;
    map["notification"] = _notification;
    return map;
  }
}