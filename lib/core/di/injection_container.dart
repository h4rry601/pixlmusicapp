// lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import '../../features/audio/application/audio_controller.dart';
import '../../features/audio/data/services/pixl_audio_handler.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final audioHandler = await AudioService.init(
    builder: () => PIXLAudioHandler(AudioPlayer()),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.pixl.music.playback',
      androidNotificationChannelName: 'PIXL Playback',
      androidNotificationOngoing: true,
    ),
  );

  getIt.registerSingleton<AudioHandler>(audioHandler);
  getIt.registerLazySingleton<AudioController>(
    () => AudioController(getIt<AudioHandler>()),
  );

  // Example of how to register feature dependencies:
  // getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  // getIt.registerLazySingleton<MusicRepository>(() => MusicRepositoryImpl());
  // getIt.registerFactory<LoginBloc>(() => LoginBloc(getIt()));
  // getIt.registerFactory<HomeBloc>(() => HomeBloc(getIt()));
}
