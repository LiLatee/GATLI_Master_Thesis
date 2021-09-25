import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_thesis/core/error/failures.dart';
import 'package:master_thesis/features/app/app_cubit.dart';
import 'package:master_thesis/features/data/user_app.dart';
import 'package:master_thesis/features/data/user_session_repository.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/service_locator.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  LoginSuccess() {
    sl<AppCubit>().emit(AppState.authorized);
  }
}

class LoginError extends LoginState {
  LoginError({required this.error});

  final String error;
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final AppCubit appCubit = sl<AppCubit>();
  final FirebaseAuth firebaseAuth = sl<FirebaseAuth>();
  final UserRepository userRepository = sl<UserRepository>();
  final UserSessionRepository userSessionRepository =
      sl<UserSessionRepository>();

  Future<void> signUp({
    required String email,
    required String password,
    required String nickname,
  }) async {
    UserCredential? userCredential;
    emit(LoginLoading());
    try {
      userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      log('Failed with error code: ${e.code}');
      log(e.message.toString());
      emit(LoginError(error: "Can't sign up: ${e.message}"));
      return;
    }

    final UserApp? userApp =
        await _firestoreCreateAccount(userCredential, nickname, email);

    if (userApp != null) {
      userSessionRepository.writeSession(userId: userApp.id!); // TODO !
    }
  }

  Future<UserApp?> _firestoreCreateAccount(
      UserCredential userCredential, String nickname, String email) async {
    final Either<DefaultFailure, DocumentReference?> failureOrRef =
        await userRepository.addUser(
      UserApp(
        id: userCredential.user!.uid, // todo
        nickname: nickname,
        email: email,
        badgesKeys: const [],
        steps: 0,
        kilometers: 0,
      ),
    );

    return await failureOrRef.fold(
      (failure) {
        log('Error: ${failure.message}');
        emit(LoginError(error: failure.message));
        return null;
      },
      (ref) async {
        final failureOrUserApp =
            await userRepository.getUser(ref!.id); // TODO !

        return failureOrUserApp.fold(
          (failure) {
            log('Error: ${failure.message}');
            emit(LoginError(error: failure.message));
            return null;
          },
          (UserApp userApp) {
            log(userApp.toJson());
            emit(LoginSuccess());
            return userApp;
          },
        );
        // userApp.setReference(ref);
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    log('start');
    UserCredential? userCredential;
    try {
      userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      log('Failed with error code: ${e.code}');
      log(e.message.toString());
      emit(LoginError(error: "Can't sign in: ${e.message}"));
      return;
    }

    log('Login success');

    log(userCredential.additionalUserInfo.toString());
    // log(userCredential.credential!.providerId);
    log(userCredential.user!.uid);

    final failureOrUserApp =
        await userRepository.getUser(userCredential.user!.uid);

    failureOrUserApp.fold(
      (failure) {
        log('Error: ${failure.message}');
      },
      (UserApp userApp) {
        userSessionRepository.writeSession(userId: userApp.id!); // TODO !
        emit(LoginSuccess());
      },
    );
  }
}
