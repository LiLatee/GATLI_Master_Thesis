import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_intervention.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_interventions_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_lessons_repository.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_lesson.dart';
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
            TextButton(
              child: const Text('Assign Thai Chi'),
              onPressed: () async {
                // final thaiChiIntervention = ThaiChiIntervention(
                //   userId: 'ToeQtJmM48YjgNxvrdo2JEDG5mI2',
                //   lessonsDone: const [],
                //   lessonsToDo: const [],
                //   startTimestamp: DateTime.now().millisecondsSinceEpoch,
                //   endTimestamp: null,
                //   earnedPoints: 0,
                // );

                final failureOrDocRef =
                    await sl<ThaiChiInterventionsRepository>()
                        .addThaiChiIntervention(
                  userId: 'ToeQtJmM48YjgNxvrdo2JEDG5mI2',
                );
                failureOrDocRef.fold(
                  (_) {},
                  (docRef) {
                    sl<UserRepository>().assignThaiChiInterventions(
                        thaiChiInterventionId: docRef.id);
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              child: const Text('Add Thai Chi Lessons'),
              onPressed: () => thaiChiLessons
                  .forEach(sl<ThaiChiLessonsRepository>().addThaiChiLesson),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _patientIDController.dispose();
  }
}
