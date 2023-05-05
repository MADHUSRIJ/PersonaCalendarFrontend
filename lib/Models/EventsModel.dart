import 'package:flutter/material.dart';

class EventsModel with ChangeNotifier {
  int? _eventId;
  String? _eventTitle;
  String? _startDate;
  String? _endDate;
  String? _startTime;
  String? _endTime;
  String? _location;
  String? _description;
  String? _access;
  bool? _notification;

  int? get eventId => _eventId;
  String get eventTitle => _eventTitle!;
  String get startDate => _startDate!;
  String get endDate => _endDate!;
  String get startTime => _startTime!;
  String get endTime => _endTime!;
  String get location => _location!;
  String get description => _description!;
  bool get notification => _notification!;
  String get access => _access!;

  EventsModel();
  EventsModel.details(
      this._eventTitle,
      this._startDate,
      this._endDate,
      this._startTime,
      this._endTime,
      this._location,
      this._description,
      this._notification,
      this._access);
  EventsModel.withId(
      this._eventId,
      this._eventTitle,
      this._startDate,
      this._endDate,
      this._startTime,
      this._endTime,
      this._location,
      this._description,
      this._notification,this._access);

  EventsModel.fromObject(dynamic object) {
    _eventId = object["eventId"];
    _eventTitle = object["eventTitle"];
    _startDate = object["startDate"];
    _endDate = object["endDate"];
    _startTime = object["startTime"];
    _endTime = object["endTime"];
    _location = object["location"];
    _description = object["eventDescription"];
    _notification = object["eventNotification"];
    _access = object["access"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["eventId"] = _eventId;
    map["eventTitle"] = _eventTitle;
    map["startDate"] = _startDate;
    map["endDate"] = _endDate;
    map["startTime"] = _startTime;
    map["endTime"] = _endTime;
    map["location"] = _location;
    map["eventDescription"] = _description;
    map["eventNotification"] = _notification;
    map["access"] = _access;
    return map;
  }
}