// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionUser _$QuestionUserFromJson(Map<String, dynamic> json) => QuestionUser(
      question: json['question'] as String,
      possibleAnswers: (json['possibleAnswers'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      answer: json['answer'] as int,
    );

Map<String, dynamic> _$QuestionUserToJson(QuestionUser instance) =>
    <String, dynamic>{
      'question': instance.question,
      'possibleAnswers': instance.possibleAnswers,
      'answer': instance.answer,
    };
