import 'dart:async';
import 'dart:developer';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_thesis/features/home_page/grid_items/activity/activity_page.dart';
import 'package:pedometer/pedometer.dart';

class MyActivity extends Equatable {
  final bool isActive;
  final DateTime timestamp;
  final ActivityType? type;
  final int? confidence;
  final bool isStart;
  final bool isEnd;

  const MyActivity({
    required this.isActive,
    required this.timestamp,
    this.type,
    this.confidence,
    this.isStart = false,
    this.isEnd = false,
  }) : assert(isStart || isEnd || type != null,
            'Activity has to be starting, ending or between.');

  @override
  List<Object?> get props => [
        isActive,
        timestamp,
        type,
        confidence,
        isStart,
        isEnd,
      ];
}

abstract class ActivityState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ActivityStateLoading extends ActivityState {}

class ActivityStateLoaded extends ActivityState {
  final int steps;
  final List<MyActivityDuration> activities;

  ActivityStateLoaded({
    required this.steps,
    required this.activities,
  });

  @override
  List<Object?> get props => [
        steps,
        activities,
      ];

  ActivityStateLoaded copyWith({
    int? steps,
    List<MyActivityDuration>? activities,
  }) {
    return ActivityStateLoaded(
      steps: steps ?? this.steps,
      activities: activities ?? this.activities,
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

  static const activeActivityTypes = [
    ActivityType.ON_BICYCLE,
    ActivityType.ON_FOOT,
    ActivityType.RUNNING,
    ActivityType.TILTING,
    ActivityType.WALKING,
  ];
  Future<void> init() async {
    // Activity
    activityStream =
        activityRecognition.startStream(runForegroundService: false);

    // Steps
    stepsStream = Pedometer.stepCountStream;
    initialSteps = (await Pedometer.stepCountStream.first).steps;
    emit(ActivityStateLoaded(
      steps: 0,
      activities: const [],
    ));

    stepsSubscription = stepsStream.listen(listenOnSteps);
    activitySubscription = activityStream.map((event) {
      if (activeActivityTypes.contains(event.type)) {
        return MyActivityDuration(
            myActivity: MyActivity(
              isActive: true,
              timestamp: event.timeStamp,
              type: event.type,
              confidence: event.confidence,
            ),
            durationInMinutes: 0);
      } else {
        return MyActivityDuration(
            myActivity: MyActivity(
              isActive: false,
              timestamp: event.timeStamp,
              type: event.type,
              confidence: event.confidence,
            ),
            durationInMinutes: 0);
      }
    }).listen(listenOnActivity);
    stepsSubscription.pause();
    activitySubscription.pause();
  }

  void start() {
    stepsSubscription.resume();
    activitySubscription.resume();
    final currentState = state as ActivityStateLoaded;
    if (currentState.activities.isEmpty) {
      log("START");
      emit(
        currentState.copyWith(
          activities: currentState.activities +
              [
                MyActivityDuration(
                  myActivity: MyActivity(
                    isActive: false,
                    timestamp: DateTime.now(),
                    isStart: true,
                  ),
                  durationInMinutes: 0,
                )
              ],
        ),
      );
    }
  }

  void pause() {
    stepsSubscription.pause();
    activitySubscription.pause();
    final currentState = state as ActivityStateLoaded;

    log("STOP");

    emit(
      currentState.copyWith(
        activities: currentState.activities +
            [
              MyActivityDuration(
                myActivity: MyActivity(
                  isActive: false,
                  timestamp: DateTime.now(),
                  isEnd: true,
                ),
                durationInMinutes: 0,
              )
            ],
      ),
    );
  }

  void listenOnActivity(MyActivityDuration event) {
    log(event.toString());

    final currentState = state as ActivityStateLoaded;
    final currentStateActivities = currentState.activities;

    if (currentStateActivities[currentStateActivities.length - 1].type ==
        event.type) {
      currentStateActivities[currentStateActivities.length - 1]
              .durationInMinutes =
          event.timestamp
              .difference(
                  currentStateActivities[currentStateActivities.length - 1]
                      .timestamp)
              .inMinutes;

      emit(currentState.copyWith(activities: currentStateActivities));
    }
    // emit(currentState.copyWith(
    //     activities: currentState.activities +
    //         [event])); // TODO This needs optimalization.
  }

  void listenOnSteps(StepCount event) {
    final currentState = state as ActivityStateLoaded;
    emit(currentState.copyWith(steps: event.steps - initialSteps));
  }

  @override
  void onChange(Change<ActivityState> change) {
    log("${change.currentState} ==> ${change.nextState}");
    super.onChange(change);
  }
}
