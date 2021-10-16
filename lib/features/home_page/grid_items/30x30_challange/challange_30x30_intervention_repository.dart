import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:master_thesis/core/error/failures.dart';
import 'package:master_thesis/features/home_page/grid_items/30x30_challange/challange_30x30_intervention.dart';

class Challange30x30InterventionRepository {
  Challange30x30InterventionRepository({required this.collectionReference});

  final CollectionReference collectionReference;

  Stream<QuerySnapshot> getStream() {
    return collectionReference.snapshots();
  }

  Future<Either<DefaultFailure, DocumentReference>>
      addChallange30x30Intervention({
    required String userId,
  }) async {
    final DocumentReference documentReference = collectionReference.doc();
    final now = DateTime.now();
    final challange30x30Intervention = Challange30x30Intervention(
      userId: userId,
      id: documentReference.id,
      startDatetime: now,
      endDatetime: now.add(const Duration(days: 30)),
    );

    try {
      await collectionReference
          .doc(documentReference.id)
          .set(challange30x30Intervention.toJson());
      return Right(documentReference);
    } catch (e) {
      return Left(DefaultFailure(
          message: "Can't add 30x30 Challange Intervention. Error: $e"));
    }
  }

  Future<Either<DefaultFailure, Challange30x30Intervention>>
      getChallange30x30Intervention({required String id}) async {
    final Map<String, dynamic> challange30x30InterventionAppMap;
    try {
      challange30x30InterventionAppMap =
          (await collectionReference.doc(id).get()).data()
              as Map<String, dynamic>;

      return Right(Challange30x30Intervention.fromJson(
          challange30x30InterventionAppMap));
    } catch (e) {
      return Left(DefaultFailure(
          message: "Can't get 30x30 Challange Intervention. Error: $e"));
    }
  }

  Future<Either<DefaultFailure, bool>> exists(String id) async {
    try {
      final snapshot = await collectionReference.doc(id).get();
      if (snapshot.exists) {
        return const Right(true);
      } else {
        return const Right(false);
      }
    } catch (e) {
      return Left(DefaultFailure(
          message: "Can't get 30x30 Challange Intervention. Error: $e"));
    }
  }

  // TODO
  Future<Either<DefaultFailure, void>> updateChallange30x30Intervention(
      {required Challange30x30Intervention
          newChallange30x30Intervention}) async {
    try {
      await collectionReference
          .doc(newChallange30x30Intervention.id)
          .update(newChallange30x30Intervention.toJson());
      return const Right(null);
    } catch (e) {
      log("Can't update 30x30 Challange Intervention. Error: $e");
      return Left(DefaultFailure(
          message: "Can't update 30x30 Challange Intervention. Error: $e"));
    }
  }

  String generateDocId() => collectionReference.doc().id;
}
