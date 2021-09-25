part of 'email_sign_in_cubit.dart';

abstract class EmailSignInState extends Equatable {
  const EmailSignInState();

  @override
  List<Object> get props => [];
}

class EmailSignInInitial extends EmailSignInState {}

class EmailLoggingState extends EmailSignInState {}

class EmailLoggedInState extends EmailSignInState {}

class EmailSignInErrorState extends EmailSignInState {
  const EmailSignInErrorState({required this.error});

  final String error;
}
