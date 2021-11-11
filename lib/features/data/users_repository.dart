import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:master_thesis/core/error/failures.dart';
import 'package:master_thesis/features/data/points_entry.dart';
import 'package:master_thesis/features/data/user_app.dart';
import 'package:master_thesis/features/home_page/grid_items/activity/activity_session.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire_intervention_repository.dart';
import 'package:master_thesis/service_locator.dart';

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

  Future<Either<DefaultFailure, DocumentReference>> assignTaiChiIntervention(
      {required String taiChiInterventionId}) async {
    try {
      final failureOrUserApp = await getUser();
      failureOrUserApp.fold(
        (l) {
          log("Can't get UserApp: Error: $l");
          return Left(DefaultFailure(
              message: "Can't assign Tai Chi Intervention to user. Error: $l"));
        },
        (UserApp userApp) async {
          final Map<String, List<String>> activeInterventions =
              userApp.activeInterventions;

          if (userApp.activeInterventions.containsKey('tai_chi')) {
            activeInterventions['tai_chi']!.add(taiChiInterventionId);
          } else {
            activeInterventions['tai_chi'] = [taiChiInterventionId];
          }
          await documentReference
              .update({'activeInterventions': activeInterventions});
        },
      );
    } catch (e) {
      return Left(DefaultFailure(
          message: "Can't add Tai Chi Intervention to user. Error: $e"));
    }
    return Right(documentReference);
  }

  Future<Either<DefaultFailure, DocumentReference>> doneTaiChiIntervention(
      {required String taiChiInterventionId}) async {
    try {
      final failureOrUserApp = await getUser();
      failureOrUserApp.fold(
        (l) {
          return Left(DefaultFailure(
              message:
                  "Can't make done Tai Chi Intervention for user. Error: $l"));
        },
        (UserApp userApp) async {
          final Map<String, List<String>> pastInterventions =
              userApp.pastInterventions;
          final Map<String, List<String>> activeInterventions =
              userApp.activeInterventions;
          activeInterventions.remove('tai_chi');

          if (userApp.pastInterventions.containsKey('tai_chi')) {
            pastInterventions['tai_chi']!.add(taiChiInterventionId);
          } else {
            pastInterventions['tai_chi'] = [taiChiInterventionId];
          }

          await documentReference.update({
            'pastInterventions': pastInterventions,
            'activeInterventions': activeInterventions
          });
        },
      );
    } catch (e) {
      return Left(DefaultFailure(
          message: "Can't make done Tai Chi Intervention for user. Error: $e"));
    }
    return Right(documentReference);
  }

  Future<Either<DefaultFailure, DocumentReference>>
      assignQuestionnaireIntervention() async {
    final String questionnaireInterventionId =
        sl<QuestionnaireInterventionRepository>().generateQuestionnaireDocId();

    try {
      final failureOrUserApp = await getUser();
      return failureOrUserApp.fold((l) {
        log("Can't get UserApp: Error: $l");
        return Left(DefaultFailure(
            message:
                "Can't assign Questionnaire Intervention to user. Error: $l"));
      }, (UserApp userApp) async {
        final Map<String, List<String>> activeInterventions =
            userApp.activeInterventions;

        if (userApp.activeInterventions.containsKey('QLQ-C30')) {
          activeInterventions['QLQ-C30']!.add(questionnaireInterventionId);
        } else {
          activeInterventions['QLQ-C30'] = [questionnaireInterventionId];
        }
        await documentReference
            .update({'activeInterventions': activeInterventions});
        return Right(documentReference);
      });
    } catch (e) {
      return Left(DefaultFailure(
          message: "Can't add Tai Chi Intervention to user. Error: $e"));
    }
  }

  Future<Either<DefaultFailure, DocumentReference>>
      doneQuestionnaireIntervention(
          {required String questionnaireInterventionId}) async {
    try {
      final failureOrUserApp = await getUser();
      failureOrUserApp.fold(
        (l) {
          return Left(DefaultFailure(
              message:
                  "Can't make done Questionnaire Intervention for user. Error: $l"));
        },
        (UserApp userApp) async {
          final Map<String, List<String>> pastInterventions =
              userApp.pastInterventions;
          final Map<String, List<String>> activeInterventions =
              userApp.activeInterventions;
          activeInterventions.remove('QLQ-C30');

          if (userApp.pastInterventions.containsKey('QLQ-C30')) {
            pastInterventions['QLQ-C30']!.add(questionnaireInterventionId);
          } else {
            pastInterventions['QLQ-C30'] = [questionnaireInterventionId];
          }
          log(userApp.email);
          log(userApp.id.toString());

          log('activeInterventions: ${activeInterventions.toString()}');
          await documentReference.update({
            'pastInterventions': pastInterventions,
            'activeInterventions': activeInterventions
          });
        },
      );
    } catch (e) {
      return Left(DefaultFailure(
          message:
              "Can't make done Questionnaire Intervention for user. Error: $e"));
    }
    return Right(documentReference);
  }

  Future<Either<DefaultFailure, DocumentReference>>
      assign30x30ChallangeIntervention(
          {required String challanhe30x30InterventionId}) async {
    try {
      final failureOrUserApp = await getUser();
      failureOrUserApp.fold((l) {
        log("Can't get UserApp: Error: $l");
        return Left(DefaultFailure(
            message:
                "Can't assign 30x30 Challange Intervention to user. Error: $l"));
      }, (UserApp userApp) async {
        final Map<String, List<String>> activeInterventions =
            userApp.activeInterventions;

        if (userApp.activeInterventions.containsKey('30x30_challange')) {
          activeInterventions['30x30_challange']!
              .add(challanhe30x30InterventionId);
        } else {
          activeInterventions['30x30_challange'] = [
            challanhe30x30InterventionId
          ];
        }
        await documentReference
            .update({'activeInterventions': activeInterventions});
      });
    } catch (e) {
      return Left(DefaultFailure(
          message:
              "Can't add 30x30 Challange Intervention to user. Error: $e"));
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

  Future<Either<DefaultFailure, void>> addUserActivitySession(
      ActivitySession activitySession) async {
    try {
      final failureOrUserApp = await getUser();
      return failureOrUserApp.fold(
        (l) {
          log(l.message);
          return Left(DefaultFailure(message: l.message));
        },
        (UserApp userApp) async {
          await documentReference.update(userApp
              .copyWith(
                  activitySessions:
                      userApp.activitySessions + [activitySession])
              .toJson());

          return const Right(null);
        },
      );
    } catch (e) {
      log("Can't add ActivitySession to user. Error: $e");
      return Left(DefaultFailure(
          message: "Can't add ActivitySession to user. Error: $e"));
    }
  }

  Future<Either<DefaultFailure, void>> addUserPointsEntry(
      PointsEntry pointsEntry) async {
    try {
      final failureOrUserApp = await getUser();
      return await failureOrUserApp.fold(
        (l) {
          log(l.message);
          return Left(DefaultFailure(message: l.message));
        },
        (UserApp userApp) async {
          await documentReference.update(userApp
              .copyWith(pointsEntries: userApp.pointsEntries + [pointsEntry])
              .toJson());

          return const Right(null);
        },
      );
    } catch (e) {
      log("Can't add PointsEntry to user. Error: $e");
      return Left(DefaultFailure(
          message: "Can't add ActivitySession to user. Error: $e"));
    }
  }

  Future<Either<DefaultFailure, void>> addBadge(String badgeKey) async {
    try {
      final failureOrUserApp = await getUser();
      return failureOrUserApp.fold(
        (l) => Left(DefaultFailure(message: l.message)),
        (UserApp userApp) async {
          final newBadgesList = userApp.badgesKeys;
          newBadgesList.add(badgeKey);

          await documentReference
              .update(userApp.copyWith(badgesKeys: newBadgesList).toJson());

          return const Right(null);
        },
      );
    } catch (e) {
      return Left(DefaultFailure(message: "Can't add a badge. Error: $e"));
    }
  }

  Future<Either<DefaultFailure, void>> updateUser(UserApp user) async {
    try {
      await documentReference.update(user.toJson());
      return const Right(null);
    } catch (e) {
      return Left(DefaultFailure(message: "Can't update user. Error: $e"));
    }
  }
}
