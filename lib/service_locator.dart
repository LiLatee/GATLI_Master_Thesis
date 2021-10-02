import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:master_thesis/features/app/app_cubit.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_interventions_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_lessons_repository.dart';
import 'package:master_thesis/features/data/user_session_repository.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> initServiceLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  //! Other
  sl.registerLazySingleton(() => AppRouter());
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  //! Bloc/Cubit
  sl.registerLazySingleton(() => AppCubit());

  //! Repository
  // sl.registerLazySingleton(() =>
  //     UserRepository(collection: sl<FirebaseFirestore>().collection('users')));
  sl.registerLazySingleton(() => UserSessionRepository());
  sl.registerLazySingleton(() => ThaiChiLessonsRepository(
      collectionReference:
          sl<FirebaseFirestore>().collection('thai_chi_lessons')));
  sl.registerLazySingleton(() => ThaiChiInterventionsRepository(
      collectionReference:
          sl<FirebaseFirestore>().collection('thai_chi_interventions')));

  //! Data source
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}
