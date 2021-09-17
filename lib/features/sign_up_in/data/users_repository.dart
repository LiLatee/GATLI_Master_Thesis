import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:master_thesis/features/sign_up_in/data/user.dart';

class UserRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addUser(User user) {
    return collection.add(user.toJson());
  }

  void updateUser(User user) async {
    if (user.reference != null) {
      await collection.doc(user.reference!.id).update(user.toMap());
    } else {
      log('users_repository.dart: user.reference is null!');
    }
  }
}
