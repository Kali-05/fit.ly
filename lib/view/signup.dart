import 'package:flutter/material.dart';

import 'package:workout_fitness/services/auth.dart';
import 'package:workout_fitness/view/login/on_boarding_view.dart';

class SignupScreen extends StatefulWidget {
  final Function? toggleView;
  //SignupScreen({this.toggleView});
  const SignupScreen({this.toggleView});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _auth = AuthService();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';

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
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 250,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(116, 255, 255, 255),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: 310,
                        height: 280,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 12),
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
                                          width: 1.0,
                                        ),
                                      ),
                                      hintText: 'Username',
                                    ),
                                    onChanged: (value) {
                                      setState(() => email = value);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a username';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
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
                                          color: Colors.white,
                                          width: 1.0,
                                        ),
                                      ),
                                      hintText: 'Password',
                                    ),
                                    onChanged: (value) {
                                      setState(() => password = value);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a password';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: 287,
                                height: 40,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 1.0,
                                        ),
                                      ),
                                      hintText: 'Confirm Password',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      }
                                      if (value != _passwordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 23),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.black, // Adjusted color
                                  shape: const ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    //_signup(context);

                                    dynamic result =
                                        await _auth.RegisterWithEmail(
                                            email, password);
                                    if (result == null) {
                                      setState(() => error =
                                          'please supply a valid email');
                                    } else {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OnBoardingView(
                                              userId: result.uid),
                                        ),
                                      );
                                    }
                                    //else {
                                    //   Navigator.pushReplacement(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => LoginScreen(),
                                    //     ),
                                    //   );
                                    // }
                                  }
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => LoginScreen(),
                          //   ),
                          // );

                          widget.toggleView!();
                        },
                        child: const Text(
                          'Already have an account? Login',
                          style: TextStyle(
                            color: Color.fromARGB(255, 239, 239, 239),
                          ),
                        ),
                      ),
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

  // void _signup(BuildContext context) async {
  //   // Implement your signup logic here
  //   final newUserName = _usernameController.text;
  //   final newPassword = _passwordController.text;

  //   // For demonstration purposes, let's just print the username and password
  //   print('Username: $newUserName');
  //   print('Password: $newPassword');

  //   // You can add further logic here, such as saving the user to a database

  //   // For now, let's navigate back to the login screen

  //   //moving to loginpage after signup

  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => MenuView(),
  //     ),
  //   );
  // }
}
