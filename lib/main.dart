import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import 'package:workout_fitness/models/user.dart';
import 'package:workout_fitness/services/auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:workout_fitness/view/gemini/consts.dart';

import 'package:workout_fitness/wrapper/wrapper.dart';

import 'common/color_extension.dart';

const SAVE_KEY_NAME = 'userloggedin';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // name: 'name-here',
      // options: FirebaseOptions(
      //     apiKey: "AIzaSyCOtXpjJfVJ_HSbnZzJ7FxyReN7f36pGIQ",
      //     appId: "XXX",
      //     messagingSenderId: "XXX",
      //     projectId: "fit-ly")
      );
  Gemini.init(apiKey: gemini_Api_Key);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Userr?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        title: 'Workout Fitness',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Quicksand",
          colorScheme: ColorScheme.fromSeed(seedColor: TColor.primary),
          useMaterial3: false,
        ),

        //home: SplashScreen(),
        home: Wrapper(),
      ),
    );
  }
}
