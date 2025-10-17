// lib/presentation/pages/playlist/playlist_page.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../player/player_page.dart';

class PlaylistPage extends StatefulWidget {
  final String playlistId;

  static const String routeName = '/playlist';

  const PlaylistPage({super.key, required this.playlistId});

  @override
  PlaylistPageState createState() => PlaylistPageState();
}

class PlaylistPageState extends State<PlaylistPage> {
  bool _isShuffled = false;
  bool _isRepeated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App bar with playlist info
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withOpacity(0.8),
                      AppColors.secondary.withOpacity(0.6),
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Playlist image
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [AppColors.accent, AppColors.primary],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.playlist_play,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 16),

                      // Playlist name
                      Text(
                        'My Favorite Playlist',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Monospace',
                        ),
                      ),

                      SizedBox(height: 8),

                      // Playlist info
                      Text(
                        '25 songs • 1h 30m',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontFamily: 'Monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.share, color: AppColors.textPrimary),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.more_vert, color: AppColors.textPrimary),
                onPressed: () {},
              ),
            ],
          ),

          // Playlist controls
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  // Play button
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, PlayerPage.routeName);
                      },
                      icon: Icon(Icons.play_arrow),
                      label: Text('Play'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12),

                  // Shuffle button
                  Container(
                    decoration: BoxDecoration(
                      color:
                          _isShuffled ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.shuffle,
                        color:
                            _isShuffled ? Colors.white : AppColors.textPrimary,
                      ),
                      onPressed: () {
                        setState(() {
                          _isShuffled = !_isShuffled;
                        });
                      },
                    ),
                  ),

                  SizedBox(width: 8),

                  // Repeat button
                  Container(
                    decoration: BoxDecoration(
                      color:
                          _isRepeated ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.repeat,
                        color:
                            _isRepeated ? Colors.white : AppColors.textPrimary,
                      ),
                      onPressed: () {
                        setState(() {
                          _isRepeated = !_isRepeated;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Songs list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _SongItem(
                  songNumber: index + 1,
                  title: 'Song ${index + 1}',
                  artist: 'Artist ${index + 1}',
                  duration: '3:${(30 + index).toString().padLeft(2, '0')}',
                  onTap: () {
                    Navigator.pushNamed(context, PlayerPage.routeName);
                  },
                );
              },
              childCount: 25, // Number of songs in playlist
            ),
          ),
        ],
      ),
    );
  }
}

class _SongItem extends StatelessWidget {
  final int songNumber;
  final String title;
  final String artist;
  final String duration;
  final VoidCallback onTap;

  const _SongItem({
    required this.songNumber,
    required this.title,
    required this.artist,
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Song number
          SizedBox(
            width: 30,
            child: Text(
              songNumber.toString(),
              style: TextStyle(
                color: AppColors.textSecondary,
                fontFamily: 'Monospace',
                fontSize: 16,
              ),
            ),
          ),

          SizedBox(width: 16),

          // Song info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontFamily: 'Monospace',
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  artist,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontFamily: 'Monospace',
                  ),
                ),
              ],
            ),
          ),

          // Duration
          Text(
            duration,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontFamily: 'Monospace',
            ),
          ),

          SizedBox(width: 16),

          // More options
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.textSecondary),
            onPressed: () {
              _showSongOptions(context);
            },
          ),
        ],
      ),
    );
  }

  void _showSongOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.play_arrow, color: AppColors.primary),
                  title: Text(
                    'Play',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontFamily: 'Monospace',
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onTap();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.playlist_add,
                    color: AppColors.textPrimary,
                  ),
                  title: Text(
                    'Add to Playlist',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontFamily: 'Monospace',
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: Icon(
                    Icons.favorite_border,
                    color: AppColors.textPrimary,
                  ),
                  title: Text(
                    'Add to Favorites',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontFamily: 'Monospace',
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: Icon(Icons.share, color: AppColors.textPrimary),
                  title: Text(
                    'Share',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontFamily: 'Monospace',
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: AppColors.textPrimary,
                  ),
                  title: Text(
                    'Song Info',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontFamily: 'Monospace',
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
    );
  }
}
