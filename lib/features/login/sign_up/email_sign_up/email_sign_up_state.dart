part of 'email_sign_up_cubit.dart';

abstract class EmailSignUpState extends Equatable {
  const EmailSignUpState();

  @override
  List<Object> get props => [];
}

class EmailSignUpInitial extends EmailSignUpState {}

class EmailSignUpErrorState extends EmailSignUpState {
  const EmailSignUpErrorState({required this.error});

  final String error;
}

class EmailSignUpLoading extends EmailSignUpState {}

class EmailSignUpSuccess extends EmailSignUpState {}



// class AddingFirebaseAccountState extends EmailSignUpState {}

// class AddingUserToFirestoreState extends EmailSignUpState {}

// class UserAddedState extends EmailSignUpState {
//   const UserAddedState({required this.userApp});

//   final UserApp userApp;
// }
