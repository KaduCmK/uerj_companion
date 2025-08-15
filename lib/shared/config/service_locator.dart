import 'package:get_it/get_it.dart';
import 'package:uerj_companion/features/auth/data/auth_service.dart';
import 'package:uerj_companion/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton(() => AuthService());

  sl.registerLazySingleton(() => AuthBloc(sl<AuthService>()));
}
