import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:master_thesis/core/error/failures.dart';
import 'package:master_thesis/features/data/user_app.dart';
import 'package:master_thesis/features/data/user_session_repository.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/service_locator.dart';

part 'email_sign_up_state.dart';

class EmailSignUpCubit extends Cubit<EmailSignUpState> {
  EmailSignUpCubit() : super(EmailSignUpInitial());

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
    emit(EmailSignUpLoading());
    try {
      userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      log('Failed with error code: ${e.code}');
      log(e.message.toString());
      emit(EmailSignUpErrorState(error: "Can't sign up: ${e.message}"));
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
        emit(EmailSignUpErrorState(error: failure.message));
        return null;
      },
      (ref) async {
        final failureOrUserApp =
            await userRepository.getUser(ref!.id); // TODO !

        return failureOrUserApp.fold(
          (failure) {
            log('Error: ${failure.message}');
            emit(EmailSignUpErrorState(error: failure.message));
            return null;
          },
          (UserApp userApp) {
            log(userApp.toJson());
            emit(EmailSignUpSuccess());
            return userApp;
          },
        );
        // userApp.setReference(ref);
      },
    );
  }
}
