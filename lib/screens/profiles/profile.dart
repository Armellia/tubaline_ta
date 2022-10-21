import 'package:flutter/material.dart';
import 'package:tubaline_ta/screens/login/login.dart';
import 'package:tubaline_ta/services/service_user.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ServiceUser _serviceUser = ServiceUser();
  Widget buttonProfile(String name, IconData icon) {
    return ListTile(
      title: Text(name, style: const TextStyle(fontSize: 18)),
      leading: Icon(icon, size: 40),
      dense: true,
      onTap: () {
        _serviceUser.signOut();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Login(),
        ));
      },
      minVerticalPadding: 20,
      hoverColor: Colors.black26,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Profile",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            elevation: 5,
          ),
          body: ListView(
            children: [
              buttonProfile("Account", Icons.account_box_rounded),
              const SizedBox(
                height: 5,
              ),
              buttonProfile("History", Icons.history_rounded)
            ],
          )),
    );
  }
}
