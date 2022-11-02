import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  final String? id;
  final String? name;
  final int? numberPhone;
  final DocumentReference? userId;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  String? imageUrl;
  final Timestamp? birthDay;

  ProfileModel(
      {this.name,
      this.numberPhone,
      this.id,
      this.userId,
      this.createdAt,
      this.imageUrl,
      this.updatedAt,
      this.birthDay});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'numberPhone': numberPhone,
      'imageUrl': imageUrl,
      'birthDay': birthDay,
      'updatedAt': updatedAt
    };
  }

  ProfileModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot)
      : id = documentSnapshot.id,
        numberPhone = documentSnapshot.data()!['numberPhone'],
        name = documentSnapshot.data()!['name'],
        imageUrl = documentSnapshot.data()!['imageUrl'],
        userId = documentSnapshot.data()!['userId'],
        birthDay = documentSnapshot.data()!['birthDay'],
        updatedAt = documentSnapshot.data()!['updatedAt'],
        createdAt = documentSnapshot.data()!['createdAt'];
}
