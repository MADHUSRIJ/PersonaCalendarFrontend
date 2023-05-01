import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persona_calendar/Auth/Register.dart';
import 'package:persona_calendar/Auth/SignIn.dart';
import 'package:persona_calendar/Models/UsersModel.dart';
import 'package:persona_calendar/Screens/Home/Home.dart';
import 'package:persona_calendar/Screens/UsersList.dart';
import 'package:persona_calendar/Services/NavigationState.dart';
import 'package:persona_calendar/Services/UserApi.dart';
import 'package:persona_calendar/Services/app_routes.dart';
import 'package:persona_calendar/sizeConfig.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    App()
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Routing(),
    );
  }
}


class Routing extends StatefulWidget {
  const Routing({Key? key}) : super(key: key);

  @override
  State<Routing> createState() => _RoutingState();
}

class _RoutingState extends State<Routing> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MediaQuery(
      data: const MediaQueryData(),
      child: GetMaterialApp(
        title: 'MyApp',
        initialRoute: AppRoutes.MyApp,
        getPages: [
          GetPage(name: AppRoutes.HomePage, page: () => UserModelRouting(userId: FirebaseAuth.instance.currentUser!.displayName!)),
          GetPage(name: AppRoutes.MyApp, page: () => MyApp()),
          GetPage(name: AppRoutes.SignIn, page: () => SignIn()),
          GetPage(name: AppRoutes.Register, page: () => Register()),
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

  // This widget is the root of your application.
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
              User? user = FirebaseAuth.instance.currentUser;
              print(user);
              print("User");
              if (user == null) {
                return const SignIn();
              } else {
                return UserModelRouting(userId: user.displayName!);
              }
            }
            return Center(
                child: Container(
                    height: 48,
                    width: 48,
                    child: const CircularProgressIndicator()));
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
  void initializeData() async{
    Map<String,dynamic> map = await UserApi.getUser(int.parse(widget.userId));
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    userModel.userName = map["userName"];
    userModel.mobile = map["mobile"];
    userModel.email = map["email"];
    userModel.userId = map["userId"];
    print("UserModel ${userModel.userName}");
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

    return initialized ? HomePage() : CircularProgressIndicator();
  }
}
