import 'package:flutter/material.dart';

class EventsModel with ChangeNotifier {
  int? _eventId;
  String? _eventTitle;
  String? _startDate;
  String? _endDate;
  String? _startTime;
  String? _endTime;
  String? _occurance;
  String? _location;
  String? _description;
  bool? _notification;

  int? get eventId => _eventId;
  String get eventTitle => _eventTitle!;
  String get startDate => _startDate!;
  String get endDate => _endDate!;
  String get startTime => _startTime!;
  String get endTime => _endTime!;
  String get occurance => _occurance!;
  String get location => _location!;
  String get description => _description!;
  bool get notification => _notification!;

  EventsModel();
  EventsModel.details(
      this._eventTitle,
      this._startDate,
      this._endDate,
      this._startTime,
      this._endTime,
      this._occurance,
      this._location,
      this._description,
      this._notification);
  EventsModel.withId(
      this._eventId,
      this._eventTitle,
      this._startDate,
      this._endDate,
      this._startTime,
      this._endTime,
      this._occurance,
      this._location,
      this._description,
      this._notification);

  EventsModel.fromObject(dynamic object) {
    _eventId = object["eventId"];
    _eventTitle = object["eventTitle"];
    _startDate = object["startDate"];
    _endDate = object["endDate"];
    _startTime = object["startTime"];
    _endTime = object["endTime"];
    _occurance = object["occurance"];
    _location = object["location"];
    _description = object["eventDescription"];
    _notification = object["notification"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["eventId"] = _eventId;
    map["eventTitle"] = _eventTitle;
    map["startDate"] = _startDate;
    map["endDate"] = _endDate;
    map["startTime"] = _startTime;
    map["endTime"] = _endTime;
    map["occurance"] = _occurance;
    map["location"] = _location;
    map["eventDescription"] = _description;
    map["notification"] = _notification;
    return map;
  }
}