// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivitySession _$ActivitySessionFromJson(Map<String, dynamic> json) =>
    ActivitySession(
      activities: (json['activities'] as List<dynamic>)
          .map((e) => MyActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      minutesOfActivity: json['minutesOfActivity'] as int,
      steps: json['steps'] as int,
    );

Map<String, dynamic> _$ActivitySessionToJson(ActivitySession instance) =>
    <String, dynamic>{
      'activities': instance.activities.map((e) => e.toJson()).toList(),
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'minutesOfActivity': instance.minutesOfActivity,
      'steps': instance.steps,
    };
