// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire_intervention.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionnaireIntervention _$QuestionnaireInterventionFromJson(
        Map<String, dynamic> json) =>
    QuestionnaireIntervention(
      id: json['id'] as String,
      userId: json['userId'] as String,
      questionnaire: Questionnaire<QuestionUser>.fromJson(
          json['questionnaire'] as Map<String, dynamic>,
          (value) => QuestionUser.fromJson(value as Map<String, dynamic>)),
    );

Map<String, dynamic> _$QuestionnaireInterventionToJson(
        QuestionnaireIntervention instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'questionnaire': instance.questionnaire.toJson(
        (value) => value.toJson(),
      ),
    };
