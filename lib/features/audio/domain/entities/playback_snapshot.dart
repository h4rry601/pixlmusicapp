import 'package:audio_service/audio_service.dart';

class PlaybackSnapshot {
  const PlaybackSnapshot({
    required this.playing,
    required this.buffering,
    required this.processingState,
    required this.position,
    required this.bufferedPosition,
    required this.queue,
    this.currentItem,
  });

  factory PlaybackSnapshot.empty() {
    return const PlaybackSnapshot(
      playing: false,
      buffering: false,
      processingState: AudioProcessingState.idle,
      position: Duration.zero,
      bufferedPosition: Duration.zero,
      queue: [],
    );
  }

  final bool playing;
  final bool buffering;
  final AudioProcessingState processingState;
  final Duration position;
  final Duration bufferedPosition;
  final List<MediaItem> queue;
  final MediaItem? currentItem;
}
