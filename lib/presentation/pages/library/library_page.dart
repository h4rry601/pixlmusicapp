import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../features/catalog/demo_tracks.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Library')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _LibrarySection(icon: Icons.favorite, title: 'Favorites'),
          const _LibrarySection(icon: Icons.playlist_play, title: 'Playlists'),
          const _LibrarySection(icon: Icons.album, title: 'Albums'),
          const SizedBox(height: 18),
          Text('Songs', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          for (final track in demoTracks)
            ListTile(
              leading: const Icon(Icons.music_note, color: AppColors.primary),
              title: Text(track.title),
              subtitle: Text(track.artist),
            ),
        ],
      ),
    );
  }
}

class _LibrarySection extends StatelessWidget {
  const _LibrarySection({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
