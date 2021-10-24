import 'dart:async';
import 'dart:developer';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:master_thesis/core/error/failures.dart';
import 'package:master_thesis/features/data/points_entry.dart';
import 'package:master_thesis/features/data/user_app.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/30x30_challange/challange_30x30_cubit.dart';
import 'package:master_thesis/features/home_page/grid_items/30x30_challange/challange_30x30_intervention.dart';

import 'package:master_thesis/features/home_page/grid_items/30x30_challange/challange_30x30_intervention_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/30x30_challange/challange_one_day_stats.dart';

import 'package:master_thesis/features/home_page/grid_items/activity/activity_session.dart';
import 'package:master_thesis/features/home_page/grid_items/activity/my_activity.dart';
import 'package:master_thesis/service_locator.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stop_watch_timer/stop_watch_timer.dart';

abstract class ActivityState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ActivityStateLoading extends ActivityState {}

class ActivityStateLoaded extends ActivityState {
  final ExerciseState exerciseState;
  final int steps;
  // final List<MyActivity> activities;
  final ActivitySession activitySession;
  final int seconds;

  final int minutes;
  final int hours;

  ActivityStateLoaded({
    required this.exerciseState,
    required this.steps,
    // required this.activities,
    required this.activitySession,
    required this.seconds,
    required this.minutes,
    required this.hours,
  });

  @override
  List<Object?> get props => [
        exerciseState,
        steps,
        // activities,
        activitySession,
        seconds,
        minutes,
        hours,
      ];

  ActivityStateLoaded copyWith({
    ExerciseState? exerciseState,
    int? steps,
    // List<MyActivity>? activities,
    ActivitySession? activitySession,
    int? seconds,
    int? minutes,
    int? hours,
  }) {
    return ActivityStateLoaded(
      exerciseState: exerciseState ?? this.exerciseState,
      steps: steps ?? this.steps,
      // activities: activities ?? List.from(this.activities),
      activitySession: activitySession ?? this.activitySession,
      seconds: seconds ?? this.seconds,
      minutes: minutes ?? this.minutes,
      hours: hours ?? this.hours,
    );
  }
}

class ActivityCubit extends Cubit<ActivityState> {
  static const String last30MinActivityDoneDate = 'last30MinActivityDoneDate';

  ActivityCubit() : super(ActivityStateLoading()) {
    init();
  }

  late final Stream<ActivityEvent> activityStream;
  late final ActivityRecognition activityRecognition =
      ActivityRecognition.instance;
  late final StreamSubscription activitySubscription;

  late final Stream<StepCount> stepsStream;
  late final StreamSubscription stepsSubscription;
  late final int initialSteps;

  late final StopWatchTimer stopWatchTimer;
  int currentMinutes = 0;
  int currentHours = 0;
  int currentSeconds = 0;

  static const activeActivityTypes = [
    ActivityType.ON_BICYCLE,
    ActivityType.ON_FOOT,
    ActivityType.RUNNING,
    ActivityType.TILTING,
    ActivityType.WALKING,
  ];

  final UserRepository userRepository = sl<UserRepository>();

  final Challange30x30InterventionRepository challangeRepository =
      sl<Challange30x30InterventionRepository>();

  Future<void> init() async {
    //StopWatchTimer
    stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countUp,
      // presetMillisecond:
      //     StopWatchTimer.getMilliSecFromMinute(1), // millisecond => minute.
      onChange: (milliSecond) {
        final currentHours = StopWatchTimer.getRawHours(milliSecond);
        final currentMinutes = StopWatchTimer.getMinute(milliSecond);
        final currentSeconds = StopWatchTimer.getRawSecond(milliSecond);

        emit((state as ActivityStateLoaded).copyWith(
          hours: currentHours,
          minutes: currentMinutes % 60,
          seconds: currentSeconds % 60,
        ));
      },
      onChangeRawSecond: (value) => log('onChangeRawSecond $value'),
      onChangeRawMinute: (value) => log('onChangeRawMinute $value'),
    );

    // Activity
    activityStream =
        activityRecognition.startStream(runForegroundService: false);

