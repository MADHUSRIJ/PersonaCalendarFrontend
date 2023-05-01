import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:persona_calendar/Auth/Register.dart';
import 'package:persona_calendar/Auth/SignIn.dart';
import 'package:persona_calendar/Models/UsersModel.dart';
import 'package:persona_calendar/Screens/Home/Home.dart';
import 'package:persona_calendar/Screens/UsersList.dart';
import 'package:persona_calendar/Services/NavigationState.dart';
import 'package:persona_calendar/sizeConfig.dart';
import 'package:provider/provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());

}


class Routes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationState(),
      child: MaterialApp(
        title: 'Route',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (context) => MyApp());
            case '/register':
              print("Hey");
              return MaterialPageRoute(builder: (context) => const Register());
            default:
              return null;
          }
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: const FirebaseOptions(  
      apiKey: "AIzaSyD11yXVlTI31yQEV7JvFVwDxJcqs6ZWEZk",
      authDomain: "calendar-6ad09.firebaseapp.com",
      projectId: "calendar-6ad09",
      storageBucket: "calendar-6ad09.appspot.com",
      messagingSenderId: "983009985771",
      appId: "1:983009985771:web:230b9a9037688f59bf2aae",
      measurementId: "G-KQ4YV3904W"
      )
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationState(),
      child: MaterialApp(
        title: 'Persona Calendar',
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (context) => MyApp());
            case '/register':
              print("Hey");
              return MaterialPageRoute(builder: (context) => const Register());
            default:
              return null;
          }
        },
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: _initialization,
          builder: (context,snapshot){
            if(snapshot.hasError){
             return Center(
               child: Text("Snapshot Error Initializing the app\n +${snapshot.error.toString()}"),
             );
            }

            if(snapshot.connectionState == ConnectionState.done){
              SizeConfig.init(context);
              User? user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                return const UserDetails();
              } else {
                return UserModelRouting(userName: user.displayName!, email: user.email!, mobile: user.phoneNumber!);
              }
            }
            return Center(child: Container(
              height: 48,
                width: 48,
                child: const CircularProgressIndicator()));
          },
        ),
      ),
    );
  }
}

class UserModelRouting extends StatelessWidget {
  final String userName;
  final String email;
  final String mobile;
  const UserModelRouting({Key? key, required this.userName, required this.email, required this.mobile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>.value(value: (UserModel.details(userName,email,mobile))),
      ],
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}


