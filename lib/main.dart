import 'package:flutter/material.dart';
import 'package:workout_fitness/view/login/on_boarding_view.dart';
// import 'package:workout_fitness/view/login/on_boarding_view.dart';
// import 'package:workout_fitness/view/login/step1_view.dart';
// import 'package:workout_fitness/view/login/step3_view.dart';
import 'package:workout_fitness/view/login_page/login_page.dart';
import 'package:workout_fitness/view/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workout_fitness/view/splash_screen.dart';
// // import 'package:workout_fitness/view/login/on_boarding_view.dart';
// import 'package:workout_fitness/view/menu/menu_view.dart';

import 'common/color_extension.dart';

const SAVE_KEY_NAME = 'userloggedin';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Fitness',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Quicksand",
        colorScheme: ColorScheme.fromSeed(seedColor: TColor.primary),
        useMaterial3: false,
      ),
      home: SplashScreen(),
    );
  }
}
