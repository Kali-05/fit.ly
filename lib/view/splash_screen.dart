import 'package:flutter/material.dart';

import 'package:workout_fitness/view/login_page/login_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 2500), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return LoginScreen();
      }));
    });

    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Text(
        'Fitness Tracker',
        style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 248, 248, 248)),
      )),
    );
  }
}
