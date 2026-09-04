import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection_container.dart';
import '../../../features/audio/application/audio_controller.dart';
import '../../../features/audio/domain/entities/playback_snapshot.dart';
import '../player/player_page.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  static const List<Color> _artColors = [
    Color(0xFFFF8800),
    Color(0xFFFF0080),
    Color(0xFF8800FF),
    Color(0xFF00AAFF),
    Color(0xFF00FF88),
  ];

  Color _artColorFromTitle(String? title) {
    if (title == null) return _artColors[0];
    final index =
        title.codeUnits.fold(0, (a, b) => a + b) % _artColors.length;
    return _artColors[index];
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt<AudioController>();

    return StreamBuilder<PlaybackSnapshot>(
      stream: controller.snapshotStream,
      builder: (context, snapshot) {
        final state = snapshot.data ?? PlaybackSnapshot.empty();
        final item = state.currentItem;
        if (item == null) return const SizedBox.shrink();

        final artColor = _artColorFromTitle(item.title);
        final duration = item.duration ?? Duration.zero;
        final maxMs = duration.inMilliseconds < 1
            ? 1.0
            : duration.inMilliseconds.toDouble();
        final progressRatio =
            (state.position.inMilliseconds / maxMs).clamp(0.0, 1.0);

        return Material(
          color: AppColors.surfaceVariant,
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, PlayerPage.routeName),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Progress bar
                  LinearProgressIndicator(
                    value: progressRatio,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation<Color>(artColor),
                    minHeight: 2,
                  ),
                  SizedBox(
                    height: 64,
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        // Artwork
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [artColor, artColor.withOpacity(0.5)],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: const Icon(Icons.music_note,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        // Track info
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                item.artist ?? 'Unknown Artist',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Controls
                        IconButton(
                          icon: Icon(
                            state.playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: artColor,
                          ),
                          onPressed: () =>
                              controller.togglePlayPause(state.playing),
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next_rounded,
                              color: AppColors.textSecondary),
                          onPressed: controller.skipToNext,
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
