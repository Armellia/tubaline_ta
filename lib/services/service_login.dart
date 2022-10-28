import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:tubaline_ta/preferences/user_preference.dart';
import 'package:tubaline_ta/screens/home/main_page.dart';
import 'package:tubaline_ta/screens/login/login.dart';
import 'package:tubaline_ta/services/service_user.dart';

import 'package:tubaline_ta/widgets/snackbar.dart';

final auth = FirebaseAuth.instance;

class ServiceLogin {
  String? email;
  String? password;
  String? repassword;
  final ServiceUser serviceUser = ServiceUser();
  UserPreference prefs = UserPreference();
  Future signIn() async {
    return await auth.signInWithEmailAndPassword(
        email: email!, password: password!);
  }

  Future login(BuildContext context) async {
    if (email == "" && password == "") {
      SnackBars().showSnackBar(context, "Kosong");
    } else if (email == "") {
      SnackBars().showSnackBar(context, "Email Kosong");
    } else if (password == "") {
      SnackBars().showSnackBar(context, "Password Kosong");
    } else {
      try {
        await signIn().then((value) {
          print(value.user.uid);
          prefs.setLogin(true, value.user.uid);
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

  Future register(BuildContext context) async {
    if (email == "" && password == "" && repassword == "") {
      SnackBars().showSnackBar(context, "Kosong");
    } else if (email == "") {
      SnackBars().showSnackBar(context, "Email Kosong");
    } else if (password == "" || repassword == "") {
      SnackBars().showSnackBar(context, "Password Kosong");
    } else if (password != repassword) {
      SnackBars().showSnackBar(context, "Passwor tidak sama");
    } else {
      try {
        await signUp().then((value) {
          serviceUser.newUser(value.user.uid, email!, password!);
          _register(context);
          SnackBars().showSnackBar(context, "Register Success");
        });
      } on FirebaseAuthException catch (e) {
        SnackBars().showSnackBar(context, e.message!);
      }
    }
  }

  Future _register(BuildContext context) async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) {
        return const Login();
      },
    ));
  }

  Future signOut(BuildContext context) async {
    prefs.setLogout();
    auth.signOut();
    Navigator.of(context, rootNavigator: true)
        .pushReplacement(MaterialPageRoute(
      builder: (context) => const Login(),
    ));
  }
}
