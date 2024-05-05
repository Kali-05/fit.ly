import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_fitness/models/user.dart';
import 'package:workout_fitness/services/database.dart';
import 'package:workout_fitness/view/login_page/login_page.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object on the basis of firebase user

  Userr? _userfromfirebaseUser(User? user) {
    return user != null ? Userr(uid: user.uid) : null;
  }

  // auth changes user stream

  Stream<Userr?> get user {
    return _auth.authStateChanges().map(_userfromfirebaseUser);
  }

  //sign in anonimous

  Future signinAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      final User user = result.user!;
      await DataBaseService(uid: user.uid);
      return _userfromfirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //signin email

  Future LoginWithEmail(String email, String Password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: Password);
      User? emailUser = result.user;

      return _userfromfirebaseUser(emailUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //reg with email

  Future RegisterWithEmail(String email, String Password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: Password);
      User? emailUser = result.user;
      return _userfromfirebaseUser(emailUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //signout

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
