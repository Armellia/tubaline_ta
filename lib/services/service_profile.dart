import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubaline_ta/models/profile.dart';
import 'package:tubaline_ta/preferences/user_preference.dart';
import 'package:firebase_storage/firebase_storage.dart';

final db = FirebaseFirestore.instance;
final profile = db.collection("profile");
final users = db.collection("users");
final UserPreference prefs = UserPreference();
final storage = FirebaseStorage.instance.ref();

class ServiceProfile {
  String? url, link;
  final ImagePicker _imagePicker = ImagePicker();
  Future uploadGallery() async {
    url =
        await _imagePicker.pickImage(source: ImageSource.gallery).then((value) {
      if (value == null) return "";
      return value.path;
    });
    return url;
  }

  Future<String> uploadStorage(String url) async {
    var extension = url.toString().split('.').last;
    final path = storage.child("$url.jpg");
    final file = File(url);
    String? link;
    try {
      await path.putFile(
          file, SettableMetadata(contentType: "image/$extension"));
    } catch (e) {
      print(e);
    }
    return path.getDownloadURL().then((value) {
      link = value;
      return link!;
    });
  }

  Future updateProfile(ProfileModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('profile');
    await uploadStorage(model.imageUrl!).then((value) {
      model.imageUrl = value;
      profile.doc(id).set(model.toMap(), SetOptions(merge: true));
    });
  }

  Future<List<ProfileModel>> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id');
    DocumentReference<Map<String, dynamic>> docs = db.doc("users/$id");
    final snapshot = await profile.where('userId', isEqualTo: docs).get();
    return snapshot.docs
        .map((docSnapshot) => ProfileModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<ProfileModel> getProfile(String id) async {
    DocumentReference<Map<String, dynamic>> snapshot = profile.doc(id);
    return snapshot.get().then((value) {
      return ProfileModel.fromDocumentSnapshot(value);
    });
  }
}
