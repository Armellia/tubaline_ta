import 'package:flutter/material.dart';
import 'package:tubaline_ta/models/profile.dart';
import 'package:tubaline_ta/models/user.dart';

class PersonalProvider extends ChangeNotifier {
  String? _idP;
  String? get idP => _idP;
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

  void setId(String data) {
    _idP = data;
    notifyListeners();
  }
}
