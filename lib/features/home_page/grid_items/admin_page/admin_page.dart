import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:master_thesis/features/data/user_session_repository.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/30x30_challange/challange_30x30_intervention_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/tai_chi/tai_chi_interventions_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/tai_chi/tai_chi_lesson.dart';
import 'package:master_thesis/features/home_page/grid_items/tai_chi/tai_chi_lessons_repository.dart';
import 'package:master_thesis/service_locator.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  static const String routeName = '/adminPage';

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late final TextEditingController _patientIDController;

  Future<void> getCurrentUserId() async {
    final failureOrUserId = await sl<UserSessionRepository>().readSession();
    failureOrUserId.fold(
      (l) => log('AdminPage Error ${l.message}'),
      (String userId) {
        setState(() {
          _patientIDController.text = userId;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _patientIDController = TextEditingController();
    getCurrentUserId();
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
              decoration: const InputDecoration(
                hintText: 'Patient ID',
                label: Text('Patient ID'),
              ),
            ),
            const SizedBox(height: 16),
            _buildAssignTaiChi(),
            const SizedBox(height: 16),
            _buildAddTaiChiLessons(),
            const SizedBox(height: 16),
            TextButton(
              child: const Text('Add QLQ-C30'),
              onPressed: () =>
                  sl<QuestionnaireRepository>().addQuestionnaire(QLQ_C30),
            ),
            const SizedBox(height: 16),
            _buildAssignQuestionnaire(),
            const SizedBox(height: 16),
            _buildAssign30x30Challange(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddTaiChiLessons() {
    return TextButton(
      child: const Text('Add Tai Chi Lessons'),
      onPressed: () =>
          taiChiLessons.forEach(sl<TaiChiLessonsRepository>().addTaiChiLesson),
    );
  }

  Widget _buildAssignTaiChi() {
    return TextButton(
      child: const Text('Assign Tai Chi'),
      onPressed: () async {
        final failureOrDocRef =
            await sl<TaiChiInterventionsRepository>().addTaiChiIntervention(
          userId: _patientIDController.text,
        );
        failureOrDocRef.fold(
          (_) {},
          (docRef) {
            sl<UserRepository>()
                .assignTaiChiIntervention(taiChiInterventionId: docRef.id);
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

  Widget _buildAssign30x30Challange() {
    return TextButton(
      child: const Text('Assign 30x30 Challange'),
      onPressed: () async {
        final failureOrDocRef = await sl<Challange30x30InterventionRepository>()
            .addChallange30x30Intervention(
          userId: _patientIDController.text,
        );

        failureOrDocRef.fold(
          (_) {},
          (docRef) {
            sl<UserRepository>().assign30x30ChallangeIntervention(
                challanhe30x30InterventionId: docRef.id);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _patientIDController.dispose();
  }
}
