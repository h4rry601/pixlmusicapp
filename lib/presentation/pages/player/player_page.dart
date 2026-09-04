import 'dart:math' as math;
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection_container.dart';
import '../../../features/audio/application/audio_controller.dart';
import '../../../features/audio/domain/entities/playback_snapshot.dart';

class PlayerPage extends StatefulWidget {
  static const String routeName = '/player';

  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isLiked = false;

  static const List<Color> _artGradients = [
    Color(0xFFFF8800),
    Color(0xFFFF0080),
    Color(0xFF8800FF),
    Color(0xFF00AAFF),
    Color(0xFF00FF88),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _format(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Color _artColorFromTitle(String? title) {
    if (title == null) return _artGradients[0];
    final index = title.codeUnits.fold(0, (a, b) => a + b) %
        _artGradients.length;
    return _artGradients[index];
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt<AudioController>();

    return Scaffold(
      backgroundColor: AppColors.playerBackground,
      body: StreamBuilder<PlaybackSnapshot>(
        stream: controller.snapshotStream,
        builder: (context, snapshot) {
          final state = snapshot.data ?? PlaybackSnapshot.empty();
          final item = state.currentItem;
          final duration = item?.duration ?? Duration.zero;
          final maxSeconds =
              duration.inSeconds < 1 ? 1.0 : duration.inSeconds.toDouble();
          final rawPositionSeconds = state.position.inSeconds.toDouble();
          final positionSeconds = rawPositionSeconds.clamp(0.0, maxSeconds);

          final artColor = _artColorFromTitle(item?.title);
          final isShuffle =
              state.shuffleMode != AudioServiceShuffleMode.none;
          final isRepeat =
              state.repeatMode != AudioServiceRepeatMode.none;
          final isRepeatOne =
              state.repeatMode == AudioServiceRepeatMode.one;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  artColor.withOpacity(0.25),
                  AppColors.playerBackground,
                  AppColors.playerBackground,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // ── Top Bar ─────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: Colors.white, size: 30),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'NOW PLAYING',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                  color: Colors.white54,
                                  letterSpacing: 2,
                                ),
                              ),
                              if (item?.album != null)
                                Text(
                                  item!.album!,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                    color: artColor,
                                    fontSize: 9,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert,
                              color: Colors.white70),
                          onPressed: () =>
                              _showMoreOptions(context, item?.title),
                        ),
                      ],
                    ),
                  ),

