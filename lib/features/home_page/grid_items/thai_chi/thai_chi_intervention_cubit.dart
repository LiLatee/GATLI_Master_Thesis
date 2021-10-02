import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_thesis/features/data/user_app.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_intervention.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_interventions_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_lesson.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_lessons_repository.dart';
import 'package:master_thesis/service_locator.dart';

abstract class ThaiChiInterventionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ThaiChiInterventionStateLoading extends ThaiChiInterventionState {}

class ThaiChiInterventionStateLoaded extends ThaiChiInterventionState {
  ThaiChiInterventionStateLoaded({
    required this.lessons,
    required this.thaiChiIntervention,
  });

  final List<ThaiChiLessonUser> lessons;
  final ThaiChiIntervention thaiChiIntervention;

  @override
  List<Object?> get props => [
        lessons,
        thaiChiIntervention,
      ];
}

class ThaiChiInterventionStateError extends ThaiChiInterventionState {
  ThaiChiInterventionStateError({required this.errorMessage});

  final String errorMessage;
}

class ThaiChiInterventionCubit extends Cubit<ThaiChiInterventionState> {
  ThaiChiInterventionCubit() : super(ThaiChiInterventionStateLoading()) {
    _interventionsRepository.getStream().listen((event) => loadData());
    loadData();
  }

  final UserRepository _userRepository = sl<UserRepository>();
  final ThaiChiLessonsRepository _lessonsRepository =
      sl<ThaiChiLessonsRepository>();
  final ThaiChiInterventionsRepository _interventionsRepository =
      sl<ThaiChiInterventionsRepository>();

  Future<void> loadData() async {
    final failureOrUser = await _userRepository.getUser();
    final UserApp? userApp = await failureOrUser.fold(
      (l) {
        emit(ThaiChiInterventionStateError(errorMessage: l.message));
        return null;
      },
      (UserApp userApp) => userApp,
    );
    if (userApp == null) {
      return;
    }

    final String thaiChiInterventionId =
        userApp.activeInterventions['thai_chi']![0];
    final failureOrIntervention = await _interventionsRepository
        .getThaiChiIntervention(id: thaiChiInterventionId);

    late final ThaiChiIntervention thaiChiIntervention;
    final nullOrRes = failureOrIntervention.fold(
      (l) {
        emit(ThaiChiInterventionStateError(errorMessage: l.message));
        return null;
      },
      (ThaiChiIntervention intervention) {
        thaiChiIntervention = intervention;
        return [
          intervention.lessonsToDo,
          intervention.lessonsDone,
        ];
      },
    );
    if (nullOrRes == null) {
      return;
    }

    final List<String> lessonsTodoId = nullOrRes[0];

    final futuresTodo = lessonsTodoId.map((id) async {
      final failureOrLesson = await _lessonsRepository.getThaiChiLesson(id);
      return failureOrLesson.fold(
        (l) {
          emit(ThaiChiInterventionStateError(errorMessage: l.message));
          return null;
        },
        (lesson) => ThaiChiLessonUser.fromThaiChiLesson(
            thaiChiLesson: lesson, isPerformed: false),
      );
    }).toList();

    final List<String> lessonsDoneId = nullOrRes[1];
    final List<ThaiChiLessonUser?> lessons = await Future.wait(futuresTodo);

    final futuresDone = lessonsDoneId.map((id) async {
      final failureOrLesson = await _lessonsRepository.getThaiChiLesson(id);
      return failureOrLesson.fold(
        (l) {
          emit(ThaiChiInterventionStateError(errorMessage: l.message));
          return null;
        },
        (lesson) => ThaiChiLessonUser.fromThaiChiLesson(
            thaiChiLesson: lesson, isPerformed: true),
      );
    }).toList();

    lessons.addAll(await Future.wait(futuresDone));
    for (final lesson in lessons) {
      if (lesson == null) {
        emit(ThaiChiInterventionStateError(
            errorMessage: 'Error: ThaiChiInterventionCubit.loadData()'));
        return;
      }
    }
    final List<ThaiChiLessonUser> notNullLessons =
        lessons.map((e) => e!).toList();
    emit(ThaiChiInterventionStateLoaded(
      lessons: notNullLessons,
      thaiChiIntervention: thaiChiIntervention,
    ));
  }
}

class ThaiChiLessonUser extends ThaiChiLesson {
  const ThaiChiLessonUser({
    required String id,
    required String ytVideoId,
    required String title,
    required String description,
    required this.isPerformed,
  }) : super(
          id: id,
          ytVideoId: ytVideoId,
          title: title,
          description: description,
        );

  final bool isPerformed;

  factory ThaiChiLessonUser.fromThaiChiLesson({
    required ThaiChiLesson thaiChiLesson,
    required bool isPerformed,
  }) =>
      ThaiChiLessonUser(
        id: thaiChiLesson.id,
        description: thaiChiLesson.description,
        title: thaiChiLesson.title,
        ytVideoId: thaiChiLesson.ytVideoId,
        isPerformed: isPerformed,
      );

  @override
  List<Object?> get props => [
        ...super.props,
        isPerformed,
      ];
}
