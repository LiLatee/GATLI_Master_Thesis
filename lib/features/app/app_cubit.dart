import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_thesis/features/data/user_session_repository.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/service_locator.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState.initial) {
    checkIfAuthorized();
  }

  final UserSessionRepository userSessionRepository =
      sl<UserSessionRepository>();

  Future<void> checkIfAuthorized() async {
    // emit(AppState.unauthorized);
    // return; // TODO
    final failureOrSession = await userSessionRepository.readSession();

    failureOrSession.fold(
      (_) {
        log('unauthorized');

        emit(AppState.unauthorized);
      },
      (userId) {
        log('authorized');
        sl.registerLazySingleton(() => UserRepository(
            documentReference:
                sl<FirebaseFirestore>().collection('users').doc(userId)));
        emit(AppState.authorized);
      },
    );
  }

  Future<void> logout() async {
    await userSessionRepository.deleteSession();
    sl.unregister<UserRepository>();
    emit(AppState.unauthorized);
  }
}

enum AppState {
  initial,
  authorized,
  unauthorized,
}
