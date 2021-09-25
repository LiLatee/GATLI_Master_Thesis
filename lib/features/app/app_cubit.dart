import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_thesis/features/data/user_session_repository.dart';
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
      (_) => emit(AppState.unauthorized),
      (_) => emit(AppState.authorized),
    );
  }

  Future<void> logout() async {
    await userSessionRepository.deleteSession();
    emit(AppState.unauthorized);
  }
}

enum AppState {
  initial,
  authorized,
  unauthorized,
}
