import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubaline_ta/models/profile.dart';
import 'package:tubaline_ta/models/user.dart';
import 'package:tubaline_ta/preferences/user_preference.dart';
import 'package:tubaline_ta/screens/profiles/profile_detail.dart';
import 'package:tubaline_ta/services/service_login.dart';
import 'package:tubaline_ta/services/service_profile.dart';
import 'package:tubaline_ta/services/service_user.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ServiceLogin serviceLogin = ServiceLogin();
  final ServiceProfile serviceProfile = ServiceProfile();
  final ServiceUser serviceUser = ServiceUser();
  final UserPreference userPreference = UserPreference();

  Stream<List<ProfileModel>> getdata() async* {
    yield await serviceProfile.fetchProfile();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget buttonProfile(String name, IconData icon, click) {
    return ListTile(
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.black, width: 1),
      ),
      title: Text(name),
      leading: Icon(icon, size: 40),
      dense: true,
      onTap: () {
        click();
      },
      minVerticalPadding: 20,
      hoverColor: Colors.black26,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
        ),
        elevation: 5,
      ),
      body: StreamBuilder(
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 100,
                  child: Center(
                    child: ListTile(
                      visualDensity: const VisualDensity(vertical: 4),
                      title: Text(snapshot.data!.elementAt(0).name == null
                          ? "Nama Belum Diset"
                          : snapshot.data!.elementAt(0).name.toString()),
                      leading: CircleAvatar(
                        foregroundImage: snapshot.data!.first.imageUrl == null
                            ? AssetImage('assets/images/profile.png')
                            : Image.network(snapshot.data!.first.imageUrl!)
                                .image,
                        radius: 60.0,
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            final model = snapshot.data!.first;
                            final pref = SharedPreferences.getInstance();
                            pref.then((value) {
                              value.setString("profile", model.id!);
                            });
                            Navigator.of(context, rootNavigator: true)
                                .push(MaterialPageRoute(
                              builder: (context) => ProfileDetail(
                                id: model.id!,
                              ),
                            ));
                          },
                          icon: const Icon(Icons.mode_edit_outline_outlined)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                buttonProfile("History", Icons.history_rounded, () {
                  serviceLogin.signOut(context);
                })
              ],
            );
          }
        },
        stream: getdata(),
      ),
    );
  }
}
