import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:master_thesis/core/error/failures.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_lesson.dart';

class ThaiChiLessonsRepository {
  const ThaiChiLessonsRepository({
    required this.collectionReference,
  });
  final CollectionReference collectionReference;

  Stream<QuerySnapshot> getStream() {
    return collectionReference.snapshots();
  }

  Future<Either<DefaultFailure, CollectionReference>> addThaiChiLesson(
      ThaiChiLessonNoId thaiChiLessonNoId) async {
    final DocumentReference documentReference = collectionReference.doc();
    final ThaiChiLesson thaiChiLesson = ThaiChiLesson.fromThaiChiLessonNoId(
      thaiChiLessonNoId: thaiChiLessonNoId,
      docId: documentReference.id,
    );
    try {
      await documentReference.set(thaiChiLesson.toMap());
    } catch (e) {
      return Left(
          DefaultFailure(message: "Can't add Thai Chi lesson. Error: $e"));
    }
    return Right(collectionReference);
  }

  Future<Either<DefaultFailure, ThaiChiLesson>> getThaiChiLesson(
      String id) async {
    final Map<String, dynamic> thaiChiLessonAppMap;
    try {
      thaiChiLessonAppMap = (await collectionReference.doc(id).get()).data()
          as Map<String, dynamic>;

      return Right(ThaiChiLesson.fromMap(thaiChiLessonAppMap));
    } catch (e) {
      return Left(
          DefaultFailure(message: "Can't get Thai Chi lesson. Error: $e"));
    }
  }

  Future<Either<DefaultFailure, List<ThaiChiLesson>>>
      getAllThaiChiLessons() async {
    try {
      final allDocs = (await collectionReference.get())
          .docs
          .map((doc) => doc.data())
          .toList();
      final List<ThaiChiLesson> allThaiChiLessons = allDocs
          .map(
            (element) => ThaiChiLesson.fromMap(element as Map<String, dynamic>),
          )
          .toList();

      return Right(allThaiChiLessons);
    } catch (e) {
      return Left(
          DefaultFailure(message: "Can't get All Thai Chi lessons. Error: $e"));
    }
  }

  Future<Either<DefaultFailure, List<String>>> getAllThaiChiLessonIds() async {
    try {
      final allDocsIds =
          (await collectionReference.get()).docs.map((doc) => doc.id).toList();

      return Right(allDocsIds);
    } catch (e) {
      return Left(DefaultFailure(
          message: "Can't get All Thai Chi Lessons Ids. Error: $e"));
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
      return Left(
          DefaultFailure(message: "Can't get Thai Chi lesson. Error: $e"));
    }
  }

  // TODO
  Future<Either<DefaultFailure, void>> updateThaiChiLesson(
      ThaiChiLesson thaiChiLesson) async {
    try {
      await collectionReference
          .doc(thaiChiLesson.ytVideoId)
          .update(thaiChiLesson.toMap());
      return const Right(null);
    } catch (e) {
      return Left(
          DefaultFailure(message: "Can't update Thai Chi lesson. Error: $e"));
    }
  }
}
