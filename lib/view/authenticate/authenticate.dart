import 'package:flutter/material.dart';
import 'package:workout_fitness/view/login_page/login_page.dart';
import 'package:workout_fitness/view/signup.dart';

class authenticate extends StatefulWidget {
  const authenticate({super.key});

  @override
  State<authenticate> createState() => _authenticateState();
}

class _authenticateState extends State<authenticate> {
  bool showSignin = true;
  void toggleView() {
    setState(
      () => showSignin = !showSignin,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (showSignin) {
      return LoginScreen(toggleView: toggleView);
    } else {
      return SignupScreen(toggleView: toggleView);
    }
  }
}
