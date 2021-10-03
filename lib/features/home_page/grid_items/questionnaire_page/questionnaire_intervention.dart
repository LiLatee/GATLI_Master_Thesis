import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/question_user.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire.dart';

part 'questionnaire_intervention.g.dart';

@JsonSerializable(explicitToJson: true)
class QuestionnaireIntervention extends Equatable {
  const QuestionnaireIntervention({
    required this.id,
    required this.userId,
    required this.questionnaire,
  });

  final String id;
  final String userId;
  final Questionnaire<QuestionUser> questionnaire;

  factory QuestionnaireIntervention.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireInterventionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionnaireInterventionToJson(this);

  @override
  List<Object?> get props => [
        id,
        userId,
        questionnaire,
      ];
}
