import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection_container.dart';
import '../../../features/audio/application/audio_controller.dart';
import '../../../features/audio/domain/entities/playback_snapshot.dart';

class PlayerPage extends StatelessWidget {
  static const String routeName = '/player';

  const PlayerPage({super.key});

  String _format(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt<AudioController>();

    return Scaffold(
      backgroundColor: AppColors.playerBackground,
      appBar: AppBar(
        title: const Text('Now Playing'),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<PlaybackSnapshot>(
        stream: controller.snapshotStream,
        builder: (context, snapshot) {
          final state = snapshot.data ?? PlaybackSnapshot.empty();
          final item = state.currentItem;
          final duration = item?.duration ?? Duration.zero;
          final maxSeconds = duration.inSeconds < 1
              ? 1.0
              : duration.inSeconds.toDouble();
          final rawPositionSeconds = state.position.inSeconds.toDouble();
          final positionSeconds = rawPositionSeconds.clamp(0.0, maxSeconds);

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 260,
                  height: 260,
                  color: AppColors.primary,
                  child: const Icon(Icons.music_note, size: 88),
                ),
                const SizedBox(height: 32),
                Text(
                  item?.title ?? 'Nothing Playing',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  item?.artist ?? 'Choose a song to start playback',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 32),
                Slider(
                  value: positionSeconds,
                  max: maxSeconds,
                  onChanged: item == null
                      ? null
                      : (value) =>
                          controller.seek(Duration(seconds: value.round())),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_format(state.position)),
                    Text(_format(duration)),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 40,
                      icon: const Icon(Icons.skip_previous),
                      onPressed: controller.skipToPrevious,
                    ),
                    const SizedBox(width: 16),
                    FilledButton(
                      onPressed: item == null
                          ? null
                          : () => controller.togglePlayPause(state.playing),
                      child: Icon(state.playing ? Icons.pause : Icons.play_arrow),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      iconSize: 40,
                      icon: const Icon(Icons.skip_next),
                      onPressed: controller.skipToNext,
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
