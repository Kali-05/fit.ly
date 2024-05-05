import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_fitness/models/user.dart';
import 'package:workout_fitness/view/authenticate/authenticate.dart';
import 'package:workout_fitness/view/login/on_boarding_view.dart';
import 'package:workout_fitness/view/login_page/login_page.dart';
import 'package:workout_fitness/view/menu/menu_view.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  //final userr = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Userr?>(context);

    if (user == null) {
      return authenticate();
    } else {
      return MenuView(
        userId: user.uid,
      );
    }

    // return StreamBuilder<User?>(
    //     stream: FirebaseAuth.instance.authStateChanges(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         // Show loading indicator if authentication state is not yet determined
    //         return CircularProgressIndicator();
    //       }
    //       if (snapshot.hasData) {
    //         return MenuView();
    //       } else {
    //         return LoginScreen();
    //       }
    //     });
  }
}
