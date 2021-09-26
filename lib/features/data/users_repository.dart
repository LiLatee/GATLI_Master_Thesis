import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:master_thesis/core/error/failures.dart';
import 'package:master_thesis/features/data/user_app.dart';

class UserRepository {
  const UserRepository({required this.collection});
  final CollectionReference collection;

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<Either<DefaultFailure, DocumentReference>> addUser(
      UserApp user) async {
    final DocumentReference ref;
    try {
      ref = collection.doc(user.id);
      await ref.set(user.toMap());
    } catch (e) {
      return Left(DefaultFailure(message: "Can't add user. Error: $e"));
    }
    return Right(ref);
  }

  // DocumentReference getUserDocumentReference(UserApp userApp) {
  //   return collection.doc(userApp.id);
  // }

  Future<Either<DefaultFailure, UserApp>> getUser(String id) async {
    final Map<String, dynamic> userAppMap;
    try {
      userAppMap =
          (await collection.doc(id).get()).data() as Map<String, dynamic>;

      return Right(UserApp.fromMap(userAppMap).copyWith(id: id));
    } catch (e) {
      return Left(DefaultFailure(message: "Can't get user. Error: $e"));
    }
  }

  Future<Either<DefaultFailure, bool>> exists(String id) async {
    try {
      final snapshot = await collection.doc(id).get();
      if (snapshot.exists) {
        return const Right(true);
      } else {
        return const Right(false);
      }
    } catch (e) {
      return Left(DefaultFailure(message: "Can't get user. Error: $e"));
    }
  }

  // TODO
  Future<Either<DefaultFailure, void>> updateUser(UserApp user) async {
    try {
      await collection.doc(user.id).update(user.toMap());
      return const Right(null);
    } catch (e) {
      return Left(DefaultFailure(message: "Can't update user. Error: $e"));
    }
  }
}
