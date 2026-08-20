import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection_container.dart';
import '../../../features/audio/application/audio_controller.dart';
import '../../../features/catalog/demo_tracks.dart';
import '../player/player_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final results = demoTracks.where((track) {
      final value = '${track.title} ${track.artist}'.toLowerCase();
      return value.contains(_query.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            onChanged: (value) => setState(() => _query = value),
            decoration: const InputDecoration(
              hintText: 'Search songs, artists, albums',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 16),
          for (final track in results)
            ListTile(
              leading: const Icon(Icons.music_note, color: AppColors.primary),
              title: Text(track.title),
              subtitle: Text(track.artist),
              onTap: () async {
                await getIt<AudioController>().playTrack(track);
                if (context.mounted) {
                  Navigator.pushNamed(context, PlayerPage.routeName);
                }
              },
            ),
        ],
      ),
    );
  }
}
