import 'dart:async';
import 'dart:developer';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:master_thesis/features/home_page/grid_items/activity/my_activity.dart';
import 'package:pedometer/pedometer.dart';

import 'package:stop_watch_timer/stop_watch_timer.dart';

abstract class ActivityState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ActivityStateLoading extends ActivityState {}

class ActivityStateLoaded extends ActivityState {
  final ExerciseState exerciseState;
  final int steps;
  final List<MyActivity> activities;
  final int seconds;

  final int minutes;
  final int hours;

  ActivityStateLoaded({
    required this.exerciseState,
    required this.steps,
    required this.activities,
    required this.seconds,
    required this.minutes,
    required this.hours,
  });

  @override
  List<Object?> get props => [
        exerciseState,
        steps,
        activities,
        seconds,
        minutes,
        hours,
      ];

  ActivityStateLoaded copyWith({
    ExerciseState? exerciseState,
    int? steps,
    List<MyActivity>? activities,
    int? seconds,
    int? minutes,
    int? hours,
  }) {
    return ActivityStateLoaded(
      exerciseState: exerciseState ?? this.exerciseState,
      steps: steps ?? this.steps,
      activities: activities ?? List.from(this.activities),
      seconds: seconds ?? this.seconds,
      minutes: minutes ?? this.minutes,
      hours: hours ?? this.hours,
    );
  }
}

class ActivityCubit extends Cubit<ActivityState> {
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
      activities: const [],
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
    if (currentState.activities.isEmpty) {
      log("START");
      emit(
        currentState.copyWith(
          exerciseState: ExerciseState.RUNNING,
          activities: currentState.activities +
              [
                MyActivity(
                  isActive: false,
                  timestamp: DateTime.now(),
                  isStart: true,
                  durationInMinutes: 0,
                )
              ],
        ),
      );
    }
  }

  void finish() {
    stopWatchTimer.onExecute.add(StopWatchExecute.stop);

    stepsSubscription.pause();
    activitySubscription.pause();
    final currentState = state as ActivityStateLoaded;

    log("STOP");

    emit(
      currentState.copyWith(
        exerciseState: ExerciseState.FINISHED,
        activities: currentState.activities +
            [
              MyActivity(
                isActive: false,
                timestamp: DateTime.now(),
                isEnd: true,
                durationInMinutes: 0,
              )
            ],
      ),
    );
  }

  void listenOnActivity(MyActivity event) {
    final newState = ActivityStateLoaded(
      exerciseState: ExerciseState.RUNNING,
      steps: (state as ActivityStateLoaded).steps,
      activities: (state as ActivityStateLoaded)
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
      seconds: currentSeconds,
      minutes: currentMinutes,
      hours: currentHours,
    );
    final currentStateActivities = newState.activities;

    final int diff = event.timestamp
        .difference(
            currentStateActivities[currentStateActivities.length - 1].timestamp)
        .inMinutes;

    final bool isSameAction =
        (currentStateActivities[currentStateActivities.length - 1].isActive ==
                event.isActive) &&
            currentStateActivities[currentStateActivities.length - 1].isStart ==
                false;

    if (isSameAction && diff > 0) {
      currentStateActivities[currentStateActivities.length - 1]
          .durationInMinutes = diff;

      emit(newState);
    } else if (!isSameAction && diff > 1) {
      emit((state as ActivityStateLoaded).copyWith(
          activities: (state as ActivityStateLoaded).activities +
              [event.copyWith(durationInMinutes: 2)]));
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
