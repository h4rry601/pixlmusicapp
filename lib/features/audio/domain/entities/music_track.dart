import 'package:audio_service/audio_service.dart';

class MusicTrack {
  const MusicTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.url,
    this.album,
    this.artworkUrl,
    this.duration,
  });

  final String id;
  final String title;
  final String artist;
  final String url;
  final String? album;
  final String? artworkUrl;
  final Duration? duration;

  MediaItem toMediaItem() {
    return MediaItem(
      id: url,
      title: title,
      artist: artist,
      album: album,
      duration: duration,
      artUri: artworkUrl == null ? null : Uri.parse(artworkUrl!),
      extras: {'trackId': id},
    );
  }

  static MusicTrack fromMediaItem(MediaItem item) {
    return MusicTrack(
      id: item.extras?['trackId'] as String? ?? item.id,
      title: item.title,
      artist: item.artist ?? 'Unknown Artist',
      album: item.album,
      url: item.id,
      artworkUrl: item.artUri?.toString(),
      duration: item.duration,
    );
  }
}
