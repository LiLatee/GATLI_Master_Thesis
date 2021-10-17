import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/question.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/question_user.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire_cubit.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire_intervention_repository.dart';
import 'package:master_thesis/service_locator.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({Key? key}) : super(key: key);

  static const String routeName = '/QLQ-C30';

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  late final PageController pageController;
  late final QuestionnaireCubit cubit;
  int step = 1;
  String stepName = 'General Questions';
  int questionNumber = 1;
  // Map<String, List<QuestionUser>> answers = {};
  Questionnaire<QuestionUser> answeredQuestionnaire =
      Questionnaire<QuestionUser>(
    languageCode: 'en',
    generalQuestions: [],
    pastWeekQuestions: [],
    finalQuestions: [],
  );

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    cubit = QuestionnaireCubit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tell us something'),
      ),
      body: BlocBuilder<QuestionnaireCubit, QuestionnaireState>(
        bloc: cubit,
        builder: (context, state) {
          if (state is QuestionnaireStateLoading) {
            return _buildLoadingWidget();
          } else if (state is QuestionnaireStateLoaded) {
            final Map<String, List<Question>> questions = {
              'General Questions': state.questionnaire.generalQuestions,
              'Past Week Questions': state.questionnaire.pastWeekQuestions,
              'Final Questions': state.questionnaire.finalQuestions,
            };

            return _buildPageView(questions);
          } else {
            return const Center(
              child: Text('Error :/'),
            );
          }
        },
      ),
    );
  }

  Widget _buildPageView(Map<String, List<Question>> questions) {
    final List<Question> allQuestions = [
      ...questions['General Questions']!,
      ...questions['Past Week Questions']!,
      ...questions['Final Questions']!
    ];
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(allQuestions),
            _buildBody(allQuestions),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(List<Question> allQuestions) {
    return Expanded(
      child: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: allQuestions.length,
        controller: pageController,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Text(
                allQuestions[index].question,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 16),
              GroupButton(
                direction: step < 3 ? Axis.vertical : Axis.horizontal,
                isRadio: true,
                buttonWidth: step < 3 ? 150 : 50,
                buttons: step < 3
                    ? [
                        '1. Not at All',
                        '2. A Little',
                        '3. Quite a Bit',
                        '4. Very Much',
                      ]
                    : ['1', '2', '3', '4', '5', '6', '7'],
                onSelected: (index, value) {
                  if (step == 1) {
                    answeredQuestionnaire.generalQuestions
                        .add(QuestionUser.fromQuestion(
                      question: allQuestions[index],
                      answer: index + 1,
                    ));
                  } else if (step == 2) {
                    answeredQuestionnaire.pastWeekQuestions
                        .add(QuestionUser.fromQuestion(
                      question: allQuestions[index],
                      answer: index + 1,
                    ));
                  } else if (step == 3) {
                    answeredQuestionnaire.finalQuestions
                        .add(QuestionUser.fromQuestion(
                      question: allQuestions[index],
                      answer: index + 1,
                    ));
                  }
                  if (questionNumber == allQuestions.length) {
                    sl<QuestionnaireInterventionRepository>()
                        .addQuestionnaire(questionnaire: answeredQuestionnaire);
                  } else {
                    log(answeredQuestionnaire.toString());
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                    _determineStep();
                  }
                },
              ),
              // TextButton(
              //   onPressed: () {
              //     sl<QuestionnaireInterventionRepository>()
              //         .addQuestionnaire(answeredQuestionnaire);
              //     // pageController.nextPage(
              //     //   duration: const Duration(milliseconds: 300),
              //     //   curve: Curves.easeIn,
              //     // );
              //   },
              //   child: const Text('Finish'),
              // )
            ],
          );
        },
      ),
    );
  }

  void _determineStep() {
    return setState(() {
      questionNumber += 1;
      if (questionNumber < 6) {
        step = 1;
        stepName = 'General Questions';
      } else if (questionNumber < 29) {
        step = 2;
        stepName = 'Past Week Questions';
      } else if (questionNumber > 28) {
        step = 3;
        stepName = 'Final Questions';
      }
    });
  }

  Widget _buildHeader(List<Question> allQuestions) {
    return Column(
      children: [
        Text(
          'Step $step of 3',
          style: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          stepName,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          '$questionNumber of 30',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Center _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