    // Steps
    stepsStream = Pedometer.stepCountStream;
    initialSteps = (await Pedometer.stepCountStream.first).steps;
    emit(ActivityStateLoaded(
      exerciseState: ExerciseState.NOT_STARTED,
      steps: 0,
      // activities: const [],
      activitySession: ActivitySession(
          activities: const [],
          startTime: DateTime.now(),
          minutesOfActivity: 0,
          steps: 0),
      seconds: 0,
      minutes: 0,
      hours: 0,
    ));

    stepsSubscription = stepsStream.listen(listenOnSteps, onError: (e, s) {
      log('stepCountStream Error: $e');
      log('stepCountStream Stack: $s');
    });

    activitySubscription = activityStream.map((event) {
      if (activeActivityTypes.contains(event.type)) {
        return MyActivity(
            isActive: true,
            timestamp: event.timeStamp,
            type: activityTypeToMyActivityType(event.type),
            confidence: event.confidence,
            durationInMinutes: 0);
      } else {
        return MyActivity(
            isActive: false,
            timestamp: event.timeStamp,
            type: activityTypeToMyActivityType(event.type),
            confidence: event.confidence,
            durationInMinutes: 0);
      }
    }).listen(listenOnActivity);
    stepsSubscription.pause();
    activitySubscription.pause();
  }

  @override
  Future<void> close() {
    stopWatchTimer.dispose();
    activitySubscription.cancel();
    stepsSubscription.cancel();
    return super.close();
  }

  void start() {
    stopWatchTimer.onExecute.add(StopWatchExecute.start);

    stepsSubscription.resume();
    activitySubscription.resume();

    final currentState = state as ActivityStateLoaded;
    if (currentState.activitySession.activities.isEmpty) {
      log("START");
      emit(
        currentState.copyWith(
          exerciseState: ExerciseState.RUNNING,
          activitySession: currentState.activitySession.copyWith(
            activities: currentState.activitySession.activities +
                [
                  MyActivity(
                    isActive: false,
                    timestamp: DateTime.now(),
                    isStart: true,
                    durationInMinutes: 0,
                  ),
                ],
          ),
        ),
      );
    }
  }

  Future<void> finish() async {
    stopWatchTimer.onExecute.add(StopWatchExecute.stop);

    stepsSubscription.pause();
    activitySubscription.pause();
    final currentState = state as ActivityStateLoaded;

    log("STOP");
    final newState = currentState.copyWith(
      exerciseState: ExerciseState.FINISHED,
      activitySession: currentState.activitySession.copyWith(
        activities: currentState.activitySession.activities +
            [
              MyActivity(
                isActive: false,
                timestamp: DateTime.now(),
                isEnd: true,
                durationInMinutes: 0,
              )
            ],
        endTime: DateTime.now(),
      ),
    );

    int minutesOfActivity = 0;
    currentState.activitySession.activities
        .where((element) => element.isActive)
        .forEach((MyActivity myActivity) =>
            minutesOfActivity += myActivity.durationInMinutes);
    final finishedActivitySession = newState.activitySession.copyWith(
      steps: (state as ActivityStateLoaded).steps,
      minutesOfActivity: minutesOfActivity,
    );
    final failureOrNewUser =
        sl<UserRepository>().addUserActivitySession(finishedActivitySession);

    await failureOrNewUser;

    await update30x30ChallangeIntervention(finishedActivitySession);

    sl<UserRepository>().addUserPointsEntry(
      PredefinedEntryPoints.activityXMins.copyWith(
        datetime: DateTime.now(),
        points: currentState.minutes,
      ),
    );

    emit(newState);
  }

  Future<void> update30x30ChallangeIntervention(
      ActivitySession activitySession) async {
    final failureOrUser = await userRepository.getUser();

    failureOrUser.fold(
      (DefaultFailure failure) => log('ActivityCubit - cannot get user'),
      (UserApp userApp) async {
        final failureOrChallangeIntervention =
            await challangeRepository.getChallange30x30Intervention(
                id: userApp.activeInterventions['30x30_challange']![0]);

        failureOrChallangeIntervention.fold(
          (DefaultFailure failure) =>
              log('ActivityCubit - cannot get 30x30 Challange intervention'),
          (intervention) async {
            final currentState = state as ActivityStateLoaded;
            final String todayString = DateFormat('yyyy-MM-dd')
                .format(currentState.activitySession.startTime);
            final days = intervention.days;

            final ChallangeOneDayStats? challangeDayStats = days![todayString];

            final ChallangeOneDayStats updatedChallangeDayStats =
                ChallangeOneDayStats(
              day: challangeDayStats?.day ??
                  DateTime(
                    activitySession.startTime.year,
                    activitySession.startTime.month,
                    activitySession.startTime.day,
                  ),
              steps: activitySession.steps > (challangeDayStats?.steps ?? 0)
                  ? activitySession.steps
                  : (challangeDayStats?.steps ?? 0),
              minutesOfMove: activitySession.minutesOfActivity >
                      (challangeDayStats?.minutesOfMove ?? 0)
                  ? activitySession.minutesOfActivity
                  : (challangeDayStats?.minutesOfMove ?? 0),
            );

            days[todayString] = updatedChallangeDayStats;

            final Challange30x30Intervention newChallange30x30Intervention =
                intervention.copyWith(days: days);

            if (activitySession.minutesOfActivity >
                    (challangeDayStats?.minutesOfMove ?? 0) &&
                activitySession.minutesOfActivity >= 5) //TODO change to 30
            {
              final DateTime now = DateTime.now().toUtc();
              final DateTime today = DateTime(now.year, now.month, now.day);
              sl<SharedPreferences>().setString(
                  ActivityCubit.last30MinActivityDoneDate, today.toString());
            }

            await challangeRepository.updateChallange30x30Intervention(
                newChallange30x30Intervention: newChallange30x30Intervention);
          },
        );
      },
    );
  }

  void listenOnActivity(MyActivity event) {
    final newState = ActivityStateLoaded(
      exerciseState: ExerciseState.RUNNING,
      steps: (state as ActivityStateLoaded).steps,
      activitySession: (state as ActivityStateLoaded).activitySession.copyWith(
            activities: (state as ActivityStateLoaded)
                .activitySession
                .activities
                .map((e) => MyActivity(
                      isActive: e.isActive,
                      timestamp: e.timestamp,
                      confidence: e.confidence,
                      durationInMinutes: e.durationInMinutes,
                      isEnd: e.isEnd,
                      isStart: e.isStart,
                      type: e.type,
                    ))
                .toList(),
          ),
      seconds: currentSeconds,
      minutes: currentMinutes,
      hours: currentHours,
    );
    final currentStateActivities = newState.activitySession.activities;

    final int diffInMinutes = event.timestamp
        .difference(
            currentStateActivities[currentStateActivities.length - 1].timestamp)
        .inMinutes;

    final bool isSameAction =
        (currentStateActivities[currentStateActivities.length - 1].isActive ==
                event.isActive) &&
            currentStateActivities[currentStateActivities.length - 1].isStart ==
                false;
    log('diff: ${diffInMinutes.toString()}');
    const int minimumMinutes = 1;
    if (isSameAction && diffInMinutes > minimumMinutes - 1) {
      log('sameAction');
      currentStateActivities[currentStateActivities.length - 1]
          .durationInMinutes = diffInMinutes;

      emit(newState);
    } else if (!isSameAction && diffInMinutes > minimumMinutes) {
      log('not sameAction');

      emit(
        (state as ActivityStateLoaded).copyWith(
          activitySession: (state as ActivityStateLoaded)
              .activitySession
              .copyWith(
                activities:
                    (state as ActivityStateLoaded).activitySession.activities +
                        [
                          event.copyWith(
                              durationInMinutes: minimumMinutes,
                              timestamp: event.timestamp.subtract(
                                Duration(minutes: minimumMinutes),
                              ))
                        ],
              ),
        ),
      );
    }
  }

  void listenOnSteps(StepCount event) {
    final currentState = state as ActivityStateLoaded;
    emit(currentState.copyWith(steps: event.steps - initialSteps));
  }

  // @override
  // void onChange(Change<ActivityState> change) {
  //   log("ON CHANGE: ${change.currentState} ==> ${change.nextState}");
  //   super.onChange(change);
  // }
}
