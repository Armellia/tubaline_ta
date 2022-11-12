import 'package:flutter/material.dart';
import 'package:tubaline_ta/models/profile.dart';
import 'package:tubaline_ta/models/user.dart';

class PersonalProvider extends ChangeNotifier {
  final String _str = "hello";
  String get str => _str;
  User? _user;
  User? get user => _user;
  ProfileModel? _profile;
  ProfileModel? get profile => _profile;
  void setUser(User data) {
    _user = data;
    notifyListeners();
  }

  void setProfile(ProfileModel data) {
    _profile = data;
    notifyListeners();
  }
}
