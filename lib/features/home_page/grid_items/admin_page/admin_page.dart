import 'package:flutter/material.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire_intervention_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_interventions_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_lesson.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_lessons_repository.dart';
import 'package:master_thesis/service_locator.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  static const String routeName = '/adminPage';

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late final TextEditingController _patientIDController;

  @override
  void initState() {
    super.initState();
    _patientIDController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextFormField(
              controller: _patientIDController,
              decoration: const InputDecoration(hintText: 'Patient ID'),
            ),
            const SizedBox(height: 16),
            _buildAssignThaiChi(),
            const SizedBox(height: 16),
            _buildAddThaiChiLessons(),
            const SizedBox(height: 16),
            TextButton(
              child: const Text('Add QLQ-C30'),
              onPressed: () =>
                  sl<QuestionnaireRepository>().addQuestionnaire(QLQ_C30),
            ),
            const SizedBox(height: 16),
            _buildAssignQuestionnaire(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddThaiChiLessons() {
    return TextButton(
      child: const Text('Add Thai Chi Lessons'),
      onPressed: () => thaiChiLessons
          .forEach(sl<ThaiChiLessonsRepository>().addThaiChiLesson),
    );
  }

  Widget _buildAssignThaiChi() {
    return TextButton(
      child: const Text('Assign Thai Chi'),
      onPressed: () async {
        final failureOrDocRef =
            await sl<ThaiChiInterventionsRepository>().addThaiChiIntervention(
          userId: 'ToeQtJmM48YjgNxvrdo2JEDG5mI2',
        );
        failureOrDocRef.fold(
          (_) {},
          (docRef) {
            sl<UserRepository>()
                .assignThaiChiIntervention(thaiChiInterventionId: docRef.id);
          },
        );
      },
    );
  }

  Widget _buildAssignQuestionnaire() {
    return TextButton(
      child: const Text('Assign Questionnaire'),
      onPressed: () async {
        await sl<UserRepository>().assignQuestionnaireIntervention();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _patientIDController.dispose();
  }
}