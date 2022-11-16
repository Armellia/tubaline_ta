import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubaline_ta/models/job.dart';
import 'package:tubaline_ta/models/profile.dart';
import 'package:tubaline_ta/preferences/user_preference.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tubaline_ta/services/service_profile.dart';
import 'package:tubaline_ta/widgets/alert.dart';

final db = FirebaseFirestore.instance;
final profile = db.collection("profile");
final jobs = db.collection("jobs");
final myApply = db.collection("myapplies");
final UserPreference prefs = UserPreference();
final storage = FirebaseStorage.instance.ref();

class ServiceJob {
  ServiceProfile serviceProfile = ServiceProfile();
  ProfileModel? dataProfile;
  Future<List<Job>> fetchJobs(bool sort) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await jobs
        .where('isActive', isEqualTo: 1)
        .orderBy('createdAt', descending: sort)
        .get();

    return snapshot.docs
        .map((docSnapshot) => Job.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future addJob(Job data) async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('profile');
    DocumentReference<Map<String, dynamic>> docs = db.doc("profile/$id");
    data.createdAt = Timestamp.now();
    data.pembuatId = docs;
    await jobs.add(data.toMap());
  }

  Future<Job> getJob(String id) async {
    DocumentReference<Map<String, dynamic>> snapshot = jobs.doc(id);
    return snapshot.get().then((value) {
      return Job.fromDocumentSnapshot(value);
    });
  }

  Future<List<ProfileModel>> fetchProfile() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await profile.get();
    return snapshot.docs.map((e) {
      return ProfileModel.fromDocumentSnapshot(e);
    }).toList();
  }

  Future<List<ProfileModel>> fetchProfileById(List id) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await profile.where(db.doc, whereIn: id).get();
    return snapshot.docs.map((e) {
      return ProfileModel.fromDocumentSnapshot(e);
    }).toList();
  }

  Future lamarJob(BuildContext context, String id) async {
    final prefs = await SharedPreferences.getInstance();
    final profile = prefs.getString('profile');
    DocumentReference<Map<String, dynamic>> snapshot = jobs.doc(id);
    final data =
        snapshot.get().then((value) => Job.fromDocumentSnapshot(value));
    data.then((value) {
      if (value.pembuatId!.id.compareTo(profile!) == 0) {
        Alert().show(context, "Kamu tiadk dapat melamar post mu sendiri");
      } else {
        final data = value.pelamarId as LinkedHashMap?;
        final apply = <String, dynamic>{
          "jobId": db.doc("jobs/${value.id}"),
          "profileId": db.doc("profile/$profile"),
          "status": 0,
          "createdAt": Timestamp.now(),
        };
        final length = data == null ? 0 : data.length;

        final dataU = <String, dynamic>{
          length.toString(): db.doc("profile/$profile")
        };
        final addJob = <String, dynamic>{
          "pelamarId": dataU,
          "updatedAt": Timestamp.now(),
        };
        snapshot.set(addJob, SetOptions(merge: true)).whenComplete(() {
          myApply.add(apply).then((value) {
            if (kDebugMode) {
              print(value);
            }
          });
          Alert().show(context, "Success").whenComplete(() {
            Navigator.pop(context);
          });
        });
      }
    });
  }

  Future<List<Job>> getJobByProfile(String id) async {
    int angka = 1;
    QuerySnapshot<Map<String, dynamic>> snapshot = await jobs
        .where('pembuatId', isEqualTo: db.doc('profile/$id'))
        .where('isActive', isEqualTo: angka)
        .get();
    return snapshot.docs.map((e) {
      return Job.fromDocumentSnapshot(e);
    }).toList();
  }

  Future deactiveJob(String id, BuildContext context) async {
    final active = <String, int>{'isActive': 0};
    DocumentReference<Map<String, dynamic>> snapshot = jobs.doc(id);
    snapshot.update(active);
    Alert().show(context, "Post telah dinonaktifkan").whenComplete(() {
      Navigator.pop(context);
    });
  }
}
