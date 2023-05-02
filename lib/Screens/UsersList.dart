import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:persona_calendar/Models/UsersModel.dart';
import 'package:persona_calendar/Services/Apis/UserApi.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  List<UserModel>? users;

  postUsers(){
    var map = Map<String,dynamic>();
    map["userName"] = "Madhu";
    map["mobile"] = "9360224171";
    map["email"] = "srimadhu.j@gmail.com";
    map["hashedPassword"] = "123456";
    final response = UserApi.postUser(map);
    print(response);
    print("Post");
  }

  getUsers(){
    UserApi.getAllUser().then((response)
    {
      print(response.toString());
      try  {
        if(response.statusCode == 200){
          Iterable list = json.decode(response.body);
          print(list);
          List<UserModel> usersList = list.map((model) => UserModel.fromObject(model)).toList();
          setState(() {
            users = usersList;
          });

        }
        else{
          throw Exception('Response error');
        }

      }
      catch(error) {
        throw Exception('Failed to fetch users '+error.toString());
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    getUsers();
    postUsers();
    return Scaffold(
      appBar: AppBar(
        title: const Text("UserList"),
      ),
      body: users == null ?  const Center(
        child: Text("No users"),
      ) : ListView.builder(
        itemCount: users!.length,
          itemBuilder: (context,index){
             return Container(
               alignment: Alignment.center,
               child: Text(users![index].userName,style: const TextStyle(fontSize: 20,color: Colors.black),),
             );
          })
    );
  }
}
