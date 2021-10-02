import 'dart:developer';

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
    try {
      await documentReference.set(user.toJson());
    } catch (e) {
      return Left(DefaultFailure(message: "Can't add user. Error: $e"));
    }
    return Right(documentReference);
  }

  Future<Either<DefaultFailure, DocumentReference>> assignThaiChiInterventions(
      {required String thaiChiInterventionId}) async {
    try {
      await documentReference.update({
        'activeInterventions': {
          'thai_chi': [thaiChiInterventionId] // TODO it overwrites
        }
      });
    } catch (e) {
      return Left(DefaultFailure(message: "Can't add user. Error: $e"));
    }
    return Right(documentReference);
  }

  Future<Either<DefaultFailure, UserApp>> getUser() async {
    final Map<String, dynamic> userAppMap;
    try {
      userAppMap =
          (await documentReference.get()).data() as Map<String, dynamic>;
      return Right(UserApp.fromJson(userAppMap)); // usunięte .copyWith(id: id)
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

  // TODO probably not working
  Future<Either<DefaultFailure, void>> updateUser(UserApp user) async {
    try {
      await documentReference.update(user.toJson());
      return const Right(null);
    } catch (e) {
      return Left(DefaultFailure(message: "Can't update user. Error: $e"));
    }
  }
}
