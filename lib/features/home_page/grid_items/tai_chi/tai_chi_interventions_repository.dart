import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:master_thesis/core/error/failures.dart';
import 'package:master_thesis/features/home_page/grid_items/tai_chi/tai_chi_intervention.dart';
import 'package:master_thesis/features/home_page/grid_items/tai_chi/tai_chi_lessons_repository.dart';
import 'package:master_thesis/service_locator.dart';

class TaiChiInterventionsRepository {
  const TaiChiInterventionsRepository({
    required this.collectionReference,
  });
  final CollectionReference collectionReference;

  Stream<QuerySnapshot> getStream() {
    return collectionReference.snapshots();
  }

  Future<Either<DefaultFailure, DocumentReference>> addTaiChiIntervention({
    required String userId,
  }) async {
    final DocumentReference documentReference = collectionReference.doc();
    final taiChiIntervention = TaiChiIntervention(
      id: documentReference.id,
      userId: userId,
      lessonsDone: const [],
      lessonsToDo: const [],
      startTimestamp: DateTime.now().millisecondsSinceEpoch,
      endTimestamp: null,
      earnedPoints: 0,
    );

    try {
      final failureOrLessons =
          await sl<TaiChiLessonsRepository>().getAllTaiChiLessonIds();
      return failureOrLessons.fold(
        (l) {
          log("Can't add Tai Chi Intervention. Error: $l");
          return Left(DefaultFailure(
              message: "Can't add Tai Chi Intervention. Error: $l"));
        },
        (allTaiChiLessonsIds) async {
          final interventionWithLessons =
              taiChiIntervention.copyWith(lessonsToDo: allTaiChiLessonsIds);
          await collectionReference
              .doc(documentReference.id)
              .set(interventionWithLessons.toJson());
          return Right(documentReference);
        },
      );
    } catch (e) {
      return Left(
          DefaultFailure(message: "Can't add Tai Chi Intervention. Error: $e"));
    }
  }

  Future<Either<DefaultFailure, TaiChiIntervention>> getTaiChiIntervention(
      {required String id}) async {
    final Map<String, dynamic> taiChiInterventionAppMap;
    try {
      taiChiInterventionAppMap = (await collectionReference.doc(id).get())
          .data() as Map<String, dynamic>;

      return Right(TaiChiIntervention.fromJson(taiChiInterventionAppMap));
    } catch (e) {
      return Left(
          DefaultFailure(message: "Can't get Tai Chi Intervention. Error: $e"));
    }
  }

  // Future<Either<DefaultFailure, TaiChiIntervention>>
  //     getTaiChiInterventionOfUser({required String userId}) async {
  //   final Map<String, dynamic> taiChiInterventionAppMap;
  //   try {
  //     taiChiInterventionAppMap = (await (await collectionReference
  //                 .where('userId', isEqualTo: 'userId'))
  //             .snapshots()
  //             .first)
  //         .docs[0]
  //         .data() as Map<String, dynamic>;

  //     return Right(TaiChiIntervention.fromJson(taiChiInterventionAppMap));
  //   } catch (e) {
  //     return Left(DefaultFailure(
  //         message: "Can't get Tai Chi Intervention. Error: $e"));
  //   }
  // }

  Future<Either<DefaultFailure, bool>> exists(String id) async {
    try {
      final snapshot = await collectionReference.doc(id).get();
      if (snapshot.exists) {
        return const Right(true);
      } else {
        return const Right(false);
      }
    } catch (e) {
      return Left(
          DefaultFailure(message: "Can't get Tai Chi Intervention. Error: $e"));
    }
  }

  // TODO
  Future<Either<DefaultFailure, void>> updateTaiChiIntervention(
      {required TaiChiIntervention newTaiChiIntervention}) async {
    try {
      await collectionReference
          .doc(newTaiChiIntervention.id)
          .update(newTaiChiIntervention.toJson());
      return const Right(null);
    } catch (e) {
      return Left(DefaultFailure(
          message: "Can't update Tai Chi Intervention. Error: $e"));
    }
  }
}
