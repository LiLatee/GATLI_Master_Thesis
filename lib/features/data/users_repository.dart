import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:master_thesis/core/error/failures.dart';
import 'package:master_thesis/features/data/user_app.dart';

class UserRepository {
  const UserRepository({
    required this.documentReference,
    // required this.userId,
  });
  final DocumentReference documentReference;
  // final String userId;

  Stream<DocumentSnapshot> getStream() {
    return documentReference.snapshots();
    //aJwZi61bASMdQWGCvRrFeocXi7U2
  }

  Future<Either<DefaultFailure, DocumentReference>> addUser(
      UserApp user) async {
    final DocumentReference ref;
    try {
      await documentReference.set(user.toMap());
    } catch (e) {
      return Left(DefaultFailure(message: "Can't add user. Error: $e"));
    }
    return Right(documentReference);
  }

  // DocumentReference getUserDocumentReference(UserApp userApp) {
  //   return collection.doc(userApp.id);
  // }

  Future<Either<DefaultFailure, UserApp>> getUser(String id) async {
    final Map<String, dynamic> userAppMap;
    try {
      userAppMap =
          (await documentReference.get()).data() as Map<String, dynamic>;

      return Right(UserApp.fromMap(userAppMap).copyWith(id: id));
    } catch (e) {
      return Left(DefaultFailure(message: "Can't get user. Error: $e"));
    }
  }

  Future<Either<DefaultFailure, bool>> exists(String id) async {
    try {
      final snapshot = await documentReference.get();
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
      await documentReference.update(user.toMap());
      return const Right(null);
    } catch (e) {
      return Left(DefaultFailure(message: "Can't update user. Error: $e"));
    }
  }
}
