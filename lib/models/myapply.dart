import 'package:cloud_firestore/cloud_firestore.dart';

class MyApply {
  final String? id;
  final int? status;
  DocumentReference? profileId;
  DocumentReference? jobId;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  MyApply(
      {this.id,
      this.status,
      this.createdAt,
      this.jobId,
      this.profileId,
      this.updatedAt});

  MyApply.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot)
      : id = documentSnapshot.id,
        jobId = documentSnapshot.data()!['jobId'],
        profileId = documentSnapshot.data()!['profileId'],
        status = documentSnapshot.data()!['status'],
        createdAt = documentSnapshot.data()!['createdAt'],
        updatedAt = documentSnapshot.data()!['updatedAt'];
}
