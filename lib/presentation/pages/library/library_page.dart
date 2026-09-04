import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection_container.dart';
import '../../../features/audio/application/audio_controller.dart';
import '../../../features/audio/domain/entities/music_track.dart';
import '../../../features/catalog/demo_tracks.dart';
import '../player/player_page.dart';
import '../playlist/playlist_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _playTrack(MusicTrack track, {int? startIndex}) async {
    final idx = startIndex ??
        demoTracks.indexWhere((t) => t.id == track.id);
    if (idx >= 0) {
      await getIt<AudioController>().setQueue(demoTracks, startIndex: idx);
    } else {
      await getIt<AudioController>().playTrack(track);
    }
    if (mounted) {
      Navigator.pushNamed(context, PlayerPage.routeName);
    }
  }

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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.background,
            title: Text(
              'Your Library',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: AppColors.primary),
                tooltip: 'Create Playlist',
                onPressed: () => _showCreatePlaylistDialog(),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(fontSize: 9),
              tabs: const [
                Tab(text: 'Songs'),
                Tab(text: 'Playlists'),
                Tab(text: 'Albums'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _SongsTab(
              artColors: _artColors,
              onPlay: _playTrack,
            ),
            _PlaylistsTab(),
            _AlbumsTab(
              artColors: _artColors,
              onPlay: (track) => _playTrack(track),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePlaylistDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'New Playlist',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: TextField(
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Playlist name',
            hintStyle: TextStyle(color: AppColors.textSecondary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.textSecondary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Create',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

// ─── Songs Tab ─────────────────────────────────────────────────────────────
class _SongsTab extends StatelessWidget {
  const _SongsTab({required this.artColors, required this.onPlay});

  final List<Color> artColors;
  final Function(MusicTrack, {int? startIndex}) onPlay;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      children: [
        // Liked Songs shortcut
        _SpecialSection(
          icon: Icons.favorite,
          label: 'Liked Songs',
          subtitle: '${demoTracks.length} songs',
          color: const Color(0xFFFF0080),
          onTap: () => onPlay(demoTracks.first, startIndex: 0),
        ),
        const SizedBox(height: 16),
        Text(
          'All Songs',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < demoTracks.length; i++)
          _LibraryTrackTile(
            track: demoTracks[i],
            artColor: artColors[i % artColors.length],
            onTap: () => onPlay(demoTracks[i], startIndex: i),
          ),
      ],
    );
  }
}

// ─── Playlists Tab ─────────────────────────────────────────────────────────
class _PlaylistsTab extends StatelessWidget {
  const _PlaylistsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      children: [
        for (final pl in demoPlaylists)
          _PlaylistTile(
            name: pl['name'] as String,
            count: pl['count'] as int,
            color: Color(pl['color'] as int),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlaylistPage(
                    playlistId: pl['id'] as String,
                    playlistName: pl['name'] as String,
                    accentColor: Color(pl['color'] as int),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

// ─── Albums Tab ────────────────────────────────────────────────────────────
class _AlbumsTab extends StatelessWidget {
  const _AlbumsTab({required this.artColors, required this.onPlay});

  final List<Color> artColors;
  final Function(MusicTrack) onPlay;

  @override
  Widget build(BuildContext context) {
    final albums = <String, List<MusicTrack>>{};
    for (final t in demoTracks) {
      final album = t.album ?? 'Unknown Album';
      albums.putIfAbsent(album, () => []).add(t);
    }
    final albumList = albums.entries.toList();

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: albumList.length,
      itemBuilder: (context, index) {
        final entry = albumList[index];
        final color = artColors[index % artColors.length];
        return GestureDetector(
          onTap: () => onPlay(entry.value.first),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color, color.withOpacity(0.4)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Icon(Icons.album, color: Colors.white, size: 40),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                entry.key,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${entry.value.first.artist} • ${entry.value.length} songs',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Special Section ───────────────────────────────────────────────────────
class _SpecialSection extends StatelessWidget {
  const _SpecialSection({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, color.withOpacity(0.5)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.play_circle_outline,
                  color: AppColors.primary, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Library Track Tile ────────────────────────────────────────────────────
class _LibraryTrackTile extends StatelessWidget {
  const _LibraryTrackTile({
    required this.track,
    required this.artColor,
    required this.onTap,
  });

  final MusicTrack track;
  final Color artColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 2),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [artColor, artColor.withOpacity(0.5)],
          ),
        ),
        child: const Icon(Icons.music_note, color: Colors.white, size: 20),
      ),
      title: Text(
        track.title,
        maxLines: 1,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        track.artist,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert,
            color: AppColors.textSecondary, size: 20),
        onPressed: onTap,
      ),
      onTap: onTap,
    );
  }
}

// ─── Playlist Tile ─────────────────────────────────────────────────────────
class _PlaylistTile extends StatelessWidget {
  const _PlaylistTile({
    required this.name,
    required this.count,
    required this.color,
    required this.onTap,
  });

  final String name;
  final int count;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color, color.withOpacity(0.4)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.playlist_play,
                      color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$count songs',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right,
                    color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
