import 'package:flutter/material.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire_page.dart';
import 'package:master_thesis/features/widgets/whole_screen_width_button.dart';

class QuestionnaireIntroPage extends StatelessWidget {
  const QuestionnaireIntroPage({Key? key}) : super(key: key);

  static const String routeName = '/QLQ-C30-intro';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tell us something')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Hi! 😊',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Theme.of(context).colorScheme.primaryVariant,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '''We are interested in some things about you and your health. Please answer all of the questions yourself that best applies to you. There are no "right" or "wrong" answers. The information that you provide will
remain strictly confidential.

That will help us to better understand your needs and adjust app to you.

In gratitude you will get 500 points!
''',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(height: 16),
              WholeScreenWidthButton(
                label: "Let's begin!",
                onPressed: () =>
                    Navigator.pushNamed(context, QuestionnairePage.routeName),
              )
            ],
          ),
        ),
      ),
    );
  }
}
