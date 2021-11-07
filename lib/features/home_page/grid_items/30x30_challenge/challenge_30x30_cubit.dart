import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:master_thesis/core/error/failures.dart';
import 'package:master_thesis/features/data/user_app.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/30x30_challenge/challenge_30x30_intervention.dart';
import 'package:master_thesis/features/home_page/grid_items/30x30_challenge/challenge_30x30_intervention_repository.dart';
import 'package:master_thesis/service_locator.dart';

abstract class Challange30x30State extends Equatable {
  @override
  List<Object?> get props => [];
}

class Challange30x30StateLoading extends Challange30x30State {}

class Challange30x30StateError extends Challange30x30State {
  final String message;
  Challange30x30StateError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class Challange30x30StateLoaded extends Challange30x30State {
  final Challenge30x30Intervention intervention;

  Challange30x30StateLoaded({
    required this.intervention,
  });

  @override
  List<Object?> get props => [intervention];
}

class Challenge30x30Cubit extends Cubit<Challange30x30State> {
  Challenge30x30Cubit() : super(Challange30x30StateLoading()) {
    fetchData();
  }

  final UserRepository userRepository = sl<UserRepository>();

  final Challenge30x30InterventionRepository challangeRepository =
      sl<Challenge30x30InterventionRepository>();

  Future<void> fetchData() async {
    final failureOrUser = await userRepository.getUser();
    failureOrUser.fold(
      (DefaultFailure failure) =>
          emit(Challange30x30StateError(message: failure.message)),
      (UserApp userApp) async {
        final failureOrChallangeIntervention =
            await challangeRepository.getChallange30x30Intervention(
                id: userApp.activeInterventions['30x30_challange']![0]);

        failureOrChallangeIntervention.fold(
          (DefaultFailure failure) =>
              emit(Challange30x30StateError(message: failure.message)),
          (intervention) =>
              emit(Challange30x30StateLoaded(intervention: intervention)),
        );
      },
    );
  }
}
