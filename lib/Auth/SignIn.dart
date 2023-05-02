import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:persona_calendar/Animation/animation.dart';
import 'package:persona_calendar/Auth/Register.dart';
import 'package:persona_calendar/Auth/GoogleSignIn.dart';
import 'package:persona_calendar/Models/UsersModel.dart';
import 'package:persona_calendar/Services/NavigationState.dart';
import 'package:persona_calendar/Services/Apis/UserApi.dart';
import 'package:persona_calendar/Services/app_routes.dart';
import 'package:persona_calendar/main.dart';
import 'package:persona_calendar/sizeConfig.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  TextEditingController hashedPassword = TextEditingController();

  bool obscureText = true;
  bool autoValidate = false;

  final _formKey = GlobalKey<FormState>();

  String hashPassword(String password) {
    var bytes =
        utf8.encode(password); // Convert the password to a list of bytes
    var hash = sha256.convert(bytes); // Hash the bytes using SHA-256
    return hash.toString(); // Convert the hash to a string
  }

  Future<String?> _loginAccount() async {
    try {
      final User? currentUser =
          (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: hashedPassword.text,
      ))
              .user;

      return null;
    } on FirebaseAuthException catch (e) {
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
            title: const Text(
              "Field Required",
              style: TextStyle(fontSize: 16, color: Color(0xff00ADB5)),
            ),
            content: Text(
              error,
              style: const TextStyle(color: Color(0xff393E46), fontSize: 12),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff00ADB5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: const Text(
                      "Close",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          );
        });
  }

  void submitForm() async {
    String? feedback = await _loginAccount();
    if (feedback != null) {
      _alertDialogBox(feedback);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Center(
              child: Container(
                alignment: Alignment.center,
                height: SizeConfig.height! * 76,
                width: SizeConfig.width! * 36,
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
                                    fontWeight: FontWeight.w500, fontSize: 20),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Persona',
                                      style:
                                          TextStyle(color: Color(0xff00ADB5))),
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
                                    fontWeight: FontWeight.w500, fontSize: 16),
                                children: <TextSpan>[TextSpan(text: 'Sign in')],
                              ),
                            ))),
                    Expanded(
                        child: FadeAnimation(
                            1.3,
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 12),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'to continue with persona calendar')
                                ],
                              ),
                            ))),
                    Expanded(
                      flex: 4,
                      child: FadeAnimation(
                        1.4,
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                      borderRadius: BorderRadius.circular(10)),
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
                                            fontSize: SizeConfig.height! * 2.3,
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
                                                  vertical: 15, horizontal: 20),
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
                                  Provider.of<UserModel>(context, listen: false)
                                      .email = email.text;
                                  hashedPassword.text =
                                      hashPassword(password.text);
                                  Provider.of<UserModel>(context, listen: false)
                                      .hashedPassword = hashedPassword.text;

                                  submitForm();
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
                                          Get.toNamed(AppRoutes.Register);
                                        },
                                        child: RichText(
                                          text: const TextSpan(
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text:
                                                      'Do not have an account?'),
                                              TextSpan(
                                                  text: ' Register',
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
            )));
  }
}
