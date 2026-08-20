import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

class PIXLAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  PIXLAudioHandler(this._player) {
    _init();
  }

  final AudioPlayer _player;
  final ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(
    children: [],
  );

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForCurrentSongIndexChanges();
    await _player.setAudioSource(_playlist);
  }

  AudioProcessingState _mapProcessingState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((event) {
      playbackState.add(
        PlaybackState(
          controls: [
            MediaControl.skipToPrevious,
            if (_player.playing) MediaControl.pause else MediaControl.play,
            MediaControl.skipToNext,
            MediaControl.stop,
          ],
          systemActions: const {
            MediaAction.seek,
            MediaAction.seekForward,
            MediaAction.seekBackward,
          },
          androidCompactActionIndices: const [0, 1, 2],
          processingState: _mapProcessingState(_player.processingState),
          playing: _player.playing,
          updatePosition: _player.position,
          bufferedPosition: _player.bufferedPosition,
          speed: _player.speed,
          queueIndex: event.currentIndex,
        ),
      );
    });
  }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) {
      final items = queue.value;
      if (index == null || index < 0 || index >= items.length) return;
      mediaItem.add(items[index]);
    });
  }

  AudioSource _sourceFromMediaItem(MediaItem mediaItem) {
    return AudioSource.uri(Uri.parse(mediaItem.id), tag: mediaItem);
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    queue.add([...queue.value, ...mediaItems]);
    await _playlist.addAll(mediaItems.map(_sourceFromMediaItem).toList());
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    queue.add([...queue.value, mediaItem]);
    await _playlist.add(_sourceFromMediaItem(mediaItem));
  }

  @override
  Future<void> updateQueue(List<MediaItem> queue) async {
    this.queue.add(queue);
    await _playlist.clear();
    await _playlist.addAll(queue.map(_sourceFromMediaItem).toList());
    if (queue.isNotEmpty) {
      mediaItem.add(queue.first);
    }
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    await _player.seek(Duration.zero, index: index);
    await play();
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }
}
