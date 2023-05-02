import 'dart:convert';

import 'package:http/http.dart' as http show Client;
import 'package:http/http.dart';

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
}







