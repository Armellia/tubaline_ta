import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tubaline_ta/models/job.dart';
import 'package:tubaline_ta/models/myapply.dart';
import 'package:tubaline_ta/models/profile.dart';

final db = FirebaseFirestore.instance;
final myapply = db.collection("myapplies");

class ServiceMyApply {
  Future<MyApply> getMyApply(Job job, ProfileModel profile) async {
    final query = myapply
        .where('jobId', isEqualTo: db.doc('jobs/${job.id!}'))
        .where('profile/${profile.id!}');
    final snapshot = await query.get();
    return snapshot.docs
        .map((docSnapshot) => MyApply.fromDocumentSnapshot(docSnapshot))
        .first;
  }
}
