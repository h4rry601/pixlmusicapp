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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listen Now')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          NesContainer(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            backgroundColor: AppColors.primary,
            child: const Text(
              'Good day. Fresh picks are queued for your next session.',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Music Feed',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < demoTracks.length; i++)
            _TrackTile(
              track: demoTracks[i],
              trailingIcon: Icons.play_arrow,
              onTap: () => _play(context, i),
            ),
        ],
      ),
    );
  }
}

class _TrackTile extends StatelessWidget {
  const _TrackTile({
    required this.track,
    required this.trailingIcon,
    required this.onTap,
  });

  final MusicTrack track;
  final IconData trailingIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: NesContainer(
        padding: const EdgeInsets.all(12),
        backgroundColor: AppColors.surface,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.album, color: AppColors.primary),
          title: Text(track.title),
          subtitle: Text(track.artist),
          trailing: IconButton(icon: Icon(trailingIcon), onPressed: onTap),
          onTap: onTap,
        ),
      ),
    );
  }
}
