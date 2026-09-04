import 'package:audio_service/audio_service.dart';
import 'package:rxdart/rxdart.dart';

import '../domain/entities/music_track.dart';
import '../domain/entities/playback_snapshot.dart';

class AudioController {
  const AudioController(this._audioHandler);

  final AudioHandler _audioHandler;

  Stream<PlaybackSnapshot> get snapshotStream {
    return Rx.combineLatest3<
      PlaybackState,
      MediaItem?,
      List<MediaItem>,
      PlaybackSnapshot
    >(
      _audioHandler.playbackState,
      _audioHandler.mediaItem,
      _audioHandler.queue,
      (playbackState, mediaItem, queue) {
        return PlaybackSnapshot(
          playing: playbackState.playing,
          buffering:
              playbackState.processingState == AudioProcessingState.buffering ||
              playbackState.processingState == AudioProcessingState.loading,
          processingState: playbackState.processingState,
          position: playbackState.updatePosition,
          bufferedPosition: playbackState.bufferedPosition,
          currentItem: mediaItem,
          queue: queue,
          shuffleMode: playbackState.shuffleMode,
          repeatMode: playbackState.repeatMode,
        );
      },
    ).startWith(PlaybackSnapshot.empty());
  }

  Future<void> setQueue(List<MusicTrack> tracks, {int startIndex = 0}) async {
    final items = tracks.map((track) => track.toMediaItem()).toList();
    await _audioHandler.updateQueue(items);
    if (items.isNotEmpty) {
      await _audioHandler.skipToQueueItem(startIndex);
    }
  }

  Future<void> playTrack(MusicTrack track) async {
    await setQueue([track]);
  }

  Future<void> play() => _audioHandler.play();

  Future<void> pause() => _audioHandler.pause();

  Future<void> togglePlayPause(bool isPlaying) {
    return isPlaying ? pause() : play();
  }

  Future<void> seek(Duration position) => _audioHandler.seek(position);

  Future<void> skipToNext() => _audioHandler.skipToNext();

  Future<void> skipToPrevious() => _audioHandler.skipToPrevious();

  Future<void> setShuffleMode(AudioServiceShuffleMode mode) =>
      _audioHandler.setShuffleMode(mode);

  Future<void> setRepeatMode(AudioServiceRepeatMode mode) =>
      _audioHandler.setRepeatMode(mode);
}
