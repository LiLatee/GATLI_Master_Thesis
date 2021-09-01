import 'package:get_it/get_it.dart';
import 'package:master_thesis/features/launching/first_launch/presentation/cubit/set_profile_cubit.dart';
import 'package:master_thesis/features/launching/presentation/cubit/launching_cubit.dart';
import 'package:master_thesis/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> initServiceLocator() async {
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
