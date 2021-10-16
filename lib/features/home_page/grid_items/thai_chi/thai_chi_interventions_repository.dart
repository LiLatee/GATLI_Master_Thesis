import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:master_thesis/core/error/failures.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_intervention.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_lessons_repository.dart';
import 'package:master_thesis/service_locator.dart';

class ThaiChiInterventionsRepository {
  const ThaiChiInterventionsRepository({
    required this.collectionReference,
  });
  final CollectionReference collectionReference;

  Stream<QuerySnapshot> getStream() {
    return collectionReference.snapshots();
  }

  Future<Either<DefaultFailure, DocumentReference>> addThaiChiIntervention({
    required String userId,
  }) async {
    final DocumentReference documentReference = collectionReference.doc();
    final thaiChiIntervention = ThaiChiIntervention(
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
          await sl<ThaiChiLessonsRepository>().getAllThaiChiLessonIds();
      return failureOrLessons.fold(
        (l) {
          log("Can't add Thai Chi Intervention. Error: $l");
          return Left(DefaultFailure(
              message: "Can't add Thai Chi Intervention. Error: $l"));
        },
        (allThaiChiLessonsIds) async {
          final interventionWithLessons =
              thaiChiIntervention.copyWith(lessonsToDo: allThaiChiLessonsIds);
          await collectionReference
              .doc(documentReference.id)
              .set(interventionWithLessons.toJson());
          return Right(documentReference);
        },
      );
    } catch (e) {
      return Left(DefaultFailure(
          message: "Can't add Thai Chi Intervention. Error: $e"));
    }
  }

  Future<Either<DefaultFailure, ThaiChiIntervention>> getThaiChiIntervention(
      {required String id}) async {
    final Map<String, dynamic> thaiChiInterventionAppMap;
    try {
      thaiChiInterventionAppMap = (await collectionReference.doc(id).get())
          .data() as Map<String, dynamic>;

      return Right(ThaiChiIntervention.fromJson(thaiChiInterventionAppMap));
    } catch (e) {
      return Left(DefaultFailure(
          message: "Can't get Thai Chi Intervention. Error: $e"));
    }
  }

  // Future<Either<DefaultFailure, ThaiChiIntervention>>
  //     getThaiChiInterventionOfUser({required String userId}) async {
  //   final Map<String, dynamic> thaiChiInterventionAppMap;
  //   try {
  //     thaiChiInterventionAppMap = (await (await collectionReference
  //                 .where('userId', isEqualTo: 'userId'))
  //             .snapshots()
  //             .first)
  //         .docs[0]
  //         .data() as Map<String, dynamic>;

  //     return Right(ThaiChiIntervention.fromJson(thaiChiInterventionAppMap));
  //   } catch (e) {
  //     return Left(DefaultFailure(
  //         message: "Can't get Thai Chi Intervention. Error: $e"));
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
      return Left(DefaultFailure(
          message: "Can't get Thai Chi Intervention. Error: $e"));
    }
  }

  // TODO
  Future<Either<DefaultFailure, void>> updateThaiChiIntervention(
      {required ThaiChiIntervention newThaiChiIntervention}) async {
    try {
      await collectionReference
          .doc(newThaiChiIntervention.id)
          .update(newThaiChiIntervention.toJson());
      return const Right(null);
    } catch (e) {
      return Left(DefaultFailure(
          message: "Can't update Thai Chi Intervention. Error: $e"));
    }
  }
}
