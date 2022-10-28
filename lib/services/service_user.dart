import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tubaline_ta/models/user.dart';

final db = FirebaseFirestore.instance;
final profile = db.collection("profile");
final users = db.collection("users");

class ServiceUser {
  Future newUser(String id, String email, String password) async {
    final addProfile = <String, dynamic>{
      "userId": db.doc('users/$id'),
      "createdAt": Timestamp.now(),
    };
    User user = User(email, password, id, Timestamp.now());
    users.doc(id).set(user.toMap());
    profile.add(addProfile);
  }

  Future<List<User>> fetchAllUser(bool sort) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await users.orderBy('createdAt', descending: sort).get();

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

  Future<User> getUserDocs(DocumentReference docs) {
    DocumentReference<Map<String, dynamic>> snapshot = db.doc(docs.path);
    return snapshot.get().then((value) {
      return User.fromDocumentSnapshot(value);
    });
  }
}
