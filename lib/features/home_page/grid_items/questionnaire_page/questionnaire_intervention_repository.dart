import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:master_thesis/core/error/failures.dart';
import 'package:master_thesis/features/data/user_app.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/question_user.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire.dart';
import 'package:master_thesis/service_locator.dart';

class QuestionnaireInterventionRepository {
  QuestionnaireInterventionRepository({required this.collectionReference});

  final CollectionReference collectionReference;
  final UserRepository userRepository = sl<UserRepository>();

  Future<Either<DefaultFailure, DocumentReference>> addQuestionnaire(
      {required Questionnaire<QuestionUser> questionnaire}) async {
    late final String questionnaireDocId;

    final failureOrUserApp = await userRepository.getUser();
    failureOrUserApp.fold((l) {
      log("Can't get user. Error: $l");
      return Left(DefaultFailure(
          message: "Can't add Questionnaire Intervention. Error: $l"));
    }, (UserApp userApp) {
      questionnaireDocId = userApp.activeInterventions['QLQ-C30']![0];
    });

    final DocumentReference documentReference =
        collectionReference.doc(questionnaireDocId);
    questionnaire.id = documentReference.id;
    try {
      await documentReference
          .set(questionnaire.toJson((question) => question.toJson()));
    } catch (e) {
      log("Can't add Questionnaire. Error: $e");
      return Left(DefaultFailure(
          message: "Can't add Questionnaire Intervention. Error: $e"));
    }
    return Right(documentReference);
  }

  String generateQuestionnaireDocId() => collectionReference.doc().id;

  // // TODO hadrcoded questionnaire doc ID
  // Future<Either<DefaultFailure, Questionnaire<Question>>> getQuestionnaire(
  //     {String id = '2mzlcazW6usv6BED90dD'}) async {
  //   final Map<String, dynamic> questionnaireMap;
  //   try {
  //     questionnaireMap = (await collectionReference.doc(id).get()).data()
  //         as Map<String, dynamic>;

  //     return Right(Questionnaire.fromJson(questionnaireMap,
  //         (data) => Question.fromJson(data as Map<String, dynamic>)));
  //   } catch (e) {
  //     return Left(
  //         DefaultFailure(message: "Can't get Questionnaire. Error: $e"));
  //   }
  // }
}
