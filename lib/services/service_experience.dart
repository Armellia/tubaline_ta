import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubaline_ta/models/experience.dart';
import 'package:tubaline_ta/preferences/user_preference.dart';
import 'package:firebase_storage/firebase_storage.dart';

final db = FirebaseFirestore.instance;
final profile = db.collection("profile");
final experience = db.collection("experiences");
final UserPreference prefs = UserPreference();
final storage = FirebaseStorage.instance.ref();

class ServiceExperience {
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

  Future<List<Experience>> getExperience(String id) async {
    final docs = db.doc('profile/$id');
    final query = experience.where('profileId', isEqualTo: docs);
    final snapshot = await query.get();
    return snapshot.docs.map((value) {
      return Experience.fromDocumentSnapshot(value);
    }).toList();
  }

  Future deleteExperiece(String id) async {
    DocumentReference<Map<String, dynamic>> snapshot = experience.doc(id);
    return snapshot.delete();
  }
}
