// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Questionnaire<T> _$QuestionnaireFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    Questionnaire<T>(
      id: json['id'] as String?,
      languageCode: json['languageCode'] as String,
      generalQuestions:
          (json['generalQuestions'] as List<dynamic>).map(fromJsonT).toList(),
      pastWeekQuestions:
          (json['pastWeekQuestions'] as List<dynamic>).map(fromJsonT).toList(),
      finalQuestions:
          (json['finalQuestions'] as List<dynamic>).map(fromJsonT).toList(),
    );

Map<String, dynamic> _$QuestionnaireToJson<T>(
  Questionnaire<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'id': instance.id,
      'languageCode': instance.languageCode,
      'generalQuestions': instance.generalQuestions.map(toJsonT).toList(),
      'pastWeekQuestions': instance.pastWeekQuestions.map(toJsonT).toList(),
      'finalQuestions': instance.finalQuestions.map(toJsonT).toList(),
    };
