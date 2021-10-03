import 'package:json_annotation/json_annotation.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/question.dart';

part 'question_user.g.dart';

@JsonSerializable()
class QuestionUser extends Question {
  const QuestionUser({
    required String question,
    required List<int> possibleAnswers,
    required this.answer,
  }) : super(
          question: question,
          possibleAnswers: possibleAnswers,
        );
  final int answer;

  factory QuestionUser.fromJson(Map<String, dynamic> json) =>
      _$QuestionUserFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionUserToJson(this);

  factory QuestionUser.fromQuestion({
    required Question question,
    required int answer,
  }) =>
      QuestionUser(
        question: question.question,
        possibleAnswers: question.possibleAnswers,
        answer: answer,
      );

  @override
  List<Object?> get props => [
        question,
        possibleAnswers,
        answer,
      ];

  QuestionUser copyWith({
    int? answer,
  }) {
    return QuestionUser(
      question: question,
      possibleAnswers: possibleAnswers,
      answer: answer ?? this.answer,
    );
  }
}
