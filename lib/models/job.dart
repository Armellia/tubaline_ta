import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  final String? id;
  final String? title;
  final String? description;
  DocumentReference? pembuatId;
  dynamic pelamarId;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  final int? isActive;

  Job(
      {this.title,
      this.description,
      this.isActive,
      this.id,
      this.createdAt,
      this.updatedAt,
      this.pelamarId,
      this.pembuatId});
  Map<String, dynamic> toMap() {
    return {
      'pembuatId': pembuatId,
      'title': title,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt
    };
  }

  Job.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot)
      : id = documentSnapshot.id,
        title = documentSnapshot.data()!['title'],
        description = documentSnapshot.data()!['description'],
        isActive = documentSnapshot.data()!['isActive'],
        pembuatId = documentSnapshot.data()!['pembuatId'],
        pelamarId = documentSnapshot.data()!['pelamarId'],
        createdAt = documentSnapshot.data()!['createdAt'],
        updatedAt = documentSnapshot.data()!['updatedAt'];
}
