import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persona_calendar/Auth/Register.dart';
import 'package:persona_calendar/Auth/SignIn.dart';
import 'package:persona_calendar/Models/UsersModel.dart';
import 'package:persona_calendar/Screens/Home/Home.dart';
import 'package:persona_calendar/Services/Apis/UserApi.dart';
import 'package:persona_calendar/Services/app_routes.dart';
import 'package:persona_calendar/sizeConfig.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>.value(value: (UserModel())),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Routing(),
      ),
    );
  }
}

class Routing extends StatefulWidget {
  const Routing({Key? key}) : super(key: key);

  @override
  State<Routing> createState() => _RoutingState();
}

class _RoutingState extends State<Routing> {

  String? displayName;

  Future auth() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    displayName = prefs.getString('displayName');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    if (displayName != null) {
      return UserModelRouting(userId: displayName!);
    }

    return MediaQuery(
      data: const MediaQueryData(),
      child: GetMaterialApp(
        title: 'MyApp',
        initialRoute: AppRoutes.MyApp,
        debugShowCheckedModeBanner: false,
        getPages: [
          GetPage(
              name: AppRoutes.HomePage,
              page: () => UserModelRouting(
                  userId: FirebaseAuth.instance.currentUser!.displayName!)),
          GetPage(name: AppRoutes.MyApp, page: () => MyApp()),
          GetPage(name: AppRoutes.SignIn, page: () => const SignIn()),
          GetPage(name: AppRoutes.Register, page: () => const Register()),
        ],
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
          measurementId: "G-KQ4YV3904W"));

  Future<Widget> _authorize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? displayName = prefs.getString('displayName');

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: SizedBox(
                  height: 48, width: 48, child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          if (displayName == null) {
            // Save the user's display name in SharedPreferences
            prefs.setString('displayName', snapshot.data!.displayName!);
          }

          return UserModelRouting(userId: snapshot.data!.displayName!);
        } else {
          return const SignIn();
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>.value(value: (UserModel())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                    "Snapshot Error Initializing the app\n +${snapshot.error.toString()}"),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              SizeConfig.init(context);
              return StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    return FutureBuilder(
                      future: _authorize(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return snapshot.data!;
                        } else {
                          return const Center(
                              child: SizedBox(
                                  height: 48,
                                  width: 48,
                                  child: CircularProgressIndicator()));
                        }
                      },
                    );
                  });
            }

            return const Center(
                child: SizedBox(
                    height: 48, width: 48, child: CircularProgressIndicator()));
          },
        ),
      ),
    );
  }
}

class UserModelRouting extends StatefulWidget {
  final String userId;
  const UserModelRouting({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserModelRouting> createState() => _UserModelRoutingState();
}

class _UserModelRoutingState extends State<UserModelRouting> {
  bool initialized = false;
  UserModel? userModel;
  void initializeData() async {
    Map<String, dynamic> map = await UserApi.getUser(int.parse(widget.userId));
    userModel = Provider.of<UserModel>(context, listen: false);
    userModel!.userName = map["userName"];
    userModel!.mobile = map["mobile"];
    userModel!.email = map["email"];
    userModel!.userId = map["userId"];
    userModel!.userEvents = map["Events"];
    userModel!.userTasks = map["Tasks"];
    userModel!.userReminder = map["Reminder"];
    userModel!.userNotes = map["Notes"];

    //print("UserModel ${userModel!.userName}");
    setState(() {
      initialized = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return initialized
        ? HomePage(
            userModel: userModel!,
          )
        : const Center(
            child: SizedBox(
                height: 48, width: 48, child: CircularProgressIndicator()));
  }
}
