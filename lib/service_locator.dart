import 'package:get_it/get_it.dart';
import 'package:master_thesis/logic/cubit/launching_cubit.dart';
import 'package:master_thesis/logic/cubit/set_profile_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'presentation/router/app_router.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  //! AppRouter
  sl.registerLazySingleton(() => AppRouter());

  //! Bloc/Cubit
  //* Singletons
  sl.registerLazySingleton(() => SetProfileCubit(prefs: sharedPreferences));
  sl.registerLazySingleton(() => LaunchingCubit(setProfileCubit: sl()));

  //*Factories

  //! Repository

  //! Data source
}
