import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection_container.dart';
import '../../../features/audio/application/audio_controller.dart';
import '../../../features/audio/domain/entities/playback_snapshot.dart';
import '../player/player_page.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = getIt<AudioController>();

    return StreamBuilder<PlaybackSnapshot>(
      stream: controller.snapshotStream,
      builder: (context, snapshot) {
        final state = snapshot.data ?? PlaybackSnapshot.empty();
        final item = state.currentItem;
        if (item == null) return const SizedBox.shrink();

        return Material(
          color: AppColors.surfaceVariant,
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, PlayerPage.routeName),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 68,
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.album, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, maxLines: 1),
                          Text(
                            item.artist ?? 'Unknown Artist',
                            maxLines: 1,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(state.playing ? Icons.pause : Icons.play_arrow),
                      onPressed: () => controller.togglePlayPause(state.playing),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: controller.skipToNext,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
