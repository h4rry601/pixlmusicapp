import 'dart:math';

import '../../audio/domain/entities/music_track.dart';
import '../domain/entities/discover_playlist.dart';

class RecommendationService {
  final Random _random = Random();

  DiscoverWeeklyPlaylist generateDiscoverWeekly(
    String userId,
    List<MusicTrack> allTracks, {
    int trackCount = 30,
  }) {
    final selected = <MusicTrack>{};
    final shuffled = List<MusicTrack>.from(allTracks)..shuffle(_random);

    for (final track in shuffled) {
      if (selected.length >= trackCount) break;
      selected.add(
        MusicTrack(
          id: 'discover-${track.id}-${_random.nextInt(1000)}',
          title: track.title,
          artist: track.artist,
          album: 'Discover Weekly',
          url: track.url,
          artworkUrl: track.artworkUrl,
          duration: track.duration,
        ),
      );
    }

    final now = DateTime.now();
    final expiresAt = now.add(const Duration(days: 7));

    return DiscoverWeeklyPlaylist(
      id: 'discover-weekly-$userId-${now.millisecondsSinceEpoch}',
      name: 'Discover Weekly',
      description: 'Your weekly mixtape of fresh music. Enjoy new discoveries and deep cuts.',
      coverUrl: 'https://images.unsplash.com/photo-1614613535308-eb5fbd3d2c17?w=400',
      tracks: selected.toList(),
      expiresAt: expiresAt,
      totalMinutes: selected.fold<int>(
        0,
        (sum, track) => sum + (track.duration?.inMinutes ?? 3),
      ),
    );
  }

  BlendPlaylist generateFriendBlend(
    String userId,
    String friendId,
    FriendProfile friend,
    List<MusicTrack> allTracks, {
    int trackCount = 25,
  }) {
    final selected = <MusicTrack>{};
    final shuffled = List<MusicTrack>.from(allTracks)..shuffle(_random);

    for (final track in shuffled) {
      if (selected.length >= trackCount) break;
      selected.add(
        MusicTrack(
          id: 'blend-${track.id}-${_random.nextInt(1000)}',
          title: track.title,
          artist: track.artist,
          album: 'Friend Blend: ${friend.displayName}',
          url: track.url,
          artworkUrl: track.artworkUrl,
          duration: track.duration,
        ),
      );
    }

    final ownerPercent = _random.nextInt(20) + 40;

    return BlendPlaylist(
      id: 'friend-blend-$userId-$friendId',
      name: 'Friend Blend',
      description: 'A mix of music for you and ${friend.displayName}, updated weekly.',
      coverUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ce9f5?w=400',
      tracks: selected.toList(),
      ownerName: 'You',
      ownerAvatarUrl: null,
      ownerContributionPercent: ownerPercent,
      friendContributionPercent: 100 - ownerPercent,
      createdAt: DateTime.now(),
    );
  }

  List<MusicTrack> getDailyMix(
    List<MusicTrack> allTracks,
    String seedGenre, {
    int count = 20,
  }) {
    final pool = allTracks.where((t) {
      return _random.nextBool();
    }).toList();

    pool.shuffle(_random);
    return pool.take(count).toList();
  }

  List<MusicTrack> getRadioFromTrack(
    MusicTrack seedTrack,
    List<MusicTrack> allTracks, {
    int count = 50,
  }) {
    final similar = allTracks.where((t) {
      return t.id != seedTrack.id &&
          (t.artist == seedTrack.artist || t.album == seedTrack.album);
    }).toList();

    similar.shuffle(_random);
    final result = List<MusicTrack>.from(similar.take(count));

    while (result.length < count) {
      final filler = allTracks[_random.nextInt(allTracks.length)];
      if (filler.id != seedTrack.id) {
        result.add(filler);
      }
    }

    return result;
  }

  RecommendationFilters getDefaultFilters() {
    return const RecommendationFilters(
      yearRange: 5,
      excludePlayed: true,
    );
  }
}
