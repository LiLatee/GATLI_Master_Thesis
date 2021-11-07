// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_one_day_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeOneDayStats _$ChallangeOneDayStatsFromJson(
        Map<String, dynamic> json) =>
    ChallengeOneDayStats(
      day: DateTime.parse(json['day'] as String),
      steps: json['steps'] as int,
      minutesOfMove: json['minutesOfMove'] as int,
    );

Map<String, dynamic> _$ChallangeOneDayStatsToJson(
        ChallengeOneDayStats instance) =>
    <String, dynamic>{
      'day': instance.day.toIso8601String(),
      'steps': instance.steps,
      'minutesOfMove': instance.minutesOfMove,
    };
