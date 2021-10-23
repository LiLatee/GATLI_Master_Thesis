import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_thesis/features/data/user_app.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/tai_chi/tai_chi_intervention.dart';
import 'package:master_thesis/features/home_page/grid_items/tai_chi/tai_chi_interventions_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/tai_chi/tai_chi_lesson.dart';
import 'package:master_thesis/features/home_page/grid_items/tai_chi/tai_chi_lessons_repository.dart';
import 'package:master_thesis/service_locator.dart';

abstract class TaiChiInterventionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaiChiInterventionStateLoading extends TaiChiInterventionState {}

class TaiChiInterventionStateLoaded extends TaiChiInterventionState {
  TaiChiInterventionStateLoaded({
    required this.lessons,
    required this.taiChiIntervention,
  });

  final List<TaiChiLessonUser> lessons;
  final TaiChiIntervention taiChiIntervention;

  @override
  List<Object?> get props => [
        lessons,
        taiChiIntervention,
      ];
}

class TaiChiInterventionStateError extends TaiChiInterventionState {
  TaiChiInterventionStateError({required this.errorMessage});

  final String errorMessage;
}

class TaiChiInterventionCubit extends Cubit<TaiChiInterventionState> {
  TaiChiInterventionCubit() : super(TaiChiInterventionStateLoading()) {
    _interventionsRepository.getStream().listen((event) => loadData());
    loadData();
  }

  final UserRepository _userRepository = sl<UserRepository>();
  final TaiChiLessonsRepository _lessonsRepository =
      sl<TaiChiLessonsRepository>();
  final TaiChiInterventionsRepository _interventionsRepository =
      sl<TaiChiInterventionsRepository>();

  Future<void> loadData() async {
    final failureOrUser = await _userRepository.getUser();
    final UserApp? userApp = await failureOrUser.fold(
      (l) {
        emit(TaiChiInterventionStateError(errorMessage: l.message));
        return null;
      },
      (UserApp userApp) => userApp,
    );
    if (userApp == null) {
      return;
    }

    final String taiChiInterventionId =
        userApp.activeInterventions['tai_chi']![0];
    final failureOrIntervention = await _interventionsRepository
        .getTaiChiIntervention(id: taiChiInterventionId);

    late final TaiChiIntervention taiChiIntervention;
    final nullOrRes = failureOrIntervention.fold(
      (l) {
        emit(TaiChiInterventionStateError(errorMessage: l.message));
        return null;
      },
      (TaiChiIntervention intervention) {
        taiChiIntervention = intervention;
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
      final failureOrLesson = await _lessonsRepository.getTaiChiLesson(id);
      return failureOrLesson.fold(
        (l) {
          emit(TaiChiInterventionStateError(errorMessage: l.message));
          return null;
        },
        (lesson) => TaiChiLessonUser.fromTaiChiLesson(
            taiChiLesson: lesson, isPerformed: false),
      );
    }).toList();

    final List<String> lessonsDoneId = nullOrRes[1];
    final List<TaiChiLessonUser?> lessons = await Future.wait(futuresTodo);

    final futuresDone = lessonsDoneId.map((id) async {
      final failureOrLesson = await _lessonsRepository.getTaiChiLesson(id);
      return failureOrLesson.fold(
        (l) {
          emit(TaiChiInterventionStateError(errorMessage: l.message));
          return null;
        },
        (lesson) => TaiChiLessonUser.fromTaiChiLesson(
            taiChiLesson: lesson, isPerformed: true),
      );
    }).toList();

    lessons.addAll(await Future.wait(futuresDone));
    for (final lesson in lessons) {
      if (lesson == null) {
        emit(TaiChiInterventionStateError(
            errorMessage: 'Error: TaiChiInterventionCubit.loadData()'));
        return;
      }
    }
    final List<TaiChiLessonUser> notNullLessons =
        lessons.map((e) => e!).toList();
    emit(TaiChiInterventionStateLoaded(
      lessons: notNullLessons,
      taiChiIntervention: taiChiIntervention,
    ));
  }
}

class TaiChiLessonUser extends TaiChiLesson {
  const TaiChiLessonUser({
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

  factory TaiChiLessonUser.fromTaiChiLesson({
    required TaiChiLesson taiChiLesson,
    required bool isPerformed,
  }) =>
      TaiChiLessonUser(
        id: taiChiLesson.id,
        description: taiChiLesson.description,
        title: taiChiLesson.title,
        ytVideoId: taiChiLesson.ytVideoId,
        isPerformed: isPerformed,
      );

  @override
  List<Object?> get props => [
        ...super.props,
        isPerformed,
      ];
}
