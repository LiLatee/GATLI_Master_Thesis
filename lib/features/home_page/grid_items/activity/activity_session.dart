import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:master_thesis/features/home_page/grid_items/activity/my_activity.dart';

part 'activity_session.g.dart';

@JsonSerializable(explicitToJson: true)
class ActivitySession extends Equatable {
  final List<MyActivity> activities;
  final DateTime startTime;
  final DateTime? endTime;
  final int minutesOfActivity;

  const ActivitySession({
    required this.activities,
    required this.startTime,
    this.endTime,
    required this.minutesOfActivity,
  });

  factory ActivitySession.fromJson(Map<String, dynamic> json) =>
      _$ActivitySessionFromJson(json);

  Map<String, dynamic> toJson() => _$ActivitySessionToJson(this);

  @override
  List<Object?> get props => [
        activities,
        startTime,
        endTime,
        minutesOfActivity,
      ];

  ActivitySession copyWith({
    List<MyActivity>? activities,
    DateTime? startTime,
    DateTime? endTime,
    int? minutesOfActivity,
  }) {
    return ActivitySession(
      activities: activities ?? this.activities,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      minutesOfActivity: minutesOfActivity ?? this.minutesOfActivity,
    );
  }
}
