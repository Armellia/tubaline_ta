import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubaline_ta/models/experience.dart';
import 'package:tubaline_ta/models/profile.dart';
import 'package:tubaline_ta/preferences/user_preference.dart';
import 'package:firebase_storage/firebase_storage.dart';

final db = FirebaseFirestore.instance;
final profile = db.collection("profile");
final experience = db.collection("experiences");
final UserPreference prefs = UserPreference();
final storage = FirebaseStorage.instance.ref();

class ServiceExperience {
  Future updateExperience(Experience model) async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('profile');
  }

  Future<List<Experience>> fetchExperience() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('profile');
    DocumentReference<Map<String, dynamic>> docs = db.doc("profile/$id");
    final snapshot = await experience.where('profileId', isEqualTo: docs).get();
    return snapshot.docs
        .map((docSnapshot) => Experience.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future addExperience(Experience data) async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('profile');
    DocumentReference<Map<String, dynamic>> docs = db.doc("profile/$id");
    data.createdAt = Timestamp.now();
    data.profileId = docs;
    await experience.add(data.toMap());
  }

  Future<ProfileModel> getExperience(String id) async {
    DocumentReference<Map<String, dynamic>> snapshot = profile.doc(id);
    return snapshot.get().then((value) {
      return ProfileModel.fromDocumentSnapshot(value);
    });
  }

  Future deleteExperiece(String id) async {
    DocumentReference<Map<String, dynamic>> snapshot = experience.doc(id);
    return snapshot.delete();
  }
}