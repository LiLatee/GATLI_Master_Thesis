import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/question.dart';

part 'questionnaire.g.dart';

// https://www.eortc.org/app/uploads/sites/2/2018/08/Specimen-QLQ-C30-English.pdf
@JsonSerializable(explicitToJson: true, genericArgumentFactories: true)
// ignore: must_be_immutable
class Questionnaire<T> extends Equatable {
  Questionnaire({
    this.id,
    required this.languageCode,
    required this.generalQuestions,
    required this.pastWeekQuestions,
    required this.finalQuestions,
  });

  String? id;
  final String languageCode;
  final List<T> generalQuestions;
  final List<T> pastWeekQuestions;
  final List<T> finalQuestions;

  factory Questionnaire.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$QuestionnaireFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$QuestionnaireToJson(this, toJsonT);

  @override
  List<Object?> get props => [
        id,
        languageCode,
        generalQuestions,
        pastWeekQuestions,
        finalQuestions,
      ];
}

// ignore: non_constant_identifier_names
Questionnaire QLQ_C30 = Questionnaire(
  languageCode: 'en',
  generalQuestions: const [
    Question(
        question:
            'Do you have any trouble doing strenuous activities, like carrying a heavy shopping bag or a suitcase?',
        possibleAnswers: [1, 2, 3, 4]),
    Question(
        question: 'Do you have any trouble taking a long walk?',
        possibleAnswers: [1, 2, 3, 4]),
    Question(
        question:
            'Do you have any trouble taking a short walk outside of the house?',
        possibleAnswers: [1, 2, 3, 4]),
    Question(
        question: 'Do you need to stay in bed or a chair during the day?',
        possibleAnswers: [1, 2, 3, 4]),
    Question(
        question:
            'Do you need help with eating, dressing, washing yourself or using the toilet? ',
        possibleAnswers: [1, 2, 3, 4]),
  ],
  pastWeekQuestions: const [
    Question(
        question:
            'Were you limited in doing either your work or other daily activities?',
        possibleAnswers: [1, 2, 3, 4]),
    Question(
        question:
            'Were you limited in pursuing your hobbies or other leisure time activities? ',
        possibleAnswers: [1, 2, 3, 4]),
    Question(
        question: 'Were you short of breath?', possibleAnswers: [1, 2, 3, 4]),
    Question(question: 'Have you had pain?', possibleAnswers: [1, 2, 3, 4]),
    Question(question: 'Did you need to rest?', possibleAnswers: [1, 2, 3, 4]),
    Question(
        question: 'Have you had trouble sleeping?',
        possibleAnswers: [1, 2, 3, 4]),
    Question(question: 'Have you felt weak?', possibleAnswers: [1, 2, 3, 4]),
    Question(
        question: 'Have you lacked appetite?', possibleAnswers: [1, 2, 3, 4]),
    Question(
        question: 'Have you felt nauseated?', possibleAnswers: [1, 2, 3, 4]),
    Question(question: 'Have you vomited?', possibleAnswers: [1, 2, 3, 4]),
    Question(
        question: 'Have you been constipated?', possibleAnswers: [1, 2, 3, 4]),
    Question(question: 'Have you had diarrhea?', possibleAnswers: [1, 2, 3, 4]),
    Question(question: 'Were you tired?', possibleAnswers: [1, 2, 3, 4]),
    Question(
        question: 'Did pain interfere with your daily activities?',
        possibleAnswers: [1, 2, 3, 4]),
    Question(
        question:
            'Have you had difficulty in concentrating on things, like reading a newspaper or watching television? ',
        possibleAnswers: [1, 2, 3, 4]),
    Question(question: 'Did you feel tense?', possibleAnswers: [1, 2, 3, 4]),
    Question(question: 'Did you worry?', possibleAnswers: [1, 2, 3, 4]),
    Question(
        question: 'Did you feel irritable?', possibleAnswers: [1, 2, 3, 4]),
    Question(
        question: 'Did you feel depressed?', possibleAnswers: [1, 2, 3, 4]),
    Question(
        question: 'Have you had difficulty remembering things? ',
        possibleAnswers: [1, 2, 3, 4]),
    Question(
        question:
            'Has your physical condition or medical treatment interfered with your family life?',
        possibleAnswers: [1, 2, 3, 4]),
    Question(
        question:
            'Has your physical condition or medical treatment interfered with your social activities?',
        possibleAnswers: [1, 2, 3, 4]),
    Question(
        question:
            'Has your physical condition or medical treatment caused you financial difficulties?',
        possibleAnswers: [1, 2, 3, 4]),
  ],
  finalQuestions: const [
    Question(
        question:
            'How would you rate your overall health during the past week?',
        possibleAnswers: [1, 2, 3, 4, 5, 6, 7]),
    Question(
        question:
            'How would you rate your overall quality of life during the past week?',
        possibleAnswers: [1, 2, 3, 4, 5, 6, 7]),
  ],
);
