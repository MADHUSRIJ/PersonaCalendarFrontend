import 'package:flutter/material.dart';

class RemainderModel with ChangeNotifier {

  int? _remainderId;
  String? _remainderDate;
  String? _remainderTime;
  String? _occurance;
  String? _description;
  String? _access;

  int? get remainderId => _remainderId;
  String get remainderDate => _remainderDate!;
  String get remainderTime => _remainderTime!;
  String get occurance => _occurance!;
  String get description => _description!;
  String get access => _access!;


  RemainderModel(
      this._remainderId,
      this._remainderDate,
      this._remainderTime,
      this._occurance,
      this._description,this._access);
  RemainderModel.withId(
      this._remainderId,
      this._remainderDate,
      this._remainderTime,
      this._occurance,
      this._description,this._access);

  RemainderModel.fromObject(dynamic object) {
    _remainderId = object["reminderId"];
    _remainderDate = object["reminderDate"];
    _remainderTime = object["reminderTime"];
    _occurance = object["reminderOccurence"];
    _description = object["reminderDescription"];
    _access = object["access"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["reminderId"] = _remainderId;
    map["reminderDate"] = _remainderDate;
    map["reminderTime"] = _remainderTime;
    map["reminderOccurence"] = _occurance;
    map["reminderDescription"] = _description;
    map["access"] = _access;
    return map;
  }
}