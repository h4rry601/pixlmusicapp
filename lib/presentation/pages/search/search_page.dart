import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection_container.dart';
import '../../../features/audio/application/audio_controller.dart';
import '../../../features/audio/domain/entities/music_track.dart';
import '../../../features/catalog/demo_tracks.dart';
import '../player/player_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _query = '';
  final _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  static const _categories = [
    {'label': 'Electronic', 'icon': Icons.electric_bolt, 'color': 0xFFFF8800},
    {'label': 'Synthwave', 'icon': Icons.graphic_eq, 'color': 0xFF8800FF},
    {'label': 'Lo-Fi', 'icon': Icons.coffee, 'color': 0xFF00AAFF},
    {'label': 'Chiptune', 'icon': Icons.videogame_asset, 'color': 0xFF00FF88},
    {'label': 'Ambient', 'icon': Icons.cloud, 'color': 0xFFFF0080},
    {'label': 'Dance', 'icon': Icons.nightlife, 'color': 0xFFFFCC00},
    {'label': 'Rock', 'icon': Icons.bolt, 'color': 0xFFFF4444},
    {'label': 'Pop', 'icon': Icons.star, 'color': 0xFF44AAFF},
  ];

  Future<void> _playTrack(MusicTrack track) async {
    final index = demoTracks.indexWhere((t) => t.id == track.id);
    if (index >= 0) {
      await getIt<AudioController>().setQueue(demoTracks, startIndex: index);
    } else {
      await getIt<AudioController>().playTrack(track);
    }
    if (mounted) {
      Navigator.pushNamed(context, PlayerPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final results = _query.isEmpty
        ? <MusicTrack>[]
        : demoTracks.where((track) {
            final value = '${track.title} ${track.artist} ${track.album ?? ''}'
                .toLowerCase();
            return value.contains(_query.toLowerCase());
          }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text(
                  'Search',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),

            // ── Search Bar ───────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: _isFocused
                          ? AppColors.primary
                          : AppColors.surfaceVariant,
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    focusNode: _focusNode,
                    onChanged: (value) => setState(() => _query = value),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Songs, artists, albums...',
                      hintStyle: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      prefixIcon: const Icon(Icons.search,
                          color: AppColors.textSecondary),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close,
                                  color: AppColors.textSecondary, size: 18),
                              onPressed: () => setState(() => _query = ''),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
            ),

            // ── If searching: show results ────────────────────────────
            if (_query.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Text(
                    results.isEmpty
                        ? 'No results for "$_query"'
                        : '${results.length} result${results.length != 1 ? 's' : ''} for "$_query"',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final track = results[index];
                      final artColor =
                          _artColors[index % _artColors.length];
                      return _SearchResultTile(
                        track: track,
                        artColor: artColor,
                        onTap: () => _playTrack(track),
                      );
                    },
                    childCount: results.length,
                  ),
                ),
              ),
            ] else ...[
              // ── Browse Categories ─────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Text(
                    'Browse Categories',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.2,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final cat = _categories[index];
                      return _CategoryTile(
                        label: cat['label'] as String,
                        icon: cat['icon'] as IconData,
                        color: Color(cat['color'] as int),
                        onTap: () {
                          setState(() =>
                              _query = (cat['label'] as String).toLowerCase());
                        },
                      );
                    },
                    childCount: _categories.length,
                  ),
                ),
              ),

              // ── All Songs ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                  child: Text(
                    'All Songs',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final track = demoTracks[index];
                      return _SearchResultTile(
                        track: track,
                        artColor: _artColors[index % _artColors.length],
                        onTap: () => _playTrack(track),
                      );
                    },
                    childCount: demoTracks.length,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
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
}

// ─── Category Tile ─────────────────────────────────────────────────────────
class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withOpacity(0.5)],
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Search Result Tile ────────────────────────────────────────────────────
class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({
    required this.track,
    required this.artColor,
    required this.onTap,
  });

  final MusicTrack track;
  final Color artColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(2),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [artColor, artColor.withOpacity(0.5)],
                    ),
                  ),
                  child: const Icon(Icons.music_note,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
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
                IconButton(
                  icon: const Icon(Icons.play_circle_outline,
                      color: AppColors.primary),
                  onPressed: onTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
