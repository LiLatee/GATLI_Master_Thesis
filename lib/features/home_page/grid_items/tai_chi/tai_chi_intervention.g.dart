// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tai_chi_intervention.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaiChiIntervention _$TaiChiInterventionFromJson(Map<String, dynamic> json) =>
    TaiChiIntervention(
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

Map<String, dynamic> _$TaiChiInterventionToJson(TaiChiIntervention instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'lessonsDone': instance.lessonsDone,
      'lessonsToDo': instance.lessonsToDo,
      'startTimestamp': instance.startTimestamp,
      'endTimestamp': instance.endTimestamp,
      'earnedPoints': instance.earnedPoints,
    };
