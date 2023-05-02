import 'dart:convert';

import 'package:http/http.dart' as http show Client;
import 'package:http/http.dart';

class ReminderApi{
  static String baseUrl = "http://192.168.100.100:4321";

  static Future<Response> postReminders(Map<String, dynamic> reminders) async {
    String userApiUrl = "$baseUrl/api/Reminders";
    try {
      http.Client client = http.Client();
      final response = await client.post(
        Uri.parse(userApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(reminders),
      );
      return response;
    } catch (ex) {
      throw Exception('Response error: ${ex.toString()}');
    }


  }
}