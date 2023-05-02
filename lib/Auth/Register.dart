import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:persona_calendar/Animation/animation.dart';
import 'package:persona_calendar/Auth/GoogleSignIn.dart';
import 'package:persona_calendar/Models/UsersModel.dart';
import 'package:persona_calendar/Services/UserApi.dart';
import 'package:persona_calendar/Services/app_routes.dart';
import 'package:persona_calendar/main.dart';
import 'package:persona_calendar/sizeConfig.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController hashedPassword = TextEditingController();
  TextEditingController userIdText = TextEditingController();

  Map<String, dynamic>? userMap;
  bool obscureText = true;
  bool obscureTextConfirm = true;
  bool autoValidate = false;

  final _formKey = GlobalKey<FormState>();

  String hashPassword(String password) {
    var bytes = utf8.encode(password); // Convert the password to a list of bytes
    var hash = sha256.convert(bytes); // Hash the bytes using SHA-256
    return hash.toString(); // Convert the hash to a string
  }

  Future<String?> _signup() async {
    try{
  

      http.Response response = await UserApi.postUser(userMap!);
    
      if (response.statusCode == 201) {
        // Parse the response body
        Map<String, dynamic> responseBody = json.decode(response.body);

        // Extract the ID from the response body
        int userId = responseBody['userId'];
        userIdText.text = userId.toString();

        // Use the ID in your Flutter code
        print('Created userEvents with ID: $userId');
      } else {
        throw Exception('Failed to create userEvents: ${response.statusCode}');
      }
    }
    catch(ex){
      throw Exception('In post user : ${ex.toString()}');
    }
    try {
      final User? currentUser =
          (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: hashedPassword.text,
      ))
              .user;
      await currentUser!.updateDisplayName(userIdText.text);

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak_password') {
        return "The password is too week";
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exist';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> _alertDialogBox(String error) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Error",
              style: TextStyle(color: Theme.of(context).focusColor),
            ),
            content: Text(
              error,
              style: TextStyle(
                  color: Colors.black, fontSize: SizeConfig.height! * 2.5),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Close",
                    style: TextStyle(color: Colors.blue),
                  )),
            ],
          );
        });
  }

  void _submitForm() async {
    String? feedback = await _signup();
    if (feedback != null) {
      _alertDialogBox(feedback);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  height: SizeConfig.height! * 110,
                  width: SizeConfig.width! * 42,
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(
                          1.0,
                          1.0,
                        ),
                        blurRadius: 6.0,
                        spreadRadius: 2.0,
                      ), //BoxShadow
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ), //BoxShadow
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                          child: FadeAnimation(
                              1.1,
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Persona',
                                        style: TextStyle(
                                            color: Color(0xff00ADB5))),
                                    TextSpan(text: ' Calendar'),
                                  ],
                                ),
                              ))),
                      Expanded(
                          child: FadeAnimation(
                              1.2,
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                  children: <TextSpan>[
                                    TextSpan(text: 'Register')
                                  ],
                                ),
                              ))),
                      Expanded(
                          child: FadeAnimation(
                              1.3,
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'to explore persona calendar')
                                  ],
                                ),
                              ))),
                      Expanded(
                        flex: 12,
                        child: FadeAnimation(
                          1.4,
                          Form(
                            key: _formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: [
                                Expanded(
                                    child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.width! * 4),
                                  height: SizeConfig.height! * 4,
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: Colors.grey.shade500),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: TextFormField(
                                      controller: userName,
                                      validator: (value) {
                                        if (value!.isEmpty && value == "") {
                                          return "User name should not be left empty";
                                        }
                                        return null;
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                          hintText: "User name",
                                          errorMaxLines: 1,
                                          prefixIcon: Icon(
                                            Icons.person,
                                            size: SizeConfig.height! * 3,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 20),
                                          hintStyle: GoogleFonts.poppins(
                                              fontSize:
                                                  SizeConfig.height! * 2.3,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey),
                                          border: InputBorder.none),
                                      style: GoogleFonts.poppins(
                                          fontSize: SizeConfig.height! * 2,
                                          color: Colors.black),
                                    ),
                                  ),
                                )),
                                SizedBox(
                                  height: SizeConfig.height! * 2,
                                ),
                                Expanded(
                                    child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.width! * 4),
                                  height: SizeConfig.height! * 4,
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: Colors.grey.shade500),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: TextFormField(
                                      controller: email,
                                      validator: (value) {
                                        if (value!.isEmpty && value == "") {
                                          return "Email should not be left empty";
                                        }
                                        return null;
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                          hintText: "Email",
                                          errorMaxLines: 1,
                                          prefixIcon: Icon(
                                            Icons.mail,
                                            size: SizeConfig.height! * 3,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 20),
                                          hintStyle: GoogleFonts.poppins(
                                              fontSize:
                                                  SizeConfig.height! * 2.3,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey),
                                          border: InputBorder.none),
                                      style: GoogleFonts.poppins(
                                          fontSize: SizeConfig.height! * 2,
                                          color: Colors.black),
                                    ),
                                  ),
                                )),
                                SizedBox(
                                  height: SizeConfig.height! * 2,
                                ),
                                Expanded(
                                    child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.width! * 4),
                                  height: SizeConfig.height! * 4,
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: Colors.grey.shade500),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: TextFormField(
                                      controller: mobile,
                                      validator: (value) {
                                        if (value!.isEmpty && value == "") {
                                          return "Mobile Number should not be left empty";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                          hintText: "Mobile Number",
                                          errorMaxLines: 1,
                                          prefixIcon: Icon(
                                            Icons.phone,
                                            size: SizeConfig.height! * 3,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 20),
                                          hintStyle: GoogleFonts.poppins(
                                              fontSize:
                                                  SizeConfig.height! * 2.3,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey),
                                          border: InputBorder.none),
                                      style: GoogleFonts.poppins(
                                          fontSize: SizeConfig.height! * 2,
                                          color: Colors.black),
                                    ),
                                  ),
                                )),
                                SizedBox(
                                  height: SizeConfig.height! * 2,
                                ),
                                Expanded(
                                  child: Container(
                                    height: SizeConfig.height! * 4,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: SizeConfig.width! * 4),
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.5,
                                              color: Colors.grey.shade500),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: TextFormField(
                                        controller: password,
                                        validator: (value) {
                                          if (value!.isEmpty && value == "") {
                                            return "Password should not be left empty";
                                          }
                                          return null;
                                        },
                                        obscureText: obscureText,
                                        decoration: InputDecoration(
                                            hintText: "Password",
                                            hintStyle: GoogleFonts.poppins(
                                                fontSize:
                                                    SizeConfig.height! * 2.3,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey),
                                            errorMaxLines: 1,
                                            prefixIcon: Icon(
                                              Icons.lock,
                                              size: SizeConfig.height! * 3,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal: 20),
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  obscureText = !obscureText;
                                                });
                                              },
                                              icon: Icon(obscureText
                                                  ? Icons.visibility
                                                  : Icons.visibility_off),
                                              color: const Color(0xff00ADB5),
                                            ),
                                            border: InputBorder.none),
                                        style: GoogleFonts.poppins(
                                            fontSize: SizeConfig.height! * 2,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.height! * 2,
                                ),
                                Expanded(
                                  child: Container(
                                    height: SizeConfig.height! * 4,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: SizeConfig.width! * 4),
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.5,
                                              color: Colors.grey.shade500),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: TextFormField(
                                        controller: confirmPassword,
                                        validator: (value) {
                                          if (value!.isEmpty && value == "") {
                                            return "Confirm Password should not be left empty";
                                          }
                                          return null;
                                        },
                                        obscureText: obscureTextConfirm,
                                        decoration: InputDecoration(
                                            hintText: "Confirm password",
                                            hintStyle: GoogleFonts.poppins(
                                                fontSize:
                                                    SizeConfig.height! * 2.3,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey),
                                            errorMaxLines: 1,
                                            prefixIcon: Icon(
                                              Icons.lock,
                                              size: SizeConfig.height! * 3,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal: 20),
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  obscureTextConfirm =
                                                      !obscureTextConfirm;
                                                });
                                              },
                                              icon: Icon(obscureTextConfirm
                                                  ? Icons.visibility
                                                  : Icons.visibility_off),
                                              color: const Color(0xff00ADB5),
                                            ),
                                            border: InputBorder.none),
                                        style: GoogleFonts.poppins(
                                            fontSize: SizeConfig.height! * 2,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: FadeAnimation(
                          1.5,
                          Center(
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.width! * 4),
                              child: GestureDetector(
                                onTap: () {
                                  if (!_formKey.currentState!.validate()) {
                                    setState(() {
                                      autoValidate = true;
                                    });
                                    _alertDialogBox(
                                        "No field should be left Empty");
                                  } else {
                                    setState(() {
                                      autoValidate = false;
                                    });
                                    Provider.of<UserModel>(context,listen: false).userName = userName.text;
                                    Provider.of<UserModel>(context,listen: false).mobile = mobile.text;
                                    Provider.of<UserModel>(context,listen: false).email = email.text;
                                    hashedPassword.text = hashPassword(password.text);
                                    Provider.of<UserModel>(context,listen: false).hashedPassword = hashedPassword.text;

                                    userMap = Provider.of<UserModel>(context,listen: false).toMap();
                                    _submitForm();
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: SizeConfig.height! * 6,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color(0xff00ADB5),
                                  ),
                                  child: const Text(
                                    "Submit",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: FadeAnimation(
                              1.5,
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.width! * 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.toNamed(AppRoutes.SignIn);
                                            },
                                          child: RichText(
                                            text: const TextSpan(
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 10),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        'Already have an account?'),
                                                TextSpan(
                                                    text: ' Login',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff00ADB5))),
                                              ],
                                            ),
                                          ),
                                        )),
                                    Expanded(
                                        child: RichText(
                                      text: const TextSpan(
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Forgot password?',
                                          ),
                                        ],
                                      ),
                                    ))
                                  ],
                                ),
                              ))),
                      const Expanded(
                          child: Divider(
                        color: Color(0xffEEEEEE),
                      )),
                      Expanded(
                        flex: 2,
                        child: FadeAnimation(
                          1.5,
                          Center(
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.width! * 4),
                              child: GestureDetector(
                                onTap: () {
                                  googlesigninclass.googleLogin();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: SizeConfig.height! * 6,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: const Color(0xffEEEEEE),
                                          width: 1)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 16),
                                          child: const Image(
                                              image: NetworkImage(
                                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/2008px-Google_%22G%22_Logo.svg.png"))),
                                      const Text(
                                        "Continue with Google",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
