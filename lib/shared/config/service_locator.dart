import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:uerj_companion/features/auth/data/auth_service.dart';
import 'package:uerj_companion/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uerj_companion/features/cursos/data/cursos_repository.dart';
import 'package:uerj_companion/features/docentes/data/docente_repository.dart';
import 'package:uerj_companion/features/turmas/data/turmas_repository.dart';

final sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton<AuthService>(() => AuthService());
  sl.registerLazySingleton<CursosRepository>(() => CursosRepository());
  sl.registerLazySingleton<DocenteRepository>(() => DocenteRepository());
  sl.registerLazySingleton<TurmasRepository>(() => TurmasRepository());

  sl.registerLazySingleton(
    () => AuthBloc(
      authService: sl<AuthService>(),
      firebaseAuth: FirebaseAuth.instance,
    ),
  );
}
