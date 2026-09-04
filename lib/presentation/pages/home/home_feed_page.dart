import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection_container.dart';
import '../../../features/audio/application/audio_controller.dart';
import '../../../features/audio/domain/entities/music_track.dart';
import '../../../features/catalog/demo_tracks.dart';
import '../player/player_page.dart';

class HomeFeedPage extends StatelessWidget {
  const HomeFeedPage({super.key});

  Future<void> _play(BuildContext context, int index) async {
    await getIt<AudioController>().setQueue(demoTracks, startIndex: index);
    if (context.mounted) {
      Navigator.pushNamed(context, PlayerPage.routeName);
    }
  }

  Future<void> _playFeatured(BuildContext context, MusicTrack track) async {
    final index = demoTracks.indexWhere((t) => t.id == track.id);
    if (index >= 0) {
      await getIt<AudioController>().setQueue(demoTracks, startIndex: index);
    } else {
      await getIt<AudioController>().playTrack(track);
    }
    if (context.mounted) {
      Navigator.pushNamed(context, PlayerPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ─── App Bar ───────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.background,
            title: Row(
              children: [
                Image.asset('assets/images/pixl.png', width: 32, height: 32),
                const SizedBox(width: 10),
                Text(
                  'PIXL',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.textSecondary),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),

          // ─── Greeting ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'What do you want\nto listen to?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Featured Banner ───────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: SizedBox(
                height: 160,
                child: PageView.builder(
                  itemCount: featuredTracks.length,
                  itemBuilder: (context, index) {
                    final track = featuredTracks[index];
                    final colors = [
                      [const Color(0xFFFF8800), const Color(0xFFFF0080)],
                      [const Color(0xFF8800FF), const Color(0xFF0044FF)],
                      [const Color(0xFF00AAFF), const Color(0xFF00FF88)],
                    ];
                    final c = colors[index % colors.length];
                    return GestureDetector(
                      onTap: () => _playFeatured(context, track),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: c,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Text(
                                  'FEATURED',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                track.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                track.artist,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // ─── Quick Access ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Access',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickAccessTile(
                          icon: Icons.favorite,
                          label: 'Liked Songs',
                          color: const Color(0xFFFF0080),
                          onTap: () async {
                            await getIt<AudioController>()
                                .setQueue(demoTracks, startIndex: 0);
                            if (context.mounted) {
                              Navigator.pushNamed(
                                  context, PlayerPage.routeName);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickAccessTile(
                          icon: Icons.history,
                          label: 'Recently Played',
                          color: const Color(0xFF00AAFF),
                          onTap: () => _play(context, 0),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickAccessTile(
                          icon: Icons.explore,
                          label: 'Discover',
                          color: const Color(0xFF8800FF),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ─── Music Feed header ─────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 28, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Music Feed',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await getIt<AudioController>()
                          .setQueue(demoTracks, startIndex: 0);
                      if (context.mounted) {
                        Navigator.pushNamed(context, PlayerPage.routeName);
                      }
                    },
                    child: Text(
                      'Play All',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Track List ────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _TrackTile(
                  track: demoTracks[i],
                  index: i,
                  onTap: () => _play(context, i),
                ),
                childCount: demoTracks.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning 🌅';
    if (hour < 17) return 'Good afternoon ☀️';
    if (hour < 21) return 'Good evening 🌆';
    return 'Good night 🌙';
  }
}

// ─── Quick Access Tile ─────────────────────────────────────────────────────
class _QuickAccessTile extends StatelessWidget {
  const _QuickAccessTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: NesContainer(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        backgroundColor: AppColors.surface,
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Track Tile ────────────────────────────────────────────────────────────
class _TrackTile extends StatelessWidget {
  const _TrackTile({
    required this.track,
    required this.index,
    required this.onTap,
  });

  final MusicTrack track;
  final int index;
  final VoidCallback onTap;

  static const List<Color> _artColors = [
    Color(0xFFFF8800),
    Color(0xFFFF0080),
    Color(0xFF8800FF),
    Color(0xFF00AAFF),
    Color(0xFF00FF88),
    Color(0xFFFFCC00),
    Color(0xFF00FFCC),
    Color(0xFFFF4444),
    Color(0xFF44AAFF),
    Color(0xFFFF8844),
  ];

  @override
  Widget build(BuildContext context) {
    final color = _artColors[index % _artColors.length];
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(2),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // Artwork
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color,
                        color.withOpacity(0.5),
                      ],
                    ),
                  ),
                  child: const Icon(Icons.music_note,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${track.artist} • ${track.album ?? ""}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Duration
                if (track.duration != null)
                  Text(
                    _formatDuration(track.duration!),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textDisabled,
                    ),
                  ),
                const SizedBox(width: 4),
                Icon(Icons.play_arrow, color: color, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
