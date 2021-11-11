import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_activity.g.dart';

MyActivityType activityTypeToMyActivityType(ActivityType activityType) {
  if (activityType == ActivityType.INVALID) {
    return MyActivityType.INVALID;
  }
  if (activityType == ActivityType.UNKNOWN) {
    return MyActivityType.UNKNOWN;
  }
  if (activityType == ActivityType.IN_VEHICLE) {
    return MyActivityType.IN_VEHICLE;
  }
  if (activityType == ActivityType.WALKING) {
    return MyActivityType.WALKING;
  }
  if (activityType == ActivityType.ON_FOOT) {
    return MyActivityType.ON_FOOT;
  }
  if (activityType == ActivityType.ON_BICYCLE) {
    return MyActivityType.ON_BICYCLE;
  }
  if (activityType == ActivityType.RUNNING) {
    return MyActivityType.RUNNING;
  }
  if (activityType == ActivityType.STILL) {
    return MyActivityType.STILL;
  }
  if (activityType == ActivityType.TILTING) {
    return MyActivityType.TILTING;
  }

  throw Exception('ActivityTypeToMyActivityType wrong argument');
}

enum MyActivityType {
  @JsonValue('IN_VEHICLE')
  IN_VEHICLE,
  @JsonValue('ON_BICYCLE')
  ON_BICYCLE,
  @JsonValue('ON_FOOT')
  ON_FOOT,
  @JsonValue('RUNNING')
  RUNNING,
  @JsonValue('STILL')
  STILL,
  @JsonValue('TILTING')
  TILTING,
  @JsonValue('UNKNOWN')
  UNKNOWN,
  @JsonValue('WALKING')
  WALKING,
  @JsonValue('INVALID')
  INVALID
}

@JsonSerializable()
// ignore: must_be_immutable
class MyActivity extends Equatable {
  final bool isActive;
  final DateTime timestamp;
  final MyActivityType? type;
  final int? confidence;
  final bool isStart;
  final bool isEnd;
  int durationInMinutes;

  MyActivity({
    required this.isActive,
    required this.timestamp,
    this.durationInMinutes = 0,
    this.type,
    this.confidence,
    this.isStart = false,
    this.isEnd = false,
  }) : assert(isStart || isEnd || type != null,
            'Activity has to be starting, ending or between.');

  factory MyActivity.fromJson(Map<String, dynamic> json) =>
      _$MyActivityFromJson(json);

  Map<String, dynamic> toJson() => _$MyActivityToJson(this);

  @override
  List<Object?> get props => [
        isActive,
        timestamp,
        durationInMinutes,
        type,
        confidence,
        isStart,
        isEnd,
      ];

  MyActivity copyWith({
    bool? isActive,
    DateTime? timestamp,
    MyActivityType? type,
    int? confidence,
    bool? isStart,
    bool? isEnd,
    int? durationInMinutes,
  }) {
    return MyActivity(
      isActive: isActive ?? this.isActive,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      confidence: confidence ?? this.confidence,
      isStart: isStart ?? this.isStart,
      isEnd: isEnd ?? this.isEnd,
      durationInMinutes: durationInMinutes ?? this.durationInMinutes,
    );
  }
}

enum ExerciseState {
  NOT_STARTED,
  RUNNING,
  FINISHED,
}
