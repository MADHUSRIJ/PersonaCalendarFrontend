import 'dart:convert';

import 'package:http/http.dart' as http show Client;
import 'package:http/http.dart';
import 'package:persona_calendar/Models/EventsModel.dart';
import 'package:persona_calendar/Models/NotesModel.dart';
import 'package:persona_calendar/Models/ReminderModel.dart';
import 'package:persona_calendar/Models/TasksModel.dart';

class UserApi{
  static String baseUrl = "http://192.168.100.100:4321";
  static Future getAllUser() async{
    String userApiUrl = "$baseUrl/api/users";
    try{
      http.Client client = http.Client();
      final response = await client.get(Uri.parse(userApiUrl));
      if (response.statusCode == 200) {
        return response;
      }
      return null;
    }
    catch(ex){
      throw Exception('Response error: ${ex.toString()}');
    }
  }
  static Future<Map<String, dynamic>> getUser(int id) async {
    String userApiUrl = "$baseUrl/api/users/$id";
    try {
      http.Client client = http.Client();
      final response = await client.get(Uri.parse(userApiUrl));
      if(response.statusCode == 200){
        Map<String, dynamic> responseBody = json.decode(response.body);
        int userId = responseBody["userId"];
        responseBody["Events"] = await getUserEvents(userId);
        responseBody["Tasks"] = await getUserTasks(userId);
        responseBody["Reminder"] = await getUserReminder(userId);
        responseBody["Notes"] = await getUserNotes(userId);

        return responseBody;
      }
      else{
        throw Exception('Response error');
      }
    } catch (ex) {
      throw Exception('Response error: ${ex.toString()}');
    }
  }
  static Future<Response> postUser(Map<String, dynamic> user) async {

    String userApiUrl = "$baseUrl/api/users";
    try {

      http.Client client = http.Client();

      final response = await client.post(
        Uri.parse(userApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user),
      );
      return response;
    } catch (ex) {
      throw Exception('Response error: ${ex.toString()}');
    }
  }


  static Future<List<EventsModel>> getUserEvents(int userId) async{
    String userApiUrl = "$baseUrl/api/users/$userId/events";
    try{
      http.Client client = http.Client();
      final response = await client.get(Uri.parse(userApiUrl));
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        print(list);
        List<EventsModel> eventsList = list.map((model) => EventsModel.fromObject(model)).toList();
        return eventsList;
      }
      return [];
    }
    catch(ex){
      throw Exception('Response error: ${ex.toString()}');
    }
  }

  static Future<List<NotesModel>> getUserNotes(int userId) async{
    String userApiUrl = "$baseUrl/api/users/$userId/notes";
    try{
      http.Client client = http.Client();
      final response = await client.get(Uri.parse(userApiUrl));
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        print(list);
        List<NotesModel> notesList = list.map((model) => NotesModel.fromObject(model)).toList();
        return notesList;
      }
      return [];
    }
    catch(ex){
      throw Exception('Response error: ${ex.toString()}');
    }
  }
  static Future<List<TaskModel>> getUserTasks(int userId) async{
    String userApiUrl = "$baseUrl/api/users/$userId/tasks";
    try{
      http.Client client = http.Client();
      final response = await client.get(Uri.parse(userApiUrl));
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        print(list);
        List<TaskModel> tasksList = list.map((model) => TaskModel.fromObject(model)).toList();
        return tasksList;
      }
      return [];
    }
    catch(ex){
      throw Exception('Response error: ${ex.toString()}');
    }
  }

  static Future<List<RemainderModel>> getUserReminder(int userId) async{
    String userApiUrl = "$baseUrl/api/users/$userId/reminder";
    try{
      http.Client client = http.Client();
      final response = await client.get(Uri.parse(userApiUrl));
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        print(list);
        List<RemainderModel> reminderList = list.map((model) => RemainderModel.fromObject(model)).toList();
        return reminderList;
      }
      return [];
    }
    catch(ex){
      throw Exception('Response error: ${ex.toString()}');
    }
  }
}







