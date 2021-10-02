// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thai_chi_intervention.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThaiChiIntervention _$ThaiChiInterventionFromJson(Map<String, dynamic> json) =>
    ThaiChiIntervention(
      id: json['id'] as String,
      userId: json['userId'] as String,
      lessonsDone: (json['lessonsDone'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lessonsToDo: (json['lessonsToDo'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      startTimestamp: json['startTimestamp'] as int,
      endTimestamp: json['endTimestamp'] as int?,
      earnedPoints: json['earnedPoints'] as int,
    );

Map<String, dynamic> _$ThaiChiInterventionToJson(
        ThaiChiIntervention instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'lessonsDone': instance.lessonsDone,
      'lessonsToDo': instance.lessonsToDo,
      'startTimestamp': instance.startTimestamp,
      'endTimestamp': instance.endTimestamp,
      'earnedPoints': instance.earnedPoints,
    };
