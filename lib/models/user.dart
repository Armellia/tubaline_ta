import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? id;
  final String email;
  final String password;
  final Timestamp createdAt;

  User(this.email, this.password, this.id, this.createdAt);

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'createdAt': createdAt,
    };
  }

  User.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot)
      : id = documentSnapshot.id,
        email = documentSnapshot.data()!['email'],
        password = documentSnapshot.data()!['password'],
        createdAt = documentSnapshot.data()!['createdAt'];
}
