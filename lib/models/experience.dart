import 'package:cloud_firestore/cloud_firestore.dart';

class Experience {
  final String? id;
  final String? experienceAt;
  DocumentReference? profileId;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  final String? year;

  Experience(
      {this.id,
      this.experienceAt,
      this.profileId,
      this.createdAt,
      this.updatedAt,
      this.year});

  Map<String, dynamic> toMap() {
    return {
      'profileId': profileId,
      'experienceAt': experienceAt,
      'createdAt': createdAt,
      'year': year,
      'updatedAt': updatedAt
    };
  }

  Experience.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot)
      : id = documentSnapshot.id,
        experienceAt = documentSnapshot.data()!['experienceAt'],
        profileId = documentSnapshot.data()!['profileId'],
        year = documentSnapshot.data()!['year'],
        createdAt = documentSnapshot.data()!['createdAt'],
        updatedAt = documentSnapshot.data()!['updatedAt'];
}
