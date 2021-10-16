// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challange_one_day_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallangeOneDayStats _$ChallangeOneDayStatsFromJson(
        Map<String, dynamic> json) =>
    ChallangeOneDayStats(
      day: DateTime.parse(json['day'] as String),
      steps: json['steps'] as int,
      minutesOfMove: json['minutesOfMove'] as int,
    );

Map<String, dynamic> _$ChallangeOneDayStatsToJson(
        ChallangeOneDayStats instance) =>
    <String, dynamic>{
      'day': instance.day.toIso8601String(),
      'steps': instance.steps,
      'minutesOfMove': instance.minutesOfMove,
    };
