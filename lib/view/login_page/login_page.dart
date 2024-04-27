// import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:workout_fitness/models/user.dart';
import 'package:workout_fitness/services/auth.dart';

// import 'package:login_org/homepage.dart';
// import 'package:login_org/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_fitness/main.dart';
import 'package:workout_fitness/view/login/on_boarding_view.dart';
import 'package:workout_fitness/view/menu/menu_view.dart';
import 'package:workout_fitness/view/signup.dart';

class LoginScreen extends StatefulWidget {
  //const LoginScreen({super.key});
  final Function? toggleView;
  const LoginScreen({this.toggleView});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isDataMatched = true;
  final _formkey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String error = '';
  String email = '';
  String password = '';
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    //if (user == null) {
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
                                                color: Colors.white,
                                                width: 1.0)),
                                        hintText: 'username',
                                      ),
                                      onChanged: (value) {
                                        setState(() => email = value);
                                      },
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
                                      onChanged: (value) {
                                        setState(() => password = value);
                                      },
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
                                        onPressed: () async {
                                          if (_formkey.currentState!
                                              .validate()) {
                                            //checkLogin(context);

                                            dynamic result =
                                                await _auth.LoginWithEmail(
                                                    email, password);

                                            // print('User ID: ${user?.uid}');

                                            if (user != null) {
                                              print('User ID: ${user?.uid}');
                                            } else {
                                              print('User is not logged in');
                                            }

                                            if (result == null) {
                                              setState(() => error =
                                                  'please supply a valid email');
                                            }
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
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            // Navigator.of(context).pushReplacement(
                            //     MaterialPageRoute(
                            //         builder: (ctx1) => SignupScreen()));

                            widget.toggleView!();
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
                        GestureDetector(
                          onTap: () async {
                            dynamic result = await _auth.signinAnon();
                            if (result == null) {
                              print("error signin in");
                            } else {
                              print('signed in');
                              print(result.uid);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (ctx1) => OnBoardingView()));
                            }
                          },
                          child: const Text(
                            'Login Anonimously',
                            style: TextStyle(
                              color: Color.fromARGB(255, 239, 239, 239),
                            ),
                          ),
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
        ));
    // } else {
    //   return MenuView();
    // }
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
