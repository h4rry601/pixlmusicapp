// lib/presentation/pages/playlist/playlist_page.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection_container.dart';
import '../../../features/audio/application/audio_controller.dart';
import '../../../features/audio/domain/entities/music_track.dart';
import '../../../features/catalog/demo_tracks.dart';
import '../player/player_page.dart';

class PlaylistPage extends StatefulWidget {
  final String playlistId;
  final String? playlistName;
  final Color? accentColor;

  static const String routeName = '/playlist';

  const PlaylistPage({
    super.key,
    required this.playlistId,
    this.playlistName,
    this.accentColor,
  });

  @override
  PlaylistPageState createState() => PlaylistPageState();
}

class PlaylistPageState extends State<PlaylistPage> {
  bool _isShuffled = false;
  bool _isRepeated = false;

  List<MusicTrack> get _tracks {
    // Filter tracks by album/playlist if possible, else use all
    final name = widget.playlistName ?? '';
    final filtered = demoTracks
        .where((t) =>
            (t.album ?? '').toLowerCase().contains(name.toLowerCase()))
        .toList();
    return filtered.isNotEmpty ? filtered : demoTracks;
  }

  Color get _accent => widget.accentColor ?? AppColors.primary;

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

  Future<void> _playAll() async {
    final tracks = _tracks;
    await getIt<AudioController>().setQueue(tracks, startIndex: 0);
    if (mounted) Navigator.pushNamed(context, PlayerPage.routeName);
  }

  Future<void> _playSong(int index) async {
    final tracks = _tracks;
    await getIt<AudioController>().setQueue(tracks, startIndex: index);
    if (mounted) Navigator.pushNamed(context, PlayerPage.routeName);
  }

  Duration get _totalDuration => _tracks.fold(
        Duration.zero,
        (prev, t) => prev + (t.duration ?? Duration.zero),
      );

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }

  String _formatTrackDuration(Duration? d) {
    if (d == null) return '--:--';
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final tracks = _tracks;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Sliver App Bar ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white70),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white70),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _accent.withOpacity(0.9),
                      _accent.withOpacity(0.3),
                      AppColors.background,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Playlist artwork
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [_accent, _accent.withOpacity(0.4)],
                            ),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: _accent.withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.playlist_play,
                              size: 52, color: Colors.white),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          widget.playlistName ?? 'My Playlist',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${tracks.length} songs • ${_formatDuration(_totalDuration)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Controls ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: _accent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: _playAll,
                      icon: const Icon(Icons.play_arrow, color: Colors.white),
                      label: const Text(
                        'Play All',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _ControlIconBtn(
                    icon: Icons.shuffle,
                    active: _isShuffled,
                    activeColor: _accent,
                    onTap: () {
                      setState(() => _isShuffled = !_isShuffled);
                    },
                  ),
                  const SizedBox(width: 8),
                  _ControlIconBtn(
                    icon: Icons.repeat,
                    active: _isRepeated,
                    activeColor: _accent,
                    onTap: () {
                      setState(() => _isRepeated = !_isRepeated);
                    },
                  ),
                ],
              ),
            ),
          ),

          // ── Songs List ──────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final track = tracks[index];
                  final artColor = _artColors[index % _artColors.length];
                  return _SongItem(
                    songNumber: index + 1,
                    track: track,
                    artColor: artColor,
                    duration: _formatTrackDuration(track.duration),
                    accentColor: _accent,
                    onTap: () => _playSong(index),
                  );
                },
                childCount: tracks.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Control Icon Button ───────────────────────────────────────────────────
class _ControlIconBtn extends StatelessWidget {
  const _ControlIconBtn({
    required this.icon,
    required this.active,
    required this.activeColor,
    required this.onTap,
  });

  final IconData icon;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: active ? activeColor.withOpacity(0.15) : AppColors.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: active ? activeColor : AppColors.surfaceVariant,
        ),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: active ? activeColor : AppColors.textSecondary,
        ),
        onPressed: onTap,
      ),
    );
  }
}

// ─── Song Item ─────────────────────────────────────────────────────────────
class _SongItem extends StatelessWidget {
  const _SongItem({
    required this.songNumber,
    required this.track,
    required this.artColor,
    required this.duration,
    required this.accentColor,
    required this.onTap,
  });

  final int songNumber;
  final MusicTrack track;
  final Color artColor;
  final String duration;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Number / artwork
                SizedBox(
                  width: 44,
                  height: 44,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [artColor, artColor.withOpacity(0.4)],
                          ),
                        ),
                      ),
                      Text(
                        songNumber.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
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
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.textPrimary),
                      ),
                      Text(
                        track.artist,
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                // Duration
                Text(
                  duration,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textDisabled,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.more_vert,
                      color: AppColors.textSecondary, size: 18),
                  onPressed: () => _showOptions(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
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
          children: [
            Container(
              width: 32,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.play_arrow, color: AppColors.primary),
              title: const Text('Play', style: TextStyle(color: AppColors.textPrimary)),
              onTap: () { Navigator.pop(context); onTap(); },
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add, color: AppColors.textPrimary),
              title: const Text('Add to Playlist', style: TextStyle(color: AppColors.textPrimary)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border, color: AppColors.textPrimary),
              title: const Text('Add to Favorites', style: TextStyle(color: AppColors.textPrimary)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.share, color: AppColors.textPrimary),
              title: const Text('Share', style: TextStyle(color: AppColors.textPrimary)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
