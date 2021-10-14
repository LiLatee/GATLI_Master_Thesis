import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:master_thesis/core/error/failures.dart';
import 'package:master_thesis/features/data/user_app.dart';
import 'package:master_thesis/features/home_page/grid_items/activity/activity_session.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire_intervention_repository.dart';
import 'package:master_thesis/service_locator.dart';
import 'package:pedometer/pedometer.dart';

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

  Future<Either<DefaultFailure, DocumentReference>> assignThaiChiIntervention(
      {required String thaiChiInterventionId}) async {
    try {
      final failureOrUserApp = await getUser();
      failureOrUserApp.fold((l) {
        log("Can't get UserApp: Error: $l");
        return Left(DefaultFailure(
            message: "Can't assign Thai Chi Intervention to user. Error: $l"));
      }, (UserApp userApp) async {
        final Map<String, List<String>> activeInterventions =
            userApp.activeInterventions;

        if (userApp.activeInterventions.containsKey('thai_chi')) {
          activeInterventions['thai_chi']!.add(thaiChiInterventionId);
        } else {
          activeInterventions['thai_chi'] = [thaiChiInterventionId];
        }
        await documentReference
            .update({'activeInterventions': activeInterventions});
      });
    } catch (e) {
      return Left(DefaultFailure(
          message: "Can't add Thai Chi Intervention to user. Error: $e"));
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
          message: "Can't add Thai Chi Intervention to user. Error: $e"));
    }
  }

  Future<Either<DefaultFailure, UserApp>> getUser() async {
    print('getUser');

    final Map<String, dynamic> userAppMap;
    try {
      userAppMap =
          (await documentReference.get()).data() as Map<String, dynamic>;
      return Right(UserApp.fromJson(userAppMap)); // usunięte .copyWith(id: id)
    } catch (e) {
      print('getUser - failure');

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

  Future<Either<DefaultFailure, void>> updateUserSteps() async {
    print('updateUserSteps - start');
    try {
      final failureOrUserApp = await getUser();
      return failureOrUserApp.fold(
        (l) {
          print('updateUserSteps - fail1');

          log(l.message);
          return Left(DefaultFailure(message: l.message));
        },
        (UserApp userApp) async {
          print('updateUserSteps - in1');
          var steps = 0;
          try {
            steps = (await Pedometer.stepCountStream
                    .firstWhere((element) => element != null))
                .steps;
          } catch (e, s) {
            print("updateUserSteps- error ${e}");
            print("updateUserSteps - error ${s}");
            return Left(DefaultFailure(message: 'aaaaa'));
          }

          print('updateUserSteps - in2');

          await documentReference
              .update(userApp.copyWith(steps: userApp.steps + steps).toJson());
          print('updateUserSteps - done');

          return const Right(null);
        },
      );
    } catch (e) {
      print('updateUserSteps - fail2');

      log("Can't update user's steps. Error: $e");
      return Left(
          DefaultFailure(message: "Can't update user's steps. Error: $e"));
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
