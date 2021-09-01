import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:master_thesis/features/launching/first_launch/presentation/cubit/set_profile_cubit.dart';
import 'package:meta/meta.dart';

part 'launching_state.dart';

class LaunchingCubit extends Cubit<LaunchingState> {
  SetProfileCubit setProfileCubit;
  late StreamSubscription setProfileStreamSubscription;

  LaunchingCubit({required this.setProfileCubit}) : super(LaunchingLoading()) {
    log('constructor');

    _checkIsProfileSet();
    _monitorIfProfileChanged();
  }

  void _monitorIfProfileChanged() {
    log('_monitorIfProfileChanged');

    setProfileStreamSubscription = setProfileCubit.stream.listen((event) {
      if (event is ProfileSet) {
        log('_monitorIfProfileChanged - LaunchingHomeScreen');

        emit(LaunchingHomeScreen());
      } else if (event is ProfileUnset) {
        log('_monitorIfProfileChanged - LaunchingSetProfile');

        emit(LaunchingSetProfile());
      }
    });
  }

  void _checkIsProfileSet() {
    log('_checkIsProfileSet');

    if (setProfileCubit.state is ProfileSet) {
      log('_checkIsProfileSet - LaunchingHomeScreen');

      emit(LaunchingHomeScreen());
    } else if (setProfileCubit.state is ProfileUnset) {
      log('_checkIsProfileSet - LaunchingSetProfile');

      emit(LaunchingSetProfile());
    }
  }

  @override
  void onChange(Change<LaunchingState> change) {
    log('${change.currentState} => ${change.nextState}');
    super.onChange(change);
  }

  @override
  Future<void> close() {
    setProfileStreamSubscription.cancel();
    return super.close();
  }
}
