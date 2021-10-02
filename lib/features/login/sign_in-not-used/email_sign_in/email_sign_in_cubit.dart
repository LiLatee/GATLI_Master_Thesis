import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:master_thesis/features/data/user_app.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/service_locator.dart';

part 'email_sign_in_state.dart';

class EmailSignInCubit extends Cubit<EmailSignInState> {
  EmailSignInCubit() : super(EmailSignInInitial());

  final FirebaseAuth firebaseAuth = sl<FirebaseAuth>();
  final UserRepository userRepository = sl<UserRepository>();

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(EmailLoggingState());
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
      emit(EmailSignInErrorState(error: "Can't sign in: ${e.message}"));
      return;
    }

    log('Login success');

    log(userCredential.additionalUserInfo.toString());
    // log(userCredential.credential!.providerId);
    log(userCredential.user!.uid);

    final failureOrUserApp = await userRepository.getUser();

    failureOrUserApp.fold(
      (failure) {
        log('Error: ${failure.message}');
      },
      (UserApp userApp) {
        emit(EmailLoggedInState());
      },
    );
  }
}
