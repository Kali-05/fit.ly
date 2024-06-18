import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_fitness/models/user.dart';

import 'package:workout_fitness/view/authenticate/authenticate.dart';

import 'package:workout_fitness/view/menu/menu_view.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  void navigateToNextScreen() async {
    // Simulate a delay for splash screen
    await Future.delayed(Duration(seconds: 2));

    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => Wrapper()));

    // Retrieve the user from the Provider
    //final user = Provider.of<User?>(context, listen: false);

    ///////
    User? user = FirebaseAuth.instance.currentUser;

    // // Navigate based on user authentication

    if (user == null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => authenticate()));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MenuView(
                userId: user.uid,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Userr?>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Fitness Tracker',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 248, 248, 248),
          ),
        ),
      ),
    );
  }
}
