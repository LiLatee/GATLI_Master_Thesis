import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:master_thesis/core/error/failures.dart';
import 'package:master_thesis/features/home_page/grid_items/tai_chi/tai_chi_lesson.dart';

class TaiChiLessonsRepository {
  const TaiChiLessonsRepository({
    required this.collectionReference,
  });
  final CollectionReference collectionReference;

  Stream<QuerySnapshot> getStream() {
    return collectionReference.snapshots();
  }

  Future<Either<DefaultFailure, CollectionReference>> addTaiChiLesson(
      TaiChiLessonNoId taiChiLessonNoId) async {
    final DocumentReference documentReference = collectionReference.doc();
    final TaiChiLesson taiChiLesson = TaiChiLesson.fromTaiChiLessonNoId(
      taiChiLessonNoId: taiChiLessonNoId,
      docId: documentReference.id,
    );
    try {
      await documentReference.set(taiChiLesson.toMap());
    } catch (e) {
      return Left(
          DefaultFailure(message: "Can't add Tai Chi lesson. Error: $e"));
    }
    return Right(collectionReference);
  }

  Future<Either<DefaultFailure, TaiChiLesson>> getTaiChiLesson(
      String id) async {
    final Map<String, dynamic> taiChiLessonAppMap;
    try {
      taiChiLessonAppMap = (await collectionReference.doc(id).get()).data()
          as Map<String, dynamic>;

      return Right(TaiChiLesson.fromMap(taiChiLessonAppMap));
    } catch (e) {
      return Left(
          DefaultFailure(message: "Can't get Tai Chi lesson. Error: $e"));
    }
  }

  Future<Either<DefaultFailure, List<TaiChiLesson>>>
      getAllTaiChiLessons() async {
    try {
      final allDocs = (await collectionReference.get())
          .docs
          .map((doc) => doc.data())
          .toList();
      final List<TaiChiLesson> allTaiChiLessons = allDocs
          .map(
            (element) => TaiChiLesson.fromMap(element as Map<String, dynamic>),
          )
          .toList();

      return Right(allTaiChiLessons);
    } catch (e) {
      return Left(
          DefaultFailure(message: "Can't get All Tai Chi lessons. Error: $e"));
    }
  }

  Future<Either<DefaultFailure, List<String>>> getAllTaiChiLessonIds() async {
    try {
      final allDocsIds =
          (await collectionReference.get()).docs.map((doc) => doc.id).toList();

      return Right(allDocsIds);
    } catch (e) {
      return Left(DefaultFailure(
          message: "Can't get All Tai Chi Lessons Ids. Error: $e"));
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
          DefaultFailure(message: "Can't get Tai Chi lesson. Error: $e"));
    }
  }
}
