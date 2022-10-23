import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:tubaline_ta/preferences/login_preference.dart';
import 'package:tubaline_ta/screens/home/main_page.dart';
import 'package:tubaline_ta/screens/login/login.dart';
import 'package:tubaline_ta/widgets/snackbar.dart';

final auth = FirebaseAuth.instance;

class ServiceUser {
  String? email;
  String? password;
  String? repassword;
  LoginPreference prefs = LoginPreference();
  Future signIn() async {
    return await auth.signInWithEmailAndPassword(
        email: email!, password: password!);
  }

  login(BuildContext context) async {
    if (email == "" && password == "") {
      SnackBars().showSnackBar(context, "Kosong");
    } else if (email == "") {
      SnackBars().showSnackBar(context, "Email Kosong");
    } else if (password == "") {
      SnackBars().showSnackBar(context, "Password Kosong");
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

  _login(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) {
        return const MyHomePage(title: "Welcome");
      },
    ));
  }

  Future signUp() async {
    return await auth.createUserWithEmailAndPassword(
        email: email!, password: password!);
  }

  register(BuildContext context) async {
    if (email == "" && password == "" || repassword == "") {
      SnackBars().showSnackBar(context, "Kosong");
    } else if (email == "") {
      SnackBars().showSnackBar(context, "Email Kosong");
    } else if (password == "") {
      SnackBars().showSnackBar(context, "Password Kosong");
    } else if (repassword == "") {
      SnackBars().showSnackBar(context, "Repassword Kosong");
    } else if (password != repassword) {
      SnackBars().showSnackBar(context, "Passwor tidak sama");
    } else {
      try {
        await signUp().then((value) {
          _register(context);
        });
      } on FirebaseAuthException catch (e) {
        SnackBars().showSnackBar(context, e.message!);
      }
    }
  }

  _register(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) {
        return const Login();
      },
    ));
  }

  Future signOut() async {
    prefs.setLogout();
    auth.signOut();
  }
}
