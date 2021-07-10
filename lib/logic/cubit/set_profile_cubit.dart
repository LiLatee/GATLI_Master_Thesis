import 'package:bloc/bloc.dart';
import 'package:master_thesis/core/constants/AppConstants.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'set_profile_state.dart';

class SetProfileCubit extends Cubit<SetProfileState> {
  final SharedPreferences prefs;

  SetProfileCubit({required this.prefs}) : super(ProfileUnset()) {
    if (isProfileSet()) emit(ProfileSet());
  }

  bool isProfileSet() {
    if (prefs.containsKey(SPKeys.setProfile))
      return prefs.getBool(SPKeys.setProfile)!;

    return false;
  }
}
