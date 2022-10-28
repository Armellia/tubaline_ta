import 'dart:async';

import 'package:flutter/material.dart';

import 'package:tubaline_ta/preferences/user_preference.dart';
import 'package:tubaline_ta/screens/home/main_page.dart';
import 'package:tubaline_ta/screens/login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserPreference prefs = UserPreference();
  void check(BuildContext context) async {
    bool? key;
    await prefs.getLogin().then((value) => key = value);
    if (key == false) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Login()));
    } else {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const MyHomePage(
                title: "hello",
              )));
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      check(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Tubaline",
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(),
          ],
        )),
      ),
    );
  }
}
