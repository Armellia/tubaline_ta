import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? id;
  final String email;
  final String password;
  final Timestamp createAt;

  User(this.email, this.password, this.id, this.createAt);

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  User.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot)
      : id = documentSnapshot.id,
        email = documentSnapshot.data()!['email'],
        password = documentSnapshot.data()!['password'],
        createAt = documentSnapshot.data()!['created_at'];
}
