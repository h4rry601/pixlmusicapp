// lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // For now, just a placeholder to avoid errors

  // Example of how to register dependencies:
  // getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  // getIt.registerLazySingleton<MusicRepository>(() => MusicRepositoryImpl());
  // getIt.registerFactory<LoginBloc>(() => LoginBloc(getIt()));
  // getIt.registerFactory<HomeBloc>(() => HomeBloc(getIt()));
}
