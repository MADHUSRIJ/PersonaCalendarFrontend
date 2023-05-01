import 'package:flutter/material.dart';

class RemainderModel with ChangeNotifier {

  int? _remainderId;
  String? _remainderDate;
  String? _remainderTime;
  String? _occurance;
  String? _description;

  int? get remainderId => _remainderId;
  String get remainderDate => _remainderDate!;
  String get remainderTime => _remainderTime!;
  String get occurance => _occurance!;
  String get description => _description!;


  RemainderModel(
      this._remainderId,
      this._remainderDate,
      this._remainderTime,
      this._occurance,
      this._description);
  RemainderModel.withId(
      this._remainderId,
      this._remainderDate,
      this._remainderTime,
      this._occurance,
      this._description);

  RemainderModel.fromObject(dynamic object) {
    _remainderId = object["remainderId"];
    _remainderDate = object["remainderDate"];
    _remainderTime = object["remainderTime"];
    _occurance = object["occurance"];
    _description = object["reminderDescription"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["remainderId"] = _remainderId;
    map["remainderDate"] = _remainderDate;
    map["remainderTime"] = _remainderTime;
    map["occurance"] = _occurance;
    map["reminderDescription"] = _description;
    return map;
  }
}