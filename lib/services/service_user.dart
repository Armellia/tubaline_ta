import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:tubaline_ta/preferences/login_preference.dart';
import 'package:tubaline_ta/screens/home/main_page.dart';
import 'package:tubaline_ta/widgets/snackbar.dart';

final auth = FirebaseAuth.instance;

class ServiceUser {
  String? email;
  String? password;
  LoginPreference prefs = LoginPreference();
  Future signIn() async {
    return await auth.signInWithEmailAndPassword(
        email: email!, password: password!);
  }

  login(BuildContext context) async {
    if (email == "" && password == "") {
      SnackBars().showSnackBar(context, "kosong");
    } else {
      try {
        await signIn().then((value) {
          prefs.setLogin(true, auth.currentUser!.uid);
          _login(context);
        });
      } on FirebaseAuthException catch (e) {
        SnackBars().showSnackBar(context, e.message!);
      }
    }
  }

  Future signOut() async {
    prefs.setLogout();
    auth.signOut();
  }

  _login(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) {
        return const MyHomePage(title: "Welcome");
      },
    ));
  }
}
