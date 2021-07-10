import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:master_thesis/core/constants/AppConstants.dart';
import 'package:master_thesis/logic/cubit/set_profile_cubit.dart';
import 'package:meta/meta.dart';

part 'launching_state.dart';

class LaunchingCubit extends Cubit<LaunchingState> {
  SetProfileCubit setProfileCubit;
  late StreamSubscription setProfileStreamSubscription;

  LaunchingCubit({required this.setProfileCubit}) : super(LaunchingLoading()) {
    _checkIsProfileSet();
    _monitorIfProfileChanged();
  }

  void _monitorIfProfileChanged() {
    setProfileStreamSubscription = setProfileCubit.stream.listen((event) {
      if (event is ProfileSet)
        emit(LaunchingHomeScreen());
      else if (event is ProfileUnset) emit(LaunchingSetProfile());
    });
  }

  void _checkIsProfileSet() {
    if (setProfileCubit.state is ProfileSet)
      emit(LaunchingHomeScreen());
    else if (setProfileCubit.state is ProfileUnset) emit(LaunchingSetProfile());
  }

  Future<void> launchSetProfileScreen() async {
    emit(LaunchingSetProfile());
  }

  Future<void> launchHomeScreen() async {
    emit(LaunchingHomeScreen());
  }

  @override
  Future<void> close() {
    setProfileStreamSubscription.cancel();
    return super.close();
  }
}
