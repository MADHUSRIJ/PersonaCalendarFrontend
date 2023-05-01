import 'package:flutter/material.dart';

class NotesModel with ChangeNotifier {

  int? _notesId;
  String? _notesTitle;
  String? _description;

  int? get notesId => _notesId;
  String? get notesTitle => _notesTitle;
  String? get description => _description;

  NotesModel(this._notesTitle, this._description);

  NotesModel.withId(this._notesId, this._notesTitle, this._description);

  NotesModel.fromObject(dynamic object) {
    _notesId = object["notesId"];
    _notesTitle = object["notesTitle"];
    _description = object["notesBody"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["notesId"] = _notesId;
    map["notesTitle"] = _notesTitle;
    map["notesBody"] = _description;
    return map;
  }
}