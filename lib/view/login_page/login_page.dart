// import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
// import 'package:login_org/homepage.dart';
// import 'package:login_org/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_fitness/main.dart';
import 'package:workout_fitness/view/login/on_boarding_view.dart';
import 'package:workout_fitness/view/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isDataMatched = true;
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 250,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(116, 255, 255, 255),
                            borderRadius: BorderRadius.circular(8)),
                        width: 310,
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 287,
                                height: 40,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: TextFormField(
                                    controller: _usernameController,
                                    decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1.0)),
                                      hintText: 'username',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'error';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 287,
                                height: 40,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 1.0),
                                      ),
                                      hintText: 'password',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'error';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 23,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Visibility(
                                    visible: !isDataMatched,
                                    child: const Text(
                                      "Username Doesnot matched",
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 0, 0, 0),
                                        shape: ContinuousRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      onPressed: () {
                                        if (_formkey.currentState!.validate()) {
                                          checkLogin(context);
                                        } else {
                                          print('empty');
                                        }
                                      },
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white),
                                      ))
                                ],
                              )
                              // SizedBox(
                              //   width: double.infinity,
                              //   child: TextButton(
                              //       style: TextButton.styleFrom(
                              //           backgroundColor:
                              //               const Color.fromARGB(255, 0, 0, 0),
                              //           shape: ContinuousRectangleBorder(
                              //               borderRadius:
                              //                   BorderRadius.circular(10))),
                              //       onPressed: () {
                              //         checkLogin();
                              //       },
                              //       child: const Text(
                              //         'Login',
                              //         style: TextStyle(
                              //             fontSize: 28,
                              //             fontWeight: FontWeight.w800,
                              //             color: Colors.white),
                              //       )),
                              // )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (ctx1) => SignupScreen()));
                        },
                        child: const Text(
                          'dont have any account ? signup',
                          style: TextStyle(
                            color: Color.fromARGB(255, 239, 239, 239),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Visibility(
                        visible: !isDataMatched,
                        child: const Text(
                          'Incorrect Username or Password Try Again',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkLogin(BuildContext ctx) async {
    final newUserName = _usernameController.text;
    final newPassword = _passwordController.text;
    if (newUserName == newPassword) {
      //go to home
      print("match");

      final sharedpref = await SharedPreferences.getInstance();
      await sharedpref.setBool(SAVE_KEY_NAME, true);
      Navigator.of(ctx).pushReplacement(
          MaterialPageRoute(builder: (ctx1) => OnBoardingView()));
    } else {
      final _errorMessage = 'Username And Password Doesnt Match';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          content: Text(_errorMessage)));
      //popup
    }
  }
}
