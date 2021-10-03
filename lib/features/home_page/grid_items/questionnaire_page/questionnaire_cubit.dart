import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/question.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire_repository.dart';
import 'package:master_thesis/service_locator.dart';

abstract class QuestionnaireState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QuestionnaireStateLoading extends QuestionnaireState {}

class QuestionnaireStateLoaded extends QuestionnaireState {
  QuestionnaireStateLoaded({required this.questionnaire});

  final Questionnaire<Question> questionnaire;
}

class QuestionnaireStateError extends QuestionnaireState {
  QuestionnaireStateError({required this.errorMessage});

  final String errorMessage;
}

class QuestionnaireCubit extends Cubit<QuestionnaireState> {
  QuestionnaireCubit() : super(QuestionnaireStateLoading()) {
    loadData();
  }

  final QuestionnaireRepository _repository = sl<QuestionnaireRepository>();

  Future<void> loadData() async {
    final failureOrQuestionnaire = await _repository.getQuestionnaire();

    failureOrQuestionnaire.fold(
      (l) => emit(QuestionnaireStateError(errorMessage: l.message)),
      (Questionnaire<Question> questionnaire) {
        emit(QuestionnaireStateLoaded(questionnaire: questionnaire));
      },
    );
  }
}
