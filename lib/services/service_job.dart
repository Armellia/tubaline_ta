import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tubaline_ta/models/user.dart';

final db = FirebaseFirestore.instance;
final profile = db.collection("profile");
final users = db.collection("users");

class ServiceJob {
  Future<List<User>> fetchAllUser(bool sort) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await users.orderBy('created_at', descending: sort).get();

    return snapshot.docs
        .map((docSnapshot) => User.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<User> getUser(String id) async {
    DocumentReference<Map<String, dynamic>> snapshot = users.doc(id);
    return snapshot.get().then((value) {
      return User.fromDocumentSnapshot(value);
    });
  }
}
