import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:master_thesis/core/error/failures.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/question.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire.dart';

class QuestionnaireRepository {
  QuestionnaireRepository({required this.collectionReference});

  final CollectionReference collectionReference;

  Future<Either<DefaultFailure, DocumentReference>> addQuestionnaire(
      Questionnaire questionnaire) async {
    log('DODAWANIE QLQ-C30');
    final DocumentReference documentReference = collectionReference.doc();
    questionnaire.id = documentReference.id;
    try {
      await documentReference
          .set(questionnaire.toJson((question) => question.toJson()));
    } catch (e) {
      log("Can't add Questionnaire. Error: $e");
      return Left(
          DefaultFailure(message: "Can't add Questionnaire. Error: $e"));
    }
    return Right(documentReference);
  }

  // hardcoded questionnaire doc ID, because that's the only one
  Future<Either<DefaultFailure, Questionnaire<Question>>> getQuestionnaire(
      {String id = '2mzlcazW6usv6BED90dD'}) async {
    final Map<String, dynamic> questionnaireMap;
    try {
      questionnaireMap = (await collectionReference.doc(id).get()).data()
          as Map<String, dynamic>;

      return Right(Questionnaire.fromJson(questionnaireMap,
          (data) => Question.fromJson(data as Map<String, dynamic>)));
    } catch (e) {
      return Left(
          DefaultFailure(message: "Can't get Questionnaire. Error: $e"));
    }
  }
}