                  // ── Artwork ─────────────────────────────────────────
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        final scale = state.playing
                            ? _pulseAnimation.value
                            : 0.92;
                        return Transform.scale(
                          scale: scale,
                          child: child,
                        );
                      },
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                artColor,
                                artColor.withOpacity(0.5),
                                const Color(0xFF1A1A1A),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: artColor.withOpacity(
                                    state.playing ? 0.5 : 0.2),
                                blurRadius: 40,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Pixel art grid pattern
                              CustomPaint(
                                painter: _PixelArtPainter(artColor),
                                size: Size.infinite,
                              ),
                              Icon(
                                Icons.music_note_rounded,
                                size: 80,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              if (state.buffering)
                                CircularProgressIndicator(
                                  color: artColor,
                                  strokeWidth: 2,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ── Track Info + Like ────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item?.title ?? 'Nothing Playing',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item?.artist ?? 'Choose a song to play',
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              setState(() => _isLiked = !_isLiked),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Icon(
                              _isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              key: ValueKey(_isLiked),
                              color:
                                  _isLiked ? const Color(0xFFFF0080) : Colors.white54,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Progress Bar ─────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: artColor,
                            inactiveTrackColor: Colors.white12,
                            thumbColor: artColor,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 14),
                            trackHeight: 3,
                          ),
                          child: Slider(
                            value: positionSeconds,
                            max: maxSeconds,
                            onChanged: item == null
                                ? null
                                : (value) => controller.seek(
                                    Duration(seconds: value.round())),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _format(state.position),
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                _format(duration),
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Playback Controls ────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Shuffle
                        _ControlBtn(
                          icon: Icons.shuffle,
                          active: isShuffle,
                          activeColor: artColor,
                          size: 24,
                          onTap: () => controller.setShuffleMode(
                            isShuffle
                                ? AudioServiceShuffleMode.none
                                : AudioServiceShuffleMode.all,
                          ),
                        ),
                        // Previous
                        IconButton(
                          iconSize: 36,
                          icon: const Icon(Icons.skip_previous_rounded,
                              color: Colors.white),
                          onPressed: controller.skipToPrevious,
                        ),
                        // Play/Pause
                        GestureDetector(
                          onTap: item == null
                              ? null
                              : () => controller
                                  .togglePlayPause(state.playing),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: artColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: artColor.withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              state.playing
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                        ),
                        // Next
                        IconButton(
                          iconSize: 36,
                          icon: const Icon(Icons.skip_next_rounded,
                              color: Colors.white),
                          onPressed: controller.skipToNext,
                        ),
                        // Repeat
                        _ControlBtn(
                          icon: isRepeatOne
                              ? Icons.repeat_one
                              : Icons.repeat,
                          active: isRepeat,
                          activeColor: artColor,
                          size: 24,
                          onTap: () {
                            if (!isRepeat) {
                              controller.setRepeatMode(
                                  AudioServiceRepeatMode.all);
                            } else if (!isRepeatOne) {
                              controller.setRepeatMode(
                                  AudioServiceRepeatMode.one);
                            } else {
                              controller.setRepeatMode(
                                  AudioServiceRepeatMode.none);
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  // ── Queue ────────────────────────────────────────────
                  if (state.queue.length > 1) ...[
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'UP NEXT',
                            style:
                                Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white38,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            '${state.queue.length} songs',
                            style:
                                Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white38,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: math.min(state.queue.length, 5),
                        itemBuilder: (context, index) {
                          final qItem = state.queue[index];
                          final isCurrent = qItem.id == item?.id;
                          return ListTile(
                            dense: true,
                            leading: Icon(
                              isCurrent
                                  ? Icons.equalizer
                                  : Icons.music_note,
                              color: isCurrent
                                  ? artColor
                                  : Colors.white38,
                              size: 18,
                            ),
                            title: Text(
                              qItem.title,
                              maxLines: 1,
                              style: TextStyle(
                                color: isCurrent
                                    ? artColor
                                    : Colors.white60,
                                fontSize: 11,
                              ),
                            ),
                            subtitle: Text(
                              qItem.artist ?? '',
                              style: const TextStyle(
                                color: Colors.white30,
                                fontSize: 9,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ] else
                    const Spacer(),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showMoreOptions(BuildContext context, String? title) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ListTile(
              leading: const Icon(Icons.queue_music,
                  color: AppColors.textPrimary),
              title: const Text('Add to Queue',
                  style: TextStyle(color: AppColors.textPrimary)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add,
                  color: AppColors.textPrimary),
              title: const Text('Add to Playlist',
                  style: TextStyle(color: AppColors.textPrimary)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.share,
                  color: AppColors.textPrimary),
              title: const Text('Share',
                  style: TextStyle(color: AppColors.textPrimary)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline,
                  color: AppColors.textPrimary),
              title: const Text('Song Info',
                  style: TextStyle(color: AppColors.textPrimary)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Control Button ────────────────────────────────────────────────────────
class _ControlBtn extends StatelessWidget {
  const _ControlBtn({
    required this.icon,
    required this.active,
    required this.activeColor,
    required this.size,
    required this.onTap,
  });

  final IconData icon;
  final bool active;
  final Color activeColor;
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: size,
      icon: Icon(
        icon,
        color: active ? activeColor : Colors.white38,
      ),
      onPressed: onTap,
    );
  }
}

// ─── Pixel Art Painter ─────────────────────────────────────────────────────
class _PixelArtPainter extends CustomPainter {
  _PixelArtPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    const gridSize = 20.0;
    for (double x = 0; x < size.width; x += gridSize) {
      for (double y = 0; y < size.height; y += gridSize) {
        if ((x / gridSize + y / gridSize).round().isOdd) {
          canvas.drawRect(
            Rect.fromLTWH(x, y, gridSize, gridSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PixelArtPainter oldDelegate) =>
      oldDelegate.color != color;
}
